import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/features/addgift/model/gallery_item.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';
import '../widgets/memory_gallery/memory_edit_form.dart';
import '../widgets/memory_gallery/memory_gallery_bottom_bar.dart';
import '../widgets/memory_gallery/memory_gallery_desktop_body.dart';
import '../widgets/memory_gallery/memory_gallery_mobile_body.dart';
import '../widgets/step_indicator.dart';

class MemoryGallerySettingView extends StatelessWidget {
  const MemoryGallerySettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // GiftPackagingBloc을 주입하여 MemoryGallerySettingBloc이 내부에서 갤러리 데이터를 동기화할 수 있게 합니다.
    return BlocProvider<MemoryGallerySettingBloc>(
      create: (BuildContext context) =>
          MemoryGallerySettingBloc(context.read<GiftPackagingBloc>()),
      child: const _MemoryGallerySettingContent(),
    );
  }
}

class _MemoryGallerySettingContent extends StatefulWidget {
  const _MemoryGallerySettingContent();

  @override
  State<_MemoryGallerySettingContent> createState() =>
      _MemoryGallerySettingViewState();
}

class _MemoryGallerySettingViewState
    extends State<_MemoryGallerySettingContent> {
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initBlocFromPackagingState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // GiftPackagingBloc의 기존 gallery 데이터를 토대로 MemoryGallerySettingBloc을 초기화합니다.
  void _initBlocFromPackagingState() {
    final GiftPackagingState packagingState = context
        .read<GiftPackagingBloc>()
        .state;
    if (packagingState.gallery.isEmpty) return;

    final List<MemoryGalleryItemData> initialItems =
        List<MemoryGalleryItemData>.generate(packagingState.gallery.length, (
          int i,
        ) {
          final GalleryItem item = packagingState.gallery[i];
          return MemoryGalleryItemData(
            id: i + 1,
            title: item.title,
            description: item.description,
            imageFile: item.imageUrl.isNotEmpty ? XFile(item.imageUrl) : null,
          );
        });

    context.read<MemoryGallerySettingBloc>().add(
      InitMemoryGallerySetting(initialItems, packagingState.gallery.length + 1),
    );
  }

  // 이미지 선택 후 BLoC 이벤트로 업데이트합니다.
  Future<void> _pickImage(int itemId) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null && mounted) {
        context.read<MemoryGallerySettingBloc>().add(
          UpdateMemoryItemImage(itemId, pickedFile),
        );
      }
    } catch (e) {
      debugPrint('이미지 선택 오류: $e');
    }
  }

  void _addMemoryItemAndScroll() {
    context.read<MemoryGallerySettingBloc>().add(const AddMemoryItem());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // 모바일: BottomSheet / 데스크톱: 우측 슬라이드 패널
  void _showEditModal(BuildContext context, MemoryGalleryItemData itemData) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;
    final MemoryGallerySettingBloc memoryBloc = context
        .read<MemoryGallerySettingBloc>();

    memoryBloc.add(SelectMemoryItem(itemData.id));

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        builder: (BuildContext modalContext) =>
            BlocProvider<MemoryGallerySettingBloc>.value(
              value: memoryBloc,
              child: MemoryEditForm(
                itemId: itemData.id,
                onPickImage: () => _pickImage(itemData.id),
              ),
            ),
      ).then((_) {
        if (mounted) {
          memoryBloc.add(const ClearMemoryItemSelection());
        }
      });
    } else {
      // 데스크톱: 우측에서 슬라이드로 나타나는 패널
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'dismiss',
        barrierColor: Colors.black.withValues(alpha: 0.5),
        pageBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return Align(
                alignment: Alignment.centerRight,
                child: Material(
                  color: const Color(0xFF1A1A2E),
                  elevation: 8,
                  child: SizedBox(
                    width: 480,
                    height: double.infinity,
                    child: BlocProvider<MemoryGallerySettingBloc>.value(
                      value: memoryBloc,
                      child: MemoryEditForm(
                        itemId: itemData.id,
                        onPickImage: () => _pickImage(itemData.id),
                      ),
                    ),
                  ),
                ),
              );
            },
        transitionBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return SlideTransition(
                position:
                    Tween<Offset>(
                      begin: const Offset(1, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: animation, curve: Curves.easeOut),
                    ),
                child: child,
              );
            },
      ).then((_) {
        if (mounted) {
          memoryBloc.add(const ClearMemoryItemSelection());
        }
      });
    }
  }

  // 모든 아이템이 완전한 데이터를 갖고 있는지 검증합니다.
  bool _canSave(List<MemoryGalleryItemData> items) {
    if (items.isEmpty) return false;
    for (final MemoryGalleryItemData item in items) {
      if (item.title.trim().isEmpty) return false;
      if (item.description.trim().isEmpty) return false;
      if (item.imageFile == null) return false;
    }
    return true;
  }

  // 특정 아이템이 불완전한지 판단합니다.
  bool _isItemIncomplete(MemoryGalleryItemData item) {
    return item.title.trim().isEmpty ||
        item.description.trim().isEmpty ||
        item.imageFile == null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;

    return BlocBuilder<MemoryGallerySettingBloc, MemoryGallerySettingState>(
      builder: (BuildContext context, MemoryGallerySettingState galleryState) {
        final bool canSave = _canSave(galleryState.uiItems);

        return Scaffold(
          backgroundColor: AppColors.darkBg,
          appBar: AppBar(
            toolbarHeight: 68,
            backgroundColor: AppColors.darkBg,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '추억 갤러리',
              style: TextStyle(
                fontFamily: 'WantedSans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.read<MemoryGallerySettingBloc>().add(
                  const SortMemoryItems(MemorySortType.manual),
                );
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
            // 데스크톱에서만 appbar에 진행도 표시
            actions: <Widget>[
              if (!isMobile) const StepIndicator(activeStep: 2),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(painter: GridBackgroundPainter()),
              ),
              SafeArea(
                child: isMobile
                    ? MemoryGalleryMobileBody(
                        galleryState: galleryState,
                        scrollController: _scrollController,
                        onAddItem: _addMemoryItemAndScroll,
                        onItemTap: (MemoryGalleryItemData item) =>
                            _showEditModal(context, item),
                        isItemIncomplete: _isItemIncomplete,
                      )
                    : MemoryGalleryDesktopBody(
                        galleryState: galleryState,
                        scrollController: _scrollController,
                        onAddItem: _addMemoryItemAndScroll,
                        onItemTap: (MemoryGalleryItemData item) =>
                            _showEditModal(context, item),
                        isItemIncomplete: _isItemIncomplete,
                      ),
              ),
            ],
          ),
          bottomNavigationBar: MemoryGalleryBottomBar(
            itemCount: galleryState.uiItems.length,
            canSave: canSave,
            onComplete: () {
              context.read<MemoryGallerySettingBloc>().add(
                const SortMemoryItems(MemorySortType.manual),
              );
              context.push('/addgift/delivery-method');
            },
          ),
        );
      },
    );
  }
}
