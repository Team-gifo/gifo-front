import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../application/gift_packaging_bloc.dart';
import '../../model/gallery_item.dart';

// 갤러리 각 객체의 데이터를 담는 클래스
class MemoryItemData {
  MemoryItemData({required this.id});

  final int id;
  XFile? imageFile;
  String title = '';
  String description = '';
}

class MemoryGallerySettingView extends StatefulWidget {
  const MemoryGallerySettingView({super.key});

  @override
  State<MemoryGallerySettingView> createState() =>
      _MemoryGallerySettingViewState();
}

class _MemoryGallerySettingViewState extends State<MemoryGallerySettingView> {
  final List<MemoryItemData> _items = <MemoryItemData>[MemoryItemData(id: 1)];
  int _nextId = 2; // 다음 객체에 부여할 고유 식별자

  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // BLoC에 기존 갤러리 데이터가 있으면 불러오기
    final blocState = context.read<GiftPackagingBloc>().state;
    if (blocState.gallery.isNotEmpty) {
      _items.clear();
      for (int i = 0; i < blocState.gallery.length; i++) {
        final galleryItem = blocState.gallery[i];
        final memoryItem = MemoryItemData(id: i + 1)
          ..title = galleryItem.title
          ..description = galleryItem.description;
        if (galleryItem.imageUrl.isNotEmpty) {
          memoryItem.imageFile = XFile(galleryItem.imageUrl);
        }
        _items.add(memoryItem);
      }
      _nextId = blocState.gallery.length + 1;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(
    MemoryItemData itemData,
    VoidCallback updateModal,
  ) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          itemData.imageFile = pickedFile;
        });
        updateModal(); // 모달 내부 상태 갱신
      }
    } catch (e) {
      debugPrint('이미지 선택 오류: $e');
    }
  }

  void _removeImage(MemoryItemData itemData, VoidCallback updateModal) {
    setState(() {
      itemData.imageFile = null;
    });
    updateModal();
  }

  // 모달을 통한 데이터 편집
  void _showEditModal(BuildContext context, MemoryItemData itemData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // 내용이 많을 수 있으므로 스크롤 허용
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void updateModal() {
              setModalState(() {});
            }

            return Padding(
              padding: EdgeInsets.only(
                // 키보드가 올라올 때 대비하여 하단 여백 추가
                bottom: MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            '추억 정보 수정',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(modalContext).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 이미지 추가 영역
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: itemData.imageFile == null
                              ? InkWell(
                                  onTap: () =>
                                      _pickImage(itemData, updateModal),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        '이미지 추가',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Image.network(
                                      itemData.imageFile!.path,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: 0,
                                      height: 60,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: <Color>[
                                              Colors.black.withValues(
                                                alpha: 0.5,
                                              ),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Row(
                                        children: <Widget>[
                                          Material(
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                            shape: const CircleBorder(),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () => _pickImage(
                                                itemData,
                                                updateModal,
                                              ),
                                              constraints:
                                                  const BoxConstraints.tightFor(
                                                    width: 36,
                                                    height: 36,
                                                  ),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Material(
                                            color: Colors.black.withValues(
                                              alpha: 0.6,
                                            ),
                                            shape: const CircleBorder(),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () => _removeImage(
                                                itemData,
                                                updateModal,
                                              ),
                                              constraints:
                                                  const BoxConstraints.tightFor(
                                                    width: 36,
                                                    height: 36,
                                                  ),
                                              padding: EdgeInsets.zero,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 제목 영역
                      const Text(
                        '제목',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: itemData.title,
                        onChanged: (String val) {
                          setState(() {
                            itemData.title = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '제목을 입력해주세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 설명 영역
                      const Text(
                        '설명',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        initialValue: itemData.description,
                        maxLines: 4,
                        onChanged: (String val) {
                          setState(() {
                            itemData.description = val;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '설명을 입력해주세요',
                          hintStyle: const TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.of(modalContext).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          '완료',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 600 기준으로 모바일 환경인지 판단 (세로 모드로 전환)
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // 현재 입력된 데이터를 Bloc에 저장
            final List<GalleryItem> galleryItems = _items
                .map(
                  (MemoryItemData item) => GalleryItem(
                    title: item.title,
                    imageUrl: item.imageFile?.path ?? '',
                    description: item.description,
                  ),
                )
                .toList();
            context.read<GiftPackagingBloc>().add(
              SetGalleryItems(galleryItems),
            );

            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        actions: <Widget>[_buildStepIndicator()],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '추억 갤러리 세팅',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Theme(
                data: ThemeData(
                  // 드래그 렌더링을 위해 기본 캔버스 투명하게 처리
                  canvasColor: Colors.transparent,
                ),
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
                    child: Listener(
                      onPointerSignal: (PointerSignalEvent event) {
                        if (event is PointerScrollEvent && !isMobile) {
                          // 데스크톱(가로스크롤) 환경에서 수직 휠 이벤트를 수평 스크롤로 변환
                          if (_scrollController.hasClients) {
                            final double newOffset =
                                _scrollController.offset + event.scrollDelta.dy;
                            _scrollController.jumpTo(
                              newOffset.clamp(
                                _scrollController.position.minScrollExtent,
                                _scrollController.position.maxScrollExtent,
                              ),
                            );
                          }
                        }
                      },
                      child: ReorderableListView.builder(
                        scrollController: _scrollController,
                        scrollDirection: isMobile
                            ? Axis.vertical
                            : Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 16.0,
                        ),
                        itemCount: _items.length,
                        buildDefaultDragHandles: false,
                        proxyDecorator:
                            (
                              Widget child,
                              int index,
                              Animation<double> animation,
                            ) {
                              return Material(
                                type: MaterialType.transparency,
                                child: Stack(
                                  children: <Widget>[
                                    child,
                                    Positioned(
                                      top: 0,
                                      left: 0,
                                      right: isMobile ? 0.0 : 20.0,
                                      bottom: isMobile ? 16.0 : 0.0,
                                      child: IgnorePointer(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16.0,
                                            ),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                        onReorder: (int oldIndex, int newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final MemoryItemData item = _items.removeAt(
                              oldIndex,
                            );
                            _items.insert(newIndex, item);
                          });
                        },
                        footer: _buildAddButton(isMobile),
                        itemBuilder: (BuildContext context, int index) {
                          final MemoryItemData item = _items[index];
                          return isMobile
                              ? _buildSummaryItemMobile(
                                  key: ValueKey<int>(item.id),
                                  index: index,
                                  itemData: item,
                                )
                              : _buildSummaryItemDesktop(
                                  key: ValueKey<int>(item.id),
                                  index: index,
                                  itemData: item,
                                );
                        },
                      ), // ReorderableListView.builder
                    ), // Listener
                  ), // Scrollbar
                ), // ScrollConfiguration
              ), // Theme
            ), // Expanded
          ], // children <Widget>[
        ), // Column
      ), // SafeArea
      bottomNavigationBar: _buildBottomBar(context),
    ); // Scaffold
  }

  // 데스크톱: 리스트가 가로로 진행되므로 카드는 Column 형태
  Widget _buildSummaryItemDesktop({
    required Key key,
    required int index,
    required MemoryItemData itemData,
  }) {
    return Container(
      key: key,
      width: 240, // 썸네일형 세로 카드
      margin: const EdgeInsets.only(right: 20.0),
      // 배경색과 테두리 터치 시 시각적 효과 부여를 위해 Material 활용
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showEditModal(context, itemData),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ReorderableDragStartListener(
                      index: index,
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.drag_indicator, color: Colors.grey),
                      ),
                    ),
                    if (_items.length > 1)
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _items.removeAt(index);
                          });
                        },
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
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
                const SizedBox(height: 16),
                Text(
                  itemData.title.isEmpty ? '제목 없음' : itemData.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: itemData.title.isEmpty ? Colors.grey : Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Text(
                    itemData.description.isEmpty
                        ? '설명 없음'
                        : itemData.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: itemData.description.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 모바일: 리스트가 세로로 진행되므로 카드는 Row 형태
  Widget _buildSummaryItemMobile({
    required Key key,
    required int index,
    required MemoryItemData itemData,
  }) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: Colors.grey.shade200),
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
                    color: Colors.grey.shade100,
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
                if (_items.length > 1)
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 20),
                    onPressed: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 우측 끝 혹은 하단에 배치될 아이템 추가 위젯 빌더
  Widget _buildAddButton(bool isMobile) {
    return Container(
      // 모바일일 때는 카드와 동일하게 전체 폭 사용, 높이는 명시
      width: isMobile ? double.infinity : 120,
      height: isMobile ? 80 : null,
      margin: isMobile
          ? const EdgeInsets.only(bottom: 16.0, top: 8.0)
          : const EdgeInsets.only(right: 24.0, bottom: 8.0, top: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey.shade50,
          side: BorderSide(color: Colors.grey.shade300, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: EdgeInsets.zero,
        ),
        onPressed: () {
          setState(() {
            _items.add(MemoryItemData(id: _nextId++));
          });

          // 항목 추가 후 렌더링이 완료되면 최신 아이템(오른쪽 또는 아래쪽 끝)으로 스크롤 이동
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
        child: isMobile
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_circle_outline,
                    size: 28,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '추억 추가하기',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_circle_outline,
                    size: 40,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '추가하기',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // 하단 진행 상태 표시 텍스트 및 완료 버튼 (BottomNavigationBar)
  Widget _buildBottomBar(BuildContext context) {
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
            Expanded(
              child: Text(
                '추억 갤러리는 사진 혹은 동영상을 필수적으로 넣어야하며, 텍스트는 추가 사항입니다.',
                style: TextStyle(
                  // 모바일(600 미만)일 때는 14, 데스크톱/태블릿 환경에서는 20으로 표시
                  fontSize: MediaQuery.sizeOf(context).width < 600 ? 14 : 20,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 24),
            ElevatedButton(
              onPressed: () {
                // 로컬 MemoryItemData를 freezed GalleryItem 모델로 변환하여 BLoC에 저장
                final List<GalleryItem> galleryItems = _items
                    .map(
                      (MemoryItemData item) => GalleryItem(
                        title: item.title,
                        imageUrl: item.imageFile?.path ?? '',
                        description: item.description,
                      ),
                    )
                    .toList();
                context.read<GiftPackagingBloc>().add(
                  SetGalleryItems(galleryItems),
                );
                context.push('/addgift/delivery-method');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
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
