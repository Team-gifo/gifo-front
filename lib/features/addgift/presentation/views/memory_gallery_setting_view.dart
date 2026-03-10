import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../application/gift_packaging_bloc.dart';
import '../../application/memory_gallery_setting/memory_gallery_setting_bloc.dart';

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
    final packagingState = context.read<GiftPackagingBloc>().state;
    if (packagingState.gallery.isEmpty) return;

    final List<MemoryGalleryItemData> initialItems =
        List<MemoryGalleryItemData>.generate(packagingState.gallery.length, (
          int i,
        ) {
          final item = packagingState.gallery[i];
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
    final memoryBloc = context.read<MemoryGallerySettingBloc>();

    memoryBloc.add(SelectMemoryItem(itemData.id));

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: const Color(0xFFF8F9FA),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        builder: (BuildContext modalContext) => BlocProvider.value(
          value: memoryBloc,
          child: _MemoryEditForm(
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
                  color: const Color(0xFFF8F9FA),
                  elevation: 8,
                  child: SizedBox(
                    width: 480,
                    height: double.infinity,
                    child: BlocProvider.value(
                      value: memoryBloc,
                      child: _MemoryEditForm(
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
    for (final item in items) {
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
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            toolbarHeight: 68,
            backgroundColor: const Color(0xFFF8F9FA),
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            title: const Text(
              '추억 갤러리',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/');
                }
              },
            ),
            // 데스크톱에서만 appbar에 진행도 표시
            actions: <Widget>[if (!isMobile) _buildStepIndicator()],
          ),
          body: SafeArea(
            child: isMobile
                ? _buildMobileBody(context, galleryState)
                : _buildDesktopBody(context, galleryState),
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
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.photo_library_rounded,
                    size: 22,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '추억 목록 [ ${galleryState.uiItems.length}개 ]',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
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
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('추가'),
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
                    label: const Text('초기화'),
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
                          return _buildDesktopCard(
                            key: ValueKey<int>(item.id),
                            index: index,
                            itemData: item,
                            selectedItemId: galleryState.selectedItemId,
                            hoveredItemId: galleryState.hoveredItemId,
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

  // 데스크톱 카드: Column 정렬 (이미지 상단, 텍스트 하단), 그리드 셀에 맞춰짐
  Widget _buildDesktopCard({
    required Key key,
    required int index,
    required MemoryGalleryItemData itemData,
    required int? selectedItemId,
    required int? hoveredItemId,
  }) {
    final bool isIncomplete = _isItemIncomplete(itemData);
    final bool isHovered = hoveredItemId == itemData.id;

    return MouseRegion(
      key: key,
      onEnter: (_) => context.read<MemoryGallerySettingBloc>().add(
        HoverMemoryItem(itemData.id),
      ),
      onExit: (_) => context.read<MemoryGallerySettingBloc>().add(
        const ClearHoverMemoryItem(),
      ),
      child: ReorderableDragStartListener(
        index: index,
        child: Container(
          // Grid의 여백을 활용하므로 별도의 외부 bottom margin은 주지 않음
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              // 배경 (카드 본체)
              Positioned.fill(
                child: Material(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(
                      color: selectedItemId == itemData.id
                          ? Colors.orange
                          : Colors.grey.shade200,
                      width: selectedItemId == itemData.id ? 2.5 : 1.0,
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => _showEditModal(context, itemData),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // 썸네일 이미지
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: itemData.imageFile != null
                                  ? Image.network(
                                      itemData.imageFile!.path,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(
                                      Icons.photo,
                                      size: 40,
                                      color: Colors.grey.shade300,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // 하단 텍스트 영역
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                itemData.title.isEmpty
                                    ? '제목 없음'
                                    : itemData.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: itemData.title.isEmpty
                                      ? Colors.grey
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                itemData.description.isEmpty
                                    ? '설명 없음'
                                    : itemData.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                  color: itemData.description.isEmpty
                                      ? Colors.grey
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 불완전 아이템 경고 아이콘 (좌측 상단, Stack 최상단)
              if (isIncomplete)
                Positioned(
                  top: -6,
                  left: -6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.priority_high,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),

              // hover 시 삭제 버튼 (우측 상단 튀어나오게, 드래그 무시하기 위해 제어)
              if (isHovered)
                Positioned(
                  top: -6,
                  right: -6,
                  child: GestureDetector(
                    onTap: () {
                      context.read<MemoryGallerySettingBloc>().add(
                        RemoveMemoryItem(itemData.id),
                      );
                      context.read<MemoryGallerySettingBloc>().add(
                        const ClearHoverMemoryItem(),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 데스크톱 추가 카드 (리스트 마지막 자리에 배치, 전체 너비)
  Widget _buildDesktopAddCard() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
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
          Icon(Icons.add_circle_outline, size: 28, color: Colors.grey.shade400),
          const SizedBox(width: 10),
          Text(
            '추억 추가하기',
            style: TextStyle(
              color: Colors.grey.shade600,
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
              Row(
                children: <Widget>[
                  const Icon(Icons.photo_library_rounded, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${galleryState.uiItems.length}개',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('추가'),
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
                    label: const Text('초기화'),
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
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '아직 등록된 추억이 없어요.',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<MemoryGallerySettingBloc>().add(
                        const AddMemoryItem(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('추억 추가하기'),
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
                    return _buildMobileCard(
                      key: ValueKey<int>(item.id),
                      index: index,
                      itemData: item,
                      selectedItemId: galleryState.selectedItemId,
                      itemCount: galleryState.uiItems.length,
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }

  // 모바일 카드 (기존 형태 유지)
  Widget _buildMobileCard({
    required Key key,
    required int index,
    required MemoryGalleryItemData itemData,
    required int? selectedItemId,
    required int itemCount,
  }) {
    final bool isIncomplete = _isItemIncomplete(itemData);

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          Material(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: selectedItemId == itemData.id
                    ? Colors.orange
                    : Colors.grey.shade200,
                width: selectedItemId == itemData.id ? 2.0 : 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _showEditModal(context, itemData),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ReorderableDragStartListener(
                      index: index,
                      child: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 12, 8),
                        child: Icon(Icons.drag_handle, color: Colors.grey),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: itemData.imageFile != null
                          ? Image.network(
                              itemData.imageFile!.path,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.photo,
                              size: 30,
                              color: Colors.grey.shade300,
                            ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            itemData.title.isEmpty ? '제목 없음' : itemData.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: itemData.title.isEmpty
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            itemData.description.isEmpty
                                ? '설명 없음'
                                : itemData.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: itemData.description.isEmpty
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () {
                        context.read<MemoryGallerySettingBloc>().add(
                          RemoveMemoryItem(itemData.id),
                        );
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 불완전 아이템 경고 아이콘: Stack 마지막에 배치하여 드래그 테두리보다 위에 표시
          if (isIncomplete)
            Positioned(
              top: -6,
              left: -6,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.priority_high,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 하단 진행 상태 및 완료 버튼 (BottomNavigationBar)
  Widget _buildBottomBar(BuildContext context, int itemCount, bool canSave) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
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
                  ? () => context.push('/addgift/delivery-method')
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: canSave ? Colors.black : Colors.grey.shade300,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade300,
                disabledForegroundColor: Colors.grey.shade500,
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

  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildCircle(isActive: true, number: '1'),
          _buildLine(isActive: true),
          _buildCircle(isActive: true, number: '2'),
          _buildLine(isActive: false),
          _buildCircle(isActive: false, number: '3'),
        ],
      ),
    );
  }

  Widget _buildCircle({required bool isActive, required String number}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.black : Colors.grey.shade200,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 16,
      height: 2,
      color: isActive ? Colors.black : Colors.grey.shade200,
    );
  }
}

// ------------------------------------------------------------------
// 편집 모달 전용 위젯 (BlocBuilder로 실시간 상태 반영)
// ------------------------------------------------------------------
class _MemoryEditForm extends StatelessWidget {
  final int itemId;
  final VoidCallback onPickImage;

  const _MemoryEditForm({required this.itemId, required this.onPickImage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemoryGallerySettingBloc, MemoryGallerySettingState>(
      builder: (BuildContext context, MemoryGallerySettingState state) {
        final MemoryGalleryItemData? itemData = state.uiItems
            .where((item) => item.id == itemId)
            .firstOrNull;

        if (itemData == null) return const SizedBox.shrink();

        final bool isTitleValid = itemData.title.trim().isNotEmpty;
        final bool isDescriptionValid = itemData.description.trim().isNotEmpty;
        final bool hasImage = itemData.imageFile != null;

        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 32.0,
                    right: 32.0,
                    top: 32.0,
                    bottom: MediaQuery.viewInsetsOf(context).bottom + 32.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // 헤더: 제목 + 닫기 버튼
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 24),
                          const Text(
                            '추억 상세 설정',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 제목 입력 영역
                      const Text(
                        '제목',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: ValueKey<String>('title_$itemId'),
                        initialValue: itemData.title,
                        onChanged: (String val) {
                          context.read<MemoryGallerySettingBloc>().add(
                            UpdateMemoryItemTitle(itemId, val),
                          );
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '제목을 입력해주세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          suffixIcon: itemData.title.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, size: 20),
                                  onPressed: () {
                                    context
                                        .read<MemoryGallerySettingBloc>()
                                        .add(UpdateMemoryItemTitle(itemId, ''));
                                  },
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isTitleValid
                                  ? const Color(0xFF6DE1F1)
                                  : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isTitleValid ? Colors.black26 : Colors.red,
                              width: isTitleValid ? 1.0 : 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isTitleValid
                                  ? const Color(0xFF6DE1F1)
                                  : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          errorText: !isTitleValid
                              ? '제목은 최소 1글자 이상이어야 합니다.'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 이미지 선택 영역
                      const Text(
                        '이미지',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (!hasImage)
                        InkWell(
                          onTap: onPickImage,
                          child: Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.black26,
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add_photo_alternate,
                                size: 40,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Container(
                              constraints: const BoxConstraints(maxHeight: 500),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  itemData.imageFile!.path,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                OutlinedButton.icon(
                                  onPressed: onPickImage,
                                  icon: const Icon(Icons.edit, size: 16),
                                  label: const Text('수정'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.blue,
                                    side: const BorderSide(color: Colors.blue),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<MemoryGallerySettingBloc>()
                                        .add(RemoveMemoryItemImage(itemId));
                                  },
                                  icon: const Icon(Icons.delete, size: 16),
                                  label: const Text('삭제'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 8),

                      // 부적절한 콘텐츠 주의 안내 (gacha_setting_view와 동일한 형식)
                      const Text(
                        '- 부적절한 제목이나 이미지는 신고 대상이 될 수 있으며, 관련 책임은 등록 주체에게 있음을 알려드립니다.',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // 설명 입력 영역
                      const Text(
                        '설명',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: ValueKey<String>('desc_$itemId'),
                        initialValue: itemData.description,
                        maxLines: 4,
                        onChanged: (String val) {
                          context.read<MemoryGallerySettingBloc>().add(
                            UpdateMemoryItemDescription(itemId, val),
                          );
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: '설명을 입력해주세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDescriptionValid
                                  ? const Color(0xFF6DE1F1)
                                  : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDescriptionValid
                                  ? Colors.black26
                                  : Colors.red,
                              width: isDescriptionValid ? 1.0 : 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDescriptionValid
                                  ? const Color(0xFF6DE1F1)
                                  : Colors.red,
                              width: 1.5,
                            ),
                          ),
                          errorText: !isDescriptionValid ? '설명을 입력해주세요.' : null,
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),

              // 하단 버튼 영역 (삭제 + 닫기)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.read<MemoryGallerySettingBloc>().add(
                            RemoveMemoryItem(itemId),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade400,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.red.shade400,
                              width: 1.5,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '삭제',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '닫기',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
