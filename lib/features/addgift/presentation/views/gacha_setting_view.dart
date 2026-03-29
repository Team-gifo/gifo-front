import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/features/addgift/model/gacha_content.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../application/gacha_setting/gacha_setting_bloc.dart';
import '../../application/gift_packaging_bloc.dart';
import '../widgets/gacha/gacha_capsule_item.dart';
import '../widgets/gacha/gacha_mobile_bottom_bar.dart';
import '../widgets/gacha/gacha_settings_panel.dart';
import '../widgets/step_indicator.dart';

class GachaSettingView extends StatelessWidget {
  const GachaSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // GiftPackagingBloc을 주입해서 GachaSettingBloc이 내부에서 직접 SubmitPackage를 dispatch할 수 있도록 합니다.
    return BlocProvider(
      create: (BuildContext context) => GachaSettingBloc(context.read<GiftPackagingBloc>()),
      child: const _GachaSettingContent(),
    );
  }
}

class _GachaSettingContent extends StatefulWidget {
  const _GachaSettingContent();

  @override
  State<_GachaSettingContent> createState() => _GachaSettingContentState();
}

class _GachaSettingContentState extends State<_GachaSettingContent> {
  int? _hoveredItemId;
  int? _selectedItemId;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _subTitleController = TextEditingController();
  final TextEditingController _playCountController = TextEditingController(
    text: '0',
  );

  TextEditingController? _modalNameController;
  TextEditingController? _modalPercentController;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final GiftPackagingState packagingState = context.read<GiftPackagingBloc>().state;

    // 이름/서브타이틀 복원
    if (packagingState.receiverName.isNotEmpty) {
      _userNameController.text = packagingState.receiverName;
    }
    if (packagingState.subTitle.isNotEmpty) {
      _subTitleController.text = packagingState.subTitle;
    }

    // GiftPackagingBloc의 gachaContent에서 UI 아이템 목록과 뽑기 횟수 복원
    final GachaContent? savedGacha = packagingState.gachaContent;
    List<DefaultGachaItemData> initUiItems = <DefaultGachaItemData>[];
    int nextId = 1;

    Color getRandomColor() {
      final Random random = Random();
      return Color.fromARGB(
        255,
        150 + random.nextInt(106),
        150 + random.nextInt(106),
        150 + random.nextInt(106),
      );
    }

    if (savedGacha != null && savedGacha.list.isNotEmpty) {
      for (final GachaItem item in savedGacha.list) {
        initUiItems.add(
          DefaultGachaItemData(
            id: nextId++,
            color: getRandomColor(),
            itemName: item.itemName,
            percentStr: item.percent.toString(),
            percentOpen: item.percentOpen,
            imageFile: item.imageUrl.isNotEmpty ? XFile(item.imageUrl) : null,
          ),
        );
      }
      _playCountController.text = savedGacha.playCount.toString();
    }

    final String initialBgm = packagingState.bgm.isNotEmpty
        ? packagingState.bgm
        : '신나는 생일';

    context.read<GachaSettingBloc>().add(
      InitGachaSetting(initUiItems, nextId, initialBgm),
    );

