import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/features/addgift/model/gallery_item.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';
import '../widgets/memory_gallery/memory_desktop_card.dart';
import '../widgets/memory_gallery/memory_edit_form.dart';
import '../widgets/memory_gallery/memory_mobile_card.dart';
import '../widgets/step_indicator.dart';

class MemoryGallerySettingView extends StatelessWidget {
  const MemoryGallerySettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // GiftPackagingBloc을 주입하여 MemoryGallerySettingBloc이 내부에서 갤러리 데이터를 동기화할 수 있게 합니다.
    return BlocProvider(
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
    final GiftPackagingState packagingState = context.read<GiftPackagingBloc>().state;
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

  // 모바일: BottomSheet / 데스크톱: 우측 슬라이드 패널
  void _showEditModal(BuildContext context, MemoryGalleryItemData itemData) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;
    final MemoryGallerySettingBloc memoryBloc = context.read<MemoryGallerySettingBloc>();

    memoryBloc.add(SelectMemoryItem(itemData.id));

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFF1A1A2E),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        builder: (BuildContext modalContext) => BlocProvider.value(
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
                    child: BlocProvider.value(
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
            actions: <Widget>[if (!isMobile) const StepIndicator(activeStep: 2)],
          ),
          body: Stack(
            children: <Widget>[
              Positioned.fill(
                child: CustomPaint(painter: GridBackgroundPainter()),
              ),
              SafeArea(
                child: isMobile
                    ? _buildMobileBody(context, galleryState)
                    : _buildDesktopBody(context, galleryState),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomBar(
            context,
            galleryState.uiItems.length,
            canSave,
          ),
        );
      },
    );
  }

