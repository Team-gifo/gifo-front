import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/router/app_router.dart';
import '../../application/gift_packaging_bloc.dart';
import '../../model/direct_open_setting_models.dart';
import '../../model/unboxing_content.dart';

class DirectOpenSettingView extends StatefulWidget {
  const DirectOpenSettingView({super.key});

  @override
  State<DirectOpenSettingView> createState() => _DirectOpenSettingViewState();
}

class _DirectOpenSettingViewState extends State<DirectOpenSettingView> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();

  final DirectOpenBeforeData _beforeData = DirectOpenBeforeData();
  final DirectOpenAfterData _afterData = DirectOpenAfterData();

  final TextEditingController _beforeDescController = TextEditingController();
  final TextEditingController _afterNameController = TextEditingController();

  String _selectedBgm = '신나는 생일';

  @override
  void initState() {
    super.initState();
    final blocState = context.read<GiftPackagingBloc>().state;
    if (blocState.receiverName.isNotEmpty) {
      _userNameController.text = blocState.receiverName;
    }
    // 초기 생성된 랜덤 타이틀을 서브타이틀 필드에 세팅
    if (blocState.subTitle.isNotEmpty) {
      _subTitleController.text = blocState.subTitle;
    }

    _userNameController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetReceiverName(_userNameController.text),
      );
    });
    _subTitleController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetSubTitle(_subTitleController.text),
      );
    });

    _beforeDescController.text = _beforeData.description;
    _afterNameController.text = _afterData.itemName;

    _beforeDescController.addListener(() {
      setState(() {
        _beforeData.description = _beforeDescController.text;
      });
    });
    _afterNameController.addListener(() {
      setState(() {
        _afterData.itemName = _afterNameController.text;
      });
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _subTitleController.dispose();
    _beforeDescController.dispose();
    _afterNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isBefore) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isBefore) {
          _beforeData.imageFile = image;
        } else {
          _afterData.imageFile = image;
        }
      });
    }
  }

  void _completePackage() {
    final bloc = context.read<GiftPackagingBloc>();

    // 서브타이틀, BGM 저장
    bloc.add(SetSubTitle(_subTitleController.text.trim()));
    bloc.add(SetBgm(_selectedBgm));

    // 로컬 데이터 -> freezed UnboxingContent 변환
    final UnboxingContent unboxing = UnboxingContent(
      beforeOpen: BeforeOpen(
        imageUrl: _beforeData.imageFile?.path ?? '',
        description: _beforeData.description,
      ),
      afterOpen: AfterOpen(
        itemName: _afterData.itemName,
        imageUrl: _afterData.imageFile?.path ?? '',
      ),
    );

    bloc.add(SetUnboxingContent(unboxing));
    bloc.add(SubmitPackage());

    isPackageComplete = true;
    context.replace('/addgift/package-complete');
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 800;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 68,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: isMobile ? null : _buildTitleBar(),
        actions: <Widget>[_buildStepIndicator()],
      ),
      body: SafeArea(
        child: isMobile
            ? Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: _buildTitleBar(),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildContentSection(),
                    ),
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: _buildContentSection(),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, color: Colors.grey.shade200),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(
                            child: SingleChildScrollView(
                              child: _buildSettingsSection(isMobile: false),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildCompleteButton(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
      bottomNavigationBar: isMobile ? _buildMobileBottomBar() : null,
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
          _buildLine(isActive: true),
          _buildCircle(isActive: true, number: '3'),
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

  Widget _buildTitleBar() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: 100,
          child: TextFormField(
            controller: _userNameController,
            decoration: InputDecoration(
              hintText: '닉네임',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('님의', style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _subTitleController,
            decoration: InputDecoration(
              hintText: '서브 타이틀',
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text('선물 개봉', style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildContentSection() {
    final bool isMobile = MediaQuery.sizeOf(context).width < 800;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (isMobile) ...<Widget>[
            _buildBeforeOpenCard(isMobile: isMobile),
            const SizedBox(height: 24),
            _buildAfterOpenCard(isMobile: isMobile),
          ] else ...<Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: _buildBeforeOpenCard(isMobile: isMobile)),
                const SizedBox(width: 32),
                Expanded(child: _buildAfterOpenCard(isMobile: isMobile)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBeforeOpenCard({bool isMobile = true}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF1FBFA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            '개봉 전',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _pickImage(true),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: isMobile ? 200 : 280,
              height: isMobile ? 200 : 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 2),
                image: _beforeData.imageFile != null
                    ? DecorationImage(
                        image: NetworkImage(_beforeData.imageFile!.path),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _beforeData.imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.card_giftcard,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '상자 이미지 변경',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '설명란 문구',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _beforeDescController,
            decoration: InputDecoration(
              hintText: '상자 하단에 보여질 설명을 입력해주세요.',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAfterOpenCard({bool isMobile = true}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2F2),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Text(
            '개봉 후',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => _pickImage(false),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: isMobile ? 200 : 280,
              height: isMobile ? 200 : 280,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300, width: 2),
                image: _afterData.imageFile != null
                    ? DecorationImage(
                        image: NetworkImage(_afterData.imageFile!.path),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _afterData.imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.image,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '물품 사진 등록',
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('물품 이름', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _afterNameController,
            decoration: InputDecoration(
              hintText: '상품 이름을 기입해주세요.',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'BGM (배경음악)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBgm,
                    isExpanded: true,
                    onChanged: (String? val) {
                      setState(() {
                        _selectedBgm = val!;
                      });
                    },
                    items: <String>['신나는 생일', '잔잔한 음악', '우리의 추억']
                        .map(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, overflow: TextOverflow.ellipsis),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.play_arrow, color: Colors.grey),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompleteButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: _completePackage,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6DE1F1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          '포장 완료',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildMobileBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                _showMobileSettingsModal(context);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                ),
                child: Icon(Icons.settings, color: Colors.grey.shade700),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildCompleteButton()),
          ],
        ),
      ),
    );
  }

  void _showMobileSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return SafeArea(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const Text(
                        '세팅',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSettingsSection(isMobile: true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {});
                          },
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
              ),
            );
          },
        );
      },
    );
  }
}