    _userNameController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetReceiverName(_userNameController.text),
      );
      setState(() {});
    });
    _subTitleController.addListener(() {
      context.read<GiftPackagingBloc>().add(
        SetSubTitle(_subTitleController.text),
      );
      setState(() {});
    });
    _playCountController.addListener(() {
      final int capsuleCount = context.read<GachaSettingBloc>().state.uiItems.length;
      final int rawValue = int.tryParse(_playCountController.text) ?? 0;
      if (rawValue > capsuleCount) {
        _playCountController.text = capsuleCount.toString();
        return;
      }
      context.read<GachaSettingBloc>().add(
        UpdatePlayCount(_playCountController.text),
      );
      setState(() {});
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _subTitleController.dispose();
    _playCountController.dispose();
    _modalNameController?.dispose();
    _modalPercentController?.dispose();
    super.dispose();
  }

  // GachaSettingBloc에 SubmitGachaSetting 이벤트를 dispatch합니다.
  // BLoC 내부에서 데이터를 조합한 뒤 GiftPackagingBloc.SubmitPackage -> _onSubmitPackage -> API 전송 순서로 실행됩니다.
  // 화면 전환은 GiftPackagingBloc의 success 상태를 BlocListener에서 감지해 처리합니다.
  void _completePackage() {
    final GiftPackagingState packagingState = context.read<GiftPackagingBloc>().state;

    context.read<GachaSettingBloc>().add(
      SubmitGachaSetting(
        receiverName: _userNameController.text.trim(),
        subTitle: _subTitleController.text.trim(),
        gallery: packagingState.gallery,
      ),
    );
  }

  Color _getRandomGachaColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      150 + random.nextInt(106),
      150 + random.nextInt(106),
      150 + random.nextInt(106),
    );
  }

  Future<void> _pickImage(
    DefaultGachaItemData itemData,
    VoidCallback updateModal,
  ) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        context.read<GachaSettingBloc>().add(
          UpdateGachaItemImage(itemData.id, pickedFile),
        );
        updateModal(); // 모달 내부 UI 갱신
      }
    } catch (e) {
      debugPrint('이미지 선택 오류: $e');
    }
  }

  void _showEditModal(BuildContext context, DefaultGachaItemData itemData) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;
    final GachaSettingBloc gachaBloc = context.read<GachaSettingBloc>();

    setState(() {
      _selectedItemId = itemData.id;
    });

    // 기존 컨트롤러를 먼저 해제하고 새로 생성하여 덮어씁니다. ( disposed 에러 방지 )
    _modalNameController?.dispose();
    _modalPercentController?.dispose();

    _modalNameController = TextEditingController(text: itemData.itemName);
    _modalPercentController = TextEditingController(text: itemData.percentStr);

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.darkBg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        builder: (BuildContext modalContext) => BlocProvider.value(
          value: gachaBloc,
          child: _buildEditForm(
            modalContext,
            itemData,
            _modalNameController!,
            _modalPercentController!,
          ),
        ),
      ).then((_) {
        // 하단 모달창이 종료될 때 위젯 트리가 완전히 제거되기 전까지 컨트롤러가 메모리상에서 유지되어야 하므로
        // 여기에 있는 컨트롤러 dispose() 동작을 삭제하고 _modalNameController의 생명주기에 맡깁니다.
        setState(() {
          _selectedItemId = null;
        });
      });
    } else {
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
                  color: AppColors.darkBg,
                  elevation: 8,
                  child: SizedBox(
                    width: 480,
                    height: double.infinity,
                    child: BlocProvider.value(
                      value: gachaBloc,
                      child: _buildEditForm(
                        context,
                        itemData,
                        _modalNameController!,
                        _modalPercentController!,
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
        setState(() {
          _selectedItemId = null;
        });
      });
    }
  }

  Widget _buildEditForm(
    BuildContext modalContext,
    DefaultGachaItemData itemData,
    TextEditingController nameController,
    TextEditingController percentController,
  ) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setModalState) {
        // Bloc 상태를 구독하여 모달 내부를 자동 리빌드하기 위함
        return BlocBuilder<GachaSettingBloc, GachaSettingState>(
          builder: (BuildContext context, GachaSettingState state) {
            // 현재 아이템 데이터를 uiItems에서 찾아옵니다.
            final DefaultGachaItemData currentItemData = state.uiItems.firstWhere(
              (DefaultGachaItemData item) => item.id == itemData.id,
              orElse: () => itemData,
            );

            void updateModal() {
              setModalState(() {});
            }

            final bool isTitleValid = currentItemData.itemName
                .trim()
                .isNotEmpty;
            final double? percentValue = double.tryParse(
              currentItemData.percentStr,
            );
            final bool isPercentValid =
                percentValue != null &&
                percentValue >= 0.01 &&
                percentValue <= 100.0;

            double sumWithoutCurrent = 0.0;
            for (final DefaultGachaItemData item in state.uiItems) {
              if (item.id != currentItemData.id) {
                sumWithoutCurrent += item.percent;
              }
            }
            double rem = 100.0 - sumWithoutCurrent;
            if (rem < 0) rem = 0.0;
            String formatPercent(double p) {
              String s = p.toStringAsFixed(2);
              if (s.endsWith('.00')) return s.substring(0, s.length - 3);
              if (s.endsWith('0')) return s.substring(0, s.length - 1);
              return s;
            }

            final String remainingStr = formatPercent(rem);

            Widget buildQuickPercentBtn(String value, String label) {
              return TextButton(
                onPressed: () {
                  final String rawVal = value.replaceAll('%', '');
                  percentController.text = rawVal;
                  context.read<GachaSettingBloc>().add(
                    UpdateGachaItemPercent(currentItemData.id, rawVal),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.neonPurple.withValues(alpha: 0.15),
                  foregroundColor: AppColors.neonPurple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }

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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              const SizedBox(width: 24), // 공간 맞추기용
                              const Text(
                                '캡슐 상세 설정',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.white),
                                onPressed: () =>
                                    Navigator.of(modalContext).pop(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            '제목',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: nameController,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String val) {
                              context.read<GachaSettingBloc>().add(
                                UpdateGachaItemName(currentItemData.id, val),
                              );
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white12,
                              suffixIcon: currentItemData.itemName.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 20, color: Colors.white38),
                                      onPressed: () {
                                        nameController.clear();
                                        context.read<GachaSettingBloc>().add(
                                          UpdateGachaItemName(
                                            currentItemData.id,
                                            '',
                                          ),
                                        );
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: !isTitleValid
                                    ? const BorderSide(color: Colors.red, width: 1.5)
                                    : const BorderSide(color: Color(0xFF6DE1F1), width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: !isTitleValid
                                    ? const BorderSide(color: Colors.red, width: 1.5)
                                    : BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: !isTitleValid
                                    ? const BorderSide(color: Colors.red, width: 1.5)
                                    : const BorderSide(color: Color(0xFF6DE1F1), width: 1.5),
                              ),
                              errorText: !isTitleValid
                                  ? '제목은 최소 1글자 이상이어야 합니다.'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            '이미지',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (currentItemData.imageFile == null)
                            InkWell(
                              onTap: () =>
                                  _pickImage(currentItemData, updateModal),
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.white12,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.add_photo_alternate,
                                    size: 40,
                                    color: Colors.white38,
                                  ),
                                ),
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 500,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      currentItemData.imageFile!.path,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    OutlinedButton.icon(
                                      onPressed: () => _pickImage(
                                        currentItemData,
                                        updateModal,
                                      ),
                                      icon: const Icon(Icons.edit, size: 16),
                                      label: const Text('수정'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.blue,
                                        side: const BorderSide(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        context.read<GachaSettingBloc>().add(
                                          RemoveGachaItemImage(
                                            currentItemData.id,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.delete, size: 16),
                                      label: const Text('삭제'),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          const SizedBox(height: 24),
                          const Text(
                            '- 부적절한 제목이나 이미지는 신고 대상이 될 수 있으며, 관련 책임은 등록 주체에게 있음을 알려드립니다.',
                            style: TextStyle(fontSize: 14, color: Colors.white38),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            '확률 (%)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: percentController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            style: const TextStyle(color: Colors.white),
                            onChanged: (String val) {
                              context.read<GachaSettingBloc>().add(
                                UpdateGachaItemPercent(currentItemData.id, val),
                              );
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white12,
                              suffixIcon: currentItemData.percentStr.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 20, color: Colors.white38),
                                      onPressed: () {
                                        percentController.clear();
                                        context.read<GachaSettingBloc>().add(
                                          UpdateGachaItemPercent(
                                            currentItemData.id,
                                            '',
                                          ),
                                        );
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: !isPercentValid
                                    ? const BorderSide(color: Colors.red, width: 1.5)
                                    : const BorderSide(color: Color(0xFF6DE1F1), width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: !isPercentValid
                                    ? const BorderSide(color: Colors.red, width: 1.5)
                                    : BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: !isPercentValid
                                    ? const BorderSide(color: Colors.red, width: 1.5)
                                    : const BorderSide(color: Color(0xFF6DE1F1), width: 1.5),
                              ),
                              errorText: !isPercentValid
                                  ? '확률은 0.01% 이상 100% 이하입니다.'
                                  : null,
                              errorStyle: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              buildQuickPercentBtn(
                                remainingStr,
                                '(남은 확률) $remainingStr%',
                              ),
                              buildQuickPercentBtn('1', '1%'),
                              buildQuickPercentBtn('10', '10%'),
                              buildQuickPercentBtn('50', '50%'),
                              buildQuickPercentBtn('100', '100%'),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: <Widget>[
                              Checkbox(
                                value: currentItemData.percentOpen,
                                onChanged: (bool? val) {
                                  context.read<GachaSettingBloc>().add(
                                    UpdateGachaItemPercentOpen(
                                      currentItemData.id,
                                      val ?? false,
                                    ),
                                  );
                                },
                                activeColor: AppColors.neonPurple,
                              ),
                              const Expanded(
                                child: Text(
                                  '확률 공개 여부',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '- 모든 캡슐의 확률 합이 100% 이하여야 합니다.',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                  // 모달 바닥에 위치하는 버튼 영역 (Bottom Sheet처럼 배치)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkBg,
                      border: Border(
                        top: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(modalContext).pop();
                              context.read<GachaSettingBloc>().add(
                                RemoveGachaItem(currentItemData.id),
                              );
                              if (_hoveredItemId == currentItemData.id) {
                                setState(() {
                                  _hoveredItemId = null;
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
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
                            onPressed: () {
                              Navigator.of(modalContext).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.neonPurple,
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
      },
    );
  }

  // GiftPackagingBloc의 gachaContent를 기반으로 완료 가능 여부를 판단합니다.
  bool _canComplete() {
    final GiftPackagingState packagingState = context.read<GiftPackagingBloc>().state;
    final GachaContent? gachaContent = packagingState.gachaContent;

    if (gachaContent == null || gachaContent.list.isEmpty) return false;
    if (_userNameController.text.trim().isEmpty) return false;
    if (_subTitleController.text.trim().isEmpty) return false;
    if (gachaContent.playCount < 1) return false;

    for (final GachaItem item in gachaContent.list) {
      if (item.itemName.trim().isEmpty) return false;
      if (item.percent < 0.01 || item.percent > 100.0) return false;
    }

    final double total = gachaContent.list.fold(
      0.0,
      (double sum, GachaItem item) => sum + item.percent,
    );
    if (total < 99.99 || total > 100.01) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GiftPackagingBloc, GiftPackagingState>(
      listenWhen: (GiftPackagingState prev, GiftPackagingState curr) => prev.submitStatus != curr.submitStatus,
      listener: (BuildContext context, GiftPackagingState packagingState) {
        if (packagingState.submitStatus == SubmitStatus.success) {
          // API 전송 성공: 포장 완료 화면으로 이동
          isPackageComplete = true;
          context.replace('/addgift/package-complete');
        } else if (packagingState.submitStatus == SubmitStatus.failure) {
          // API 전송 실패: 스낵바로 에러 안내
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('서버 전송에 실패했습니다. 다시 시도해 주세요.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      // GiftPackagingBloc과 GachaSettingBloc을 모두 구독하여
      // 어느 한 쪽이라도 변경되면 전체 UI를 리빌드합니다.
      child: BlocBuilder<GiftPackagingBloc, GiftPackagingState>(
        builder: (BuildContext context, GiftPackagingState packagingState) {
          return BlocBuilder<GachaSettingBloc, GachaSettingState>(
            builder: (BuildContext context, GachaSettingState gachaState) {
              final bool isMobile = MediaQuery.sizeOf(context).width < 800;

              // 확률 계산 기준: GiftPackagingBloc의 gachaContent
              final List<GachaItem> gachaItems = packagingState.gachaContent?.list ?? <GachaItem>[];
              final double totalPercent = gachaItems.fold(
                0.0,
                (double sum, GachaItem item) => sum + item.percent,
              );
              final double remainPercent = 100.0 - totalPercent;

              final bool isLoading =
                  packagingState.submitStatus == SubmitStatus.loading;

              return Title(
                title: '선물 포장하기 - Gifo',
                color: Colors.black,
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (bool didPop) {
                  if (didPop) return;
                  // 로딩 중에는 뒤로가기 차단
                  if (isLoading) return;
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
                child: Stack(
                  children: <Widget>[
                    Scaffold(
                      backgroundColor: AppColors.darkBg,
                      appBar: AppBar(
                        toolbarHeight: 68,
                        backgroundColor: AppColors.darkBg,
                        surfaceTintColor: Colors.transparent,
                        elevation: 0,
                        leading: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (context.canPop()) {
                                    context.pop();
                                  } else {
                                    context.go('/');
                                  }
                                },
                        ),
                        title: _buildTitleBar(),
                        actions: <Widget>[if (!isMobile) const StepIndicator(activeStep: 3)],
                      ),
                      body: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: CustomPaint(
                              painter: GridBackgroundPainter(),
                            ),
                          ),
                          SafeArea(
                        child: isMobile
                            ? SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      _buildItemsSection(
                                        totalPercent,
                                        remainPercent,
                                        isMobile,
                                        gachaState.uiItems,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Expanded(
                                    flex: 7,
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: _buildItemsSection(
                                        totalPercent,
                                        remainPercent,
                                        isMobile,
                                        gachaState.uiItems,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    color: Colors.white.withValues(alpha: 0.1),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(40.0),
                                      child: GachaSettingsPanel(
                                        isMobile: false,
                                        playCountController: _playCountController,
                                        canComplete: _canComplete(),
                                        onComplete: _completePackage,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        ],
                      ),
                      // 모바일인 경우 하단 네비게이션 적용 (톱니바퀴 모달 + 완료버튼)
                      bottomNavigationBar: isMobile
                          ? GachaMobileBottomBar(
                              totalPercent: totalPercent,
                              itemCount: gachaState.uiItems.length,
                              canComplete: _canComplete(),
                              onComplete: _completePackage,
                              onShowSettings: () =>
                                  _showMobileSettingsModal(context),
                            )
                          : null,
                    ),

                    // 로딩 오버레이: 전송 중 터치 차단 + 프로그레스 표시
                    if (isLoading) _buildLoadingOverlay(),
                  ],
                ),
              ));
            },
          );
        },
      ),
    );
  }

  // 반투명 검정 오버레이 위에 프로그레스 인디케이터와 안내 문구를 표시합니다.
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: 0.55),
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: 52,
                  height: 52,
                  child: CircularProgressIndicator(
                    strokeWidth: 4,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF6DE1F1),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  '선물을 포장하고 있어요...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '잠시만 기다려 주세요.',
                  style: TextStyle(fontSize: 13, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
      ),
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
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '닉네임',
              hintStyle: const TextStyle(color: Colors.white38),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6DE1F1), width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '님의',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 120,
          child: TextFormField(
            controller: _subTitleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: '서브 타이틀',
              hintStyle: const TextStyle(color: Colors.white38),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF6DE1F1), width: 1.5),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '캡슐 뽑기',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildItemsSection(
    double totalPercent,
    double remainPercent,
    bool isMobile,
    List<DefaultGachaItemData> uiItems,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (isMobile) ...<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: () => context.read<GachaSettingBloc>().add(
                  AddGachaItem(color: _getRandomGachaColor()),
                ),
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
                onPressed: () =>
                    context.read<GachaSettingBloc>().add(RemoveAllGachaItems()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  elevation: 0,
                ),
                icon: const Icon(Icons.delete_outline, size: 18),
                label: const Text('모두 제거'),
              ),
            ],
          ),
        ] else ...<Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'PFStardust',
                      color: Colors.white,
                    ),
                    children: <InlineSpan>[
                      const TextSpan(text: '전체 확률 : '),
                      TextSpan(
                        text: '${totalPercent.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color:
                              (totalPercent >= 99.99 && totalPercent <= 100.01)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      const TextSpan(text: ' / 100.0%'),
                      const TextSpan(text: ' [ '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Image.asset(
                          'assets/images/gacha.png',
                          width: 28,
                          height: 28,
                        ),
                      ),
                      const TextSpan(
                        text: ' : ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: '${uiItems.length}개 ]',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () => context.read<GachaSettingBloc>().add(
                      AddGachaItem(color: _getRandomGachaColor()),
                    ),
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
                    onPressed: () => context.read<GachaSettingBloc>().add(
                      RemoveAllGachaItems(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade400,
                      foregroundColor: Colors.white,
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('모두 제거'),
                  ),
                ],
              ),
            ],
          ),
        ],
        const SizedBox(height: 24),
        if (isMobile)
          _buildCapsuleListContainer(isMobile: true, uiItems: uiItems)
        else
          Expanded(
            child: SingleChildScrollView(
              child: _buildCapsuleListContainer(isMobile: false, uiItems: uiItems),
            ),
          ),
      ],
    );
  }

  Widget _buildCapsuleListContainer({required bool isMobile, required List<DefaultGachaItemData> uiItems}) {
    return Container(
      width: double.infinity, // 부모 너비 가득
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Wrap(
        spacing: 32,
        runSpacing: 32,
        children: <Widget>[
          for (int i = 0; i < uiItems.length; i++)
            GachaCapsuleItem(
              item: uiItems[i],
              isMobile: isMobile,
              isHovered: _hoveredItemId == uiItems[i].id,
              isSelected: _selectedItemId == uiItems[i].id,
              onTap: () => _showEditModal(context, uiItems[i]),
              onRemove: () {
                context.read<GachaSettingBloc>().add(
                  RemoveGachaItem(uiItems[i].id),
                );
                setState(() {
                  _hoveredItemId = null;
                });
              },
              onHoverEnter: () => setState(() {
                _hoveredItemId = uiItems[i].id;
              }),
              onHoverExit: () => setState(() {
                _hoveredItemId = null;
              }),
            ),
          // 추가하기 점선 원
          InkWell(
            onTap: () => context.read<GachaSettingBloc>().add(
              AddGachaItem(color: _getRandomGachaColor()),
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            child: Container(
              width: isMobile ? 80 : 96,
              height: isMobile ? 80 : 96,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DashedCirclePainter(
                        color: Colors.white38,
                        strokeWidth: 1.5,
                      ),
                    ),
                  ),
                  const Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white38,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 모바일 전용 우측 옵션 모달 (톱니바퀴 클릭시)
  void _showMobileSettingsModal(BuildContext context) {
    final GachaSettingBloc gachaBloc = context.read<GachaSettingBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkBg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      builder: (BuildContext modalContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return BlocProvider.value(
              value: gachaBloc,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.viewInsetsOf(context).bottom, // 키보드 대응
                  left: 24,
                  right: 24,
                  top: 24,
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 컨텐츠 크기만큼만
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text(
                            '상세 설정',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.of(modalContext).pop(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      GachaSettingsPanel(
                        isMobile: true,
                        playCountController: _playCountController,
                        canComplete: _canComplete(),
                        onComplete: _completePackage,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                gachaBloc.add(RemoveAllGachaItems());
                                setState(() {});
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade400,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
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
                              onPressed: () {
                                setState(() {}); // 부모 뷰 상태 갱신
                                Navigator.of(modalContext).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
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
                      const SizedBox(height: 16),
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

// 점선 그리기 (빈 아이템용)
class DashedCirclePainter extends CustomPainter {
  DashedCirclePainter({required this.color, required this.strokeWidth});
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final double perimeter = 2 * pi * radius;
    const double dashLength = 6.0;
    const double dashSpace = 4.0;

    final int dashCount = (perimeter / (dashLength + dashSpace)).floor();
    final double sweepAngle = (dashLength / perimeter) * 360 * (pi / 180);
    final double spaceAngle = (dashSpace / perimeter) * 360 * (pi / 180);

    double currentAngle = 0;
    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );
      currentAngle += sweepAngle + spaceAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
