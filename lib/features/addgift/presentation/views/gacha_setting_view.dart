import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gifo/features/addgift/model/gacha_content.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/grid_background_painter.dart';
import '../../../../core/widgets/packaging_loading_overlay.dart';
import '../../application/gacha_setting/gacha_setting_bloc.dart';
import '../../application/gift_packaging_bloc.dart';
import '../widgets/gacha/gacha_item_edit_form.dart';
import '../widgets/gacha/gacha_items_section.dart';
import '../widgets/gacha/gacha_mobile_bottom_bar.dart';
import '../widgets/gacha/gacha_settings_panel.dart';
import '../widgets/gacha/gacha_title_bar.dart';
import '../widgets/step_indicator.dart';

class GachaSettingView extends StatelessWidget {
  const GachaSettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // GiftPackagingBloc을 주입해서 GachaSettingBloc이 내부에서 직접 SubmitPackage를 dispatch할 수 있도록 합니다.
    return BlocProvider<GachaSettingBloc>(
      create: (BuildContext context) =>
          GachaSettingBloc(context.read<GiftPackagingBloc>()),
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
    final GiftPackagingState packagingState = context
        .read<GiftPackagingBloc>()
        .state;

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
      final int capsuleCount = context
          .read<GachaSettingBloc>()
          .state
          .uiItems
          .length;
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
    final GiftPackagingState packagingState = context
        .read<GiftPackagingBloc>()
        .state;

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

  void _addGachaItem() {
    context.read<GachaSettingBloc>().add(
      AddGachaItem(color: _getRandomGachaColor()),
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
        builder: (BuildContext modalContext) =>
            BlocProvider<GachaSettingBloc>.value(
              value: gachaBloc,
              child: GachaItemEditForm(
                modalContext: modalContext,
                itemData: itemData,
                nameController: _modalNameController!,
                percentController: _modalPercentController!,
                onPickImage: _pickImage,
                onDeleteItem: (int itemId) {
                  context.read<GachaSettingBloc>().add(RemoveGachaItem(itemId));
                  if (_hoveredItemId == itemId) {
                    setState(() {
                      _hoveredItemId = null;
                    });
                  }
                },
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
                    child: BlocProvider<GachaSettingBloc>.value(
                      value: gachaBloc,
                      child: GachaItemEditForm(
                        modalContext: context,
                        itemData: itemData,
                        nameController: _modalNameController!,
                        percentController: _modalPercentController!,
                        onPickImage: _pickImage,
                        onDeleteItem: (int itemId) {
                          context.read<GachaSettingBloc>().add(
                            RemoveGachaItem(itemId),
                          );
                          if (_hoveredItemId == itemId) {
                            setState(() {
                              _hoveredItemId = null;
                            });
                          }
                        },
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

  // GiftPackagingBloc의 gachaContent를 기반으로 완료 가능 여부를 판단합니다.
  bool _canComplete() {
    final GiftPackagingState packagingState = context
        .read<GiftPackagingBloc>()
        .state;
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
      listenWhen: (GiftPackagingState prev, GiftPackagingState curr) =>
          prev.submitStatus != curr.submitStatus,
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
              final List<GachaItem> gachaItems =
                  packagingState.gachaContent?.list ?? <GachaItem>[];
              final double totalPercent = gachaItems.fold(
                0.0,
                (double sum, GachaItem item) => sum + item.percent,
              );

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
                          title: GachaTitleBar(
                            userNameController: _userNameController,
                            subTitleController: _subTitleController,
                          ),
                          actions: <Widget>[
                            if (!isMobile) const StepIndicator(activeStep: 3),
                          ],
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
                                            GachaItemsSection(
                                              totalPercent: totalPercent,
                                              isMobile: isMobile,
                                              uiItems: gachaState.uiItems,
                                              hoveredItemId: _hoveredItemId,
                                              selectedItemId: _selectedItemId,
                                              onAddItem: _addGachaItem,
                                              onRemoveAllItems: () => context
                                                  .read<GachaSettingBloc>()
                                                  .add(RemoveAllGachaItems()),
                                              onTapItem:
                                                  (DefaultGachaItemData item) =>
                                                      _showEditModal(
                                                        context,
                                                        item,
                                                      ),
                                              onRemoveItem: (int itemId) {
                                                context
                                                    .read<GachaSettingBloc>()
                                                    .add(
                                                      RemoveGachaItem(itemId),
                                                    );
                                                setState(() {
                                                  _hoveredItemId = null;
                                                });
                                              },
                                              onHoverEnter: (int itemId) =>
                                                  setState(() {
                                                    _hoveredItemId = itemId;
                                                  }),
                                              onHoverExit: () => setState(() {
                                                _hoveredItemId = null;
                                              }),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 7,
                                          child: Padding(
                                            padding: const EdgeInsets.all(40.0),
                                            child: GachaItemsSection(
                                              totalPercent: totalPercent,
                                              isMobile: isMobile,
                                              uiItems: gachaState.uiItems,
                                              hoveredItemId: _hoveredItemId,
                                              selectedItemId: _selectedItemId,
                                              onAddItem: _addGachaItem,
                                              onRemoveAllItems: () => context
                                                  .read<GachaSettingBloc>()
                                                  .add(RemoveAllGachaItems()),
                                              onTapItem:
                                                  (DefaultGachaItemData item) =>
                                                      _showEditModal(
                                                        context,
                                                        item,
                                                      ),
                                              onRemoveItem: (int itemId) {
                                                context
                                                    .read<GachaSettingBloc>()
                                                    .add(
                                                      RemoveGachaItem(itemId),
                                                    );
                                                setState(() {
                                                  _hoveredItemId = null;
                                                });
                                              },
                                              onHoverEnter: (int itemId) =>
                                                  setState(() {
                                                    _hoveredItemId = itemId;
                                                  }),
                                              onHoverExit: () => setState(() {
                                                _hoveredItemId = null;
                                              }),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 1,
                                          color: Colors.white.withValues(
                                            alpha: 0.1,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(40.0),
                                            child: GachaSettingsPanel(
                                              isMobile: false,
                                              playCountController:
                                                  _playCountController,
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
                      if (isLoading) const PackagingLoadingOverlay(),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
            return BlocProvider<GachaSettingBloc>.value(
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
