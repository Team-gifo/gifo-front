import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

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
  // 상태 관리를 위해 단순 id 리스트 대신 데이터 객체 리스트 사용
  final List<MemoryItemData> _items = <MemoryItemData>[MemoryItemData(id: 1)];
  int _nextId = 2; // 다음 객체에 부여할 고유 식별자

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        // 웹 최적화를 위한 부가 크기 제한 등 설정 가능
      );
      if (pickedFile != null) {
        setState(() {
          _items[index].imageFile = pickedFile;
        });
      }
    } catch (e) {
      debugPrint('이미지 선택 오류: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _items[index].imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
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
                  // 드래그 시 렌더링을 위해 기본 캔버스 투명하게 처리 (외곽 둥근 모서리 보존)
                  canvasColor: Colors.transparent,
                ),
                child: ReorderableListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  itemCount: _items.length,
                  // 하단 우측 햄버거 아이콘 비활성화
                  buildDefaultDragHandles: false,
                  // 드래그 시 시각적 표시 (그림자 제거, 외곽선 추가)
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                        return Material(
                          type: MaterialType.transparency,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: Colors.black, // 드래그 중임을 나타내는 뚜렷한 외곽선
                                width: 3.0,
                              ),
                              // 그림자 제거
                              boxShadow: const <BoxShadow>[],
                            ),
                            // 원래 위젯의 내부 여백/스타일을 유지하도록 child의 속성 일부를 강제할 수 없으므로,
                            // child 자체는 그대로 보여줍니다.
                            child: child,
                          ),
                        );
                      },
                  onReorder: (int oldIndex, int newIndex) {
                    setState(() {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final MemoryItemData item = _items.removeAt(oldIndex);
                      _items.insert(newIndex, item);
                    });
                  },
                  // ReorderableListView의 footer 속성을 이용하여 정렬 영향 받지 않는 추가 위젯 배치
                  footer: _buildAddButton(),
                  itemBuilder: (BuildContext context, int index) {
                    final MemoryItemData item = _items[index];
                    return _buildGalleryItem(
                      key: ValueKey<int>(item.id),
                      index: index,
                      itemData: item,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  // 각 객체(이미지, 제목, 설명이 포함된 카드) 위젯
  Widget _buildGalleryItem({
    required Key key,
    required int index,
    required MemoryItemData itemData,
  }) {
    return Container(
      key: key,
      width: 320, // 가로 너비 고정하여 슬라이드 형태 체감
      margin: const EdgeInsets.only(right: 20.0),
      // 드래그 중이 아닐 때의 기본 디자인
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.grey.shade200),
      ),
      // 컨테이너 내부를 벗어나지 않도록 클리핑하여 둥근 모서리 유지
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // 상단 액션 바: 드래그용 햄버거 아이콘과 삭제 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ReorderableDragStartListener(
                  index: index,
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.menu, color: Colors.grey),
                  ),
                ),
                if (_items.length > 1) // 아이템이 최소 1개는 유지되도록 처리
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        _items.removeAt(index);
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // 1. 이미지 / 동영상 추가 안내 위젯 구역 또는 미리보기
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
                    ? _buildImagePlaceholder(index)
                    : _buildImagePreview(index, itemData.imageFile!),
              ),
            ),
            const SizedBox(height: 24),

            // 2. 제목 입력 영역
            const Text(
              '제목',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (String val) => itemData.title = val,
              controller: TextEditingController(text: itemData.title),
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
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. 설명 입력 영역
            const Text(
              '설명',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              maxLines: 4,
              onChanged: (String val) => itemData.description = val,
              controller: TextEditingController(text: itemData.description),
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
                  borderSide: const BorderSide(color: Colors.black, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 이미지 비어있을 때 표시할 Placeholder 위젯
  Widget _buildImagePlaceholder(int index) {
    return InkWell(
      onTap: () => _pickImage(index),
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
    );
  }

  // 이미지 선택되었을 때 미리보기 및 수정/삭제 버튼 표시
  Widget _buildImagePreview(int index, XFile imageFile) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // 웹 및 그 외 환경 지원을 위해 network 사용 (XFile path가 웹에서는 blob url)
        kIsWeb
            ? Image.network(imageFile.path, fit: BoxFit.cover)
            : Image.network(
                imageFile.path,
                fit: BoxFit.cover,
              ), // 앱 환경에서는 dart:io File 사용이 정석이나 예제 단순화
        // 이미지 그라데이션 오버레이 (버튼 시인성 확보)
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
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 상단 우측 수정/삭제 버튼
        Positioned(
          top: 8,
          right: 8,
          child: Row(
            children: <Widget>[
              // 수정 버튼 (이미지 다시 고르기)
              Material(
                color: Colors.black.withValues(alpha: 0.6),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  onPressed: () => _pickImage(index),
                  constraints: const BoxConstraints.tightFor(
                    width: 36,
                    height: 36,
                  ),
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 8),
              // 삭제 버튼
              Material(
                color: Colors.black.withValues(alpha: 0.6),
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white, size: 20),
                  onPressed: () => _removeImage(index),
                  constraints: const BoxConstraints.tightFor(
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
    );
  }

  // 우측 끝에 배치될 아이템 추가 위젯 빌더 (ReorderableListView의 footer 용)
  Widget _buildAddButton() {
    return Container(
      width: 120, // 일반 카드보다는 작은 크기 유지
      // margin을 통해 기존 아이템들과 간격 균형 맞춤
      margin: const EdgeInsets.only(right: 24.0, bottom: 8.0, top: 8.0),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey.shade50,
          side: BorderSide(color: Colors.grey.shade300, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          padding: EdgeInsets.zero, // 기본 패딩 없애기
        ),
        onPressed: () {
          setState(() {
            _items.add(MemoryItemData(id: _nextId++));
          });
        },
        child: Column(
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
                  // 모바일(600 미만)일 때는 13, 데스크톱/태블릿 환경에서는 16으로 표시
                  fontSize: MediaQuery.sizeOf(context).width < 600 ? 14 : 20,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(width: 24),
            // 우측 완료 버튼 (클릭 시 3단계인 선물 전달 방식 화면으로 라우팅)
            ElevatedButton(
              onPressed: () {
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

  // 상단 진행 단계 인디케이터 위젯 (현재 2단계)
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

  // 인디케이터 원형 위젯 구현
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

  // 인디케이터 연결 선 위젯 구현
  Widget _buildLine({required bool isActive}) {
    return Container(
      width: 16,
      height: 2,
      color: isActive ? Colors.black : Colors.grey.shade200,
    );
  }
}