  Widget _buildSortButton(
    BuildContext context,
    MemoryGallerySettingState state,
    MemorySortType type,
    String label, {
    bool isMobile = false,
  }) {
    final bool isSelected = state.sortType == type;

    return InkWell(
      onTap: () {
        context.read<MemoryGallerySettingBloc>().add(SortMemoryItems(type));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 12,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.neonPurple.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.neonPurple
                : Colors.white.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              label,
              style: TextStyle(
                fontFamily: 'WantedSans',
                color: isSelected ? AppColors.neonPurple : Colors.white60,
                fontSize: isMobile ? 12 : 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
            if (isSelected) ...<Widget>[
              const SizedBox(width: 4),
              Icon(
                state.isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: isMobile ? 14 : 16,
                color: Colors.white,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // 데스크톱 레이아웃: 헤더(초기화+추가 버튼) + ReorderableListView 세로 스크롤
  // Wrap 기반 그리드는 ReorderableDragStartListener를 지원하지 않아 드래그가 작동하지 않습니다.
  // ------------------------------------------------------------------
  Widget _buildDesktopBody(
    BuildContext context,
    MemoryGallerySettingState galleryState,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // 리스트 바로 위 헤더: 아이템 개수 + 추가/초기화 버튼
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  _buildSortButton(
                    context,
                    galleryState,
                    MemorySortType.createdAt,
                    '생성순',
                  ),
                  _buildSortButton(
                    context,
                    galleryState,
                    MemorySortType.titleKo,
                    '제목 (한글)',
                  ),
                  _buildSortButton(
                    context,
                    galleryState,
                    MemorySortType.titleEn,
                    '제목 (영어)',
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MemoryGallerySettingBloc>().add(
                        const AddMemoryItem(),
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            _scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text(
                      '추가',
                      style: TextStyle(fontFamily: 'PFStardust'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MemoryGallerySettingBloc>().add(
                        const RemoveAllMemoryItems(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text(
                      '초기화',
                      style: TextStyle(fontFamily: 'PFStardust'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 반응형 그리드: 화면 너비에 따라 column 수 유동 조절
          Expanded(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                // 너비에 따라 열 수 자동 결정 (최소 카드 너비 기준 약 160px)
                final double availableWidth = constraints.maxWidth;
                int crossAxisCount;
                if (availableWidth >= 1400) {
                  crossAxisCount = 5;
                } else if (availableWidth >= 1100) {
                  crossAxisCount = 4;
                } else if (availableWidth >= 800) {
                  crossAxisCount = 3;
                } else {
                  crossAxisCount = 2;
                }

                return Theme(
                  data: ThemeData(canvasColor: Colors.transparent),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: <PointerDeviceKind>{
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      child: ReorderableGridView.builder(
                        controller: _scrollController,
                        // 그리드 외곽 padding으로 아이템 잘림 방지
                        padding: const EdgeInsets.fromLTRB(4, 4, 20, 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: galleryState.uiItems.length + 1,
                        onReorder: (int oldIndex, int newIndex) {
                          // 마지막 요소(추가 카드)에 대한 드래그 이벤트 무시
                          if (oldIndex == galleryState.uiItems.length ||
                              newIndex == galleryState.uiItems.length) {
                            return;
                          }
                          context.read<MemoryGallerySettingBloc>().add(
                            ReorderMemoryItems(oldIndex, newIndex),
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          if (index == galleryState.uiItems.length) {
                            return Container(
                              key: const ValueKey<String>('add_card'),
                              child: _buildDesktopAddCard(),
                            );
                          }
                          final MemoryGalleryItemData item =
                              galleryState.uiItems[index];
                          return MemoryDesktopCard(
                            key: ValueKey<int>(item.id),
                            index: index,
                            itemData: item,
                            isIncomplete: _isItemIncomplete(item),
                            isSelected: galleryState.selectedItemId == item.id,
                            isHovered: galleryState.hoveredItemId == item.id,
                            onTap: () => _showEditModal(context, item),
                            onRemove: () {
                              context.read<MemoryGallerySettingBloc>().add(
                                RemoveMemoryItem(item.id),
                              );
                              context.read<MemoryGallerySettingBloc>().add(
                                const ClearHoverMemoryItem(),
                              );
                            },
                            onHoverEnter: () => context
                                .read<MemoryGallerySettingBloc>()
                                .add(HoverMemoryItem(item.id)),
                            onHoverExit: () => context
                                .read<MemoryGallerySettingBloc>()
                                .add(const ClearHoverMemoryItem()),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopAddCard() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.neonPurple.withValues(alpha: 0.05),
        side: BorderSide(
          color: AppColors.neonPurple.withValues(alpha: 0.4),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 36.0),
      ),
      onPressed: () {
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
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.add_circle_outline,
            size: 28,
            color: AppColors.neonPurple.withValues(alpha: 0.7),
          ),
          const SizedBox(width: 10),
          Text(
            '추억 추가하기',
            style: TextStyle(
              fontFamily: 'WantedSans',
              color: AppColors.neonPurple.withValues(alpha: 0.8),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------------
  // 모바일 레이아웃: 기존 세로 스크롤 리스트 유지
  // ------------------------------------------------------------------
  Widget _buildMobileBody(
    BuildContext context,
    MemoryGallerySettingState galleryState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // 헤더: 아이템 개수 + 추가/초기화 버튼
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  _buildSortButton(
                    context,
                    galleryState,
                    MemorySortType.createdAt,
                    '생성순',
                    isMobile: true,
                  ),
                  _buildSortButton(
                    context,
                    galleryState,
                    MemorySortType.titleKo,
                    '제목 (한글)',
                    isMobile: true,
                  ),
                  _buildSortButton(
                    context,
                    galleryState,
                    MemorySortType.titleEn,
                    '제목 (영어)',
                    isMobile: true,
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MemoryGallerySettingBloc>().add(
                        const AddMemoryItem(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text(
                      '추가',
                      style: TextStyle(fontFamily: 'PFStardust'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MemoryGallerySettingBloc>().add(
                        const RemoveAllMemoryItems(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: const Text(
                      '초기화',
                      style: TextStyle(fontFamily: 'PFStardust'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 리스트가 빈 경우: 중앙에 추가하기 버튼 안내
        if (galleryState.uiItems.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.photo_library_outlined,
                    size: 64,
                    color: Colors.white24,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '아직 등록된 추억이 없어요.',
                    style: TextStyle(color: Colors.white38, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MemoryGallerySettingBloc>().add(
                        const AddMemoryItem(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.neonBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      '추억 추가하기',
                      style: TextStyle(fontFamily: 'PFStardust'),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: Theme(
              data: ThemeData(canvasColor: Colors.transparent),
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  dragDevices: <PointerDeviceKind>{
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  },
                ),
                child: ReorderableListView.builder(
                  scrollController: _scrollController,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    top: 8.0,
                  ),
                  itemCount: galleryState.uiItems.length,
                  buildDefaultDragHandles: false,
                  onReorder: (int oldIndex, int newIndex) {
                    context.read<MemoryGallerySettingBloc>().add(
                      ReorderMemoryItems(oldIndex, newIndex),
                    );
                  },
                  // 모바일에는 하단 추가 버튼 없이 헤더의 추가 버튼을 사용합니다.
                  itemBuilder: (BuildContext context, int index) {
                    final MemoryGalleryItemData item =
                        galleryState.uiItems[index];
                    return MemoryMobileCard(
                      key: ValueKey<int>(item.id),
                      index: index,
                      itemData: item,
                      isIncomplete: _isItemIncomplete(item),
                      isSelected: galleryState.selectedItemId == item.id,
                      onTap: () => _showEditModal(context, item),
                      onRemove: () =>
                          context.read<MemoryGallerySettingBloc>().add(
                            RemoveMemoryItem(item.id),
                          ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 하단 진행 상태 및 완료 버튼 (BottomNavigationBar)
  Widget _buildBottomBar(BuildContext context, int itemCount, bool canSave) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: AppColors.darkBg,
          border: Border(
            top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.photo_library_rounded,
                  size: 20,
                  color: Colors.white70,
                ),
                const SizedBox(width: 6),
                Text(
                  '추억 목록 [ $itemCount개 ]',
                  style: const TextStyle(
                    fontFamily: 'WantedSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Spacer(),
            // 저장 조건 안내 Tooltip
            const Tooltip(
              triggerMode: TooltipTriggerMode.tap,
              showDuration: Duration(seconds: 5),
              margin: EdgeInsets.symmetric(horizontal: 24),
              padding: EdgeInsets.all(12),
              textStyle: TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.5,
              ),
              message:
                  '⚠️ 저장 완료 조건\n'
                  '• 추억 최소 1개 이상 등록\n'
                  '• 각 추억에 제목, 이미지, 설명 모두 입력',
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.info_outline, size: 20, color: Colors.grey),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              // 조건 미충족 시 버튼 비활성화
              onPressed: canSave
                  ? () {
                      context.read<MemoryGallerySettingBloc>().add(
                        const SortMemoryItems(MemorySortType.manual),
                      );
                      context.push('/addgift/delivery-method');
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.neonPurple,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.white12,
                disabledForegroundColor: Colors.white38,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 18.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 0,
              ),
              child: const Text(
                '추억 저장 완료',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
