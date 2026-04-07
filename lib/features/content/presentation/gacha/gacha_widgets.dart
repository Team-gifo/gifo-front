import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../core/blocs/download/download_bloc.dart';
import '../../../../core/constants/app_breakpoints.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/share_helper.dart';
import '../../../lobby/model/lobby_data.dart';
import '../widgets/gifticon_frame.dart';

class GachaMachineSection extends StatefulWidget {
  final int remainingCount;
  final List<GachaItem> items;
  final bool isDrawing;
  final VoidCallback? onDraw;
  final Function(GachaItem)? onAnimationComplete;

  const GachaMachineSection({
    super.key,
    required this.remainingCount,
    required this.items,
    this.isDrawing = false,
    this.onDraw,
    this.onAnimationComplete,
  });

  @override
  State<GachaMachineSection> createState() => GachaMachineSectionState();
}

class GachaMachineSectionState extends State<GachaMachineSection>
    with TickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  late AnimationController _knobController;
  late Animation<double> _knobAnimation;

  late AnimationController _dropController;
  late Animation<double> _dropAnimation;
  late Animation<double> _dropScaleAnimation;

  late AnimationController _openController;
  late Animation<double> _openAnimation;
  bool _isAnimating = false;

  static const List<Color> _dotPalette = <Color>[
    Color(0xFFFF6B6B),
    Color(0xFF4ECDC4),
    Color(0xFFFFE66D),
    Color(0xFFA855F7),
    Color(0xFF69D44A),
    Color(0xFFFF9F43),
    Color(0xFF54A0FF),
    Color(0xFFFF6B9D),
  ];

  @override
  void initState() {
    super.initState();
    // 1. 흔들림
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    // 2. 노브 회전
    _knobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _knobAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _knobController, curve: Curves.easeInOutCubic),
    );

    // 3. 캡슐 배출 및 이동 (노브 -> 중앙)
    _dropController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _dropAnimation = CurvedAnimation(
      parent: _dropController,
      curve: Curves.easeOutBack,
    );
    _dropScaleAnimation = Tween<double>(begin: 0.4, end: 3.0).animate(
      CurvedAnimation(parent: _dropController, curve: Curves.easeInOutCirc),
    );

    // 4. 오픈
    _openController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _openAnimation = CurvedAnimation(
      parent: _openController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _knobController.dispose();
    _dropController.dispose();
    _openController.dispose();
    super.dispose();
  }

  Color _dispensedCapsuleColor = Colors.white;
  bool _isWaitingForServer = false;

  // 외부(부모)에서 결과가 나오면 호출하여 애니메이션 시작
  Future<void> startResultAnimation(GachaItem item) async {
    setState(() {
      _isWaitingForServer = false;
      _dispensedCapsuleColor =
          _dotPalette[math.Random().nextInt(_dotPalette.length)];
    });

    // 1. 노브 회전 단계
    await _knobController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // 2. 캡슐 배출 및 이동 단계 (노브 중심 -> 화면 중앙)
    await _dropController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // 3. 캡슐 오픈 단계
    await _openController.forward();

    // 4. 완료 콜백 (모달 띄우기) - 딜레이 없이 즉시 출력
    widget.onAnimationComplete?.call(item);

    // 초기화 및 상태 해제
    _knobController.reset();
    _dropController.reset();
    _openController.reset();
    setState(() {
      _isAnimating = false;
    });
  }

  Future<void> _handleDraw() async {
    if (_isAnimating || widget.onDraw == null) return;
    setState(() {
      _isAnimating = true;
      _isWaitingForServer = true;
    });

    // 1. 흔들림 애니메이션 시작
    await _shakeController.forward();
    await _shakeController.reverse(); // 중앙으로 복귀

    // 2. 부모에게 드로우 이벤트 알림 (BLoC 업데이트 호출)
    widget.onDraw?.call();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth >= AppBreakpoints.desktop;
    double machineScale = 1.0;

    if (isDesktop) {
      machineScale = 1.35;
    } else if (screenWidth >= AppBreakpoints.tablet) {
      machineScale = 1.25;
    } else {
      machineScale = 1.15; // 모바일 스케일 약간 상향
    }

    return Column(
      children: <Widget>[
        SizedBox(height: isDesktop ? 24 : 24),
        _buildRemainingBadge(),
        SizedBox(height: isDesktop ? 24 : 24),
        Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge(<Listenable>[
              _dropController,
              _openController,
            ]),
            builder: (BuildContext context, Widget? child) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: <Widget>[
                  // 머신 본체 (흔들림 적용 + 스케일 적용)
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (BuildContext context, Widget? child) {
                      final double offsetX = _shakeController.isAnimating
                          ? math.sin(_shakeController.value * math.pi * 10) *
                                _shakeAnimation.value
                          : 0;
                      return Transform.translate(
                        offset: Offset(offsetX, 0),
                        child: Transform.scale(
                          scale: machineScale,
                          child: child,
                        ),
                      );
                    },
                    child: _buildPixelMachineFrame(),
                  ),

                  // 노브에서 나와서 중앙으로 이동하는 캡슐 - 이펙트 앞에 배치
                  if (_isAnimating && _dropController.value > 0)
                    Positioned(
                      // Y좌표: 노브 위치(440) -> 중앙(300)
                      // 스케일에 따라 위치 보정 (기본 440에서 스케일 중심 기준 조정)
                      top:
                          (440 * machineScale) -
                          (200 * machineScale * _dropAnimation.value),
                      child: Transform.scale(
                        scale: machineScale * _dropScaleAnimation.value,
                        child: _buildCapsule(
                          _dispensedCapsuleColor,
                          _openAnimation.value,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCapsule(Color color, double openValue, {double size = 60.0}) {
    final double halfSize = size / 2;
    final double iconSize = size / 2;

    // 전체 형태를 그리는 함수
    Widget buildFullCapsule() {
      return SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: <Widget>[
            // 내부 콘텐츠를 ClipOval로 정확하게 원형 클리핑
            ClipOval(
              child: Stack(
                children: <Widget>[
                  // 배경 흰색
                  Container(color: Colors.white),
                  // 상단 반투명 흰색 막
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: halfSize,
                    child: Container(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  // 하단 특정 컬러 반투명 막
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: halfSize,
                    child: Container(color: color.withValues(alpha: 0.7)),
                  ),
                  // 중앙 분리선
                  Align(
                    alignment: Alignment.center,
                    child: Container(height: 1, color: Colors.black26),
                  ),
                  // 중앙 아이콘 (물음표)
                  Center(
                    child: Icon(
                      Icons.question_mark,
                      size: iconSize,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            // 원형 테두리를 별도 레이어로 얹어 클리핑 영향을 받지 않게 처리
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black38,
                  width: 1.5,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (openValue == 0.0) {
      return buildFullCapsule();
    }

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: <Widget>[
          // 하단부 (아래쪽 절반)
          Transform.translate(
            offset: Offset(0, halfSize / 2),
            child: ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.5,
                child: buildFullCapsule(),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(
              0,
              -halfSize / 2 - (size / 2) * openValue,
            ), // 위쪽으로 들림
            child: Transform.rotate(
              angle: 0.3 * openValue, // 살짝 회전
              child: ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.5,
                  child: buildFullCapsule(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemainingBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF130E1F),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.4)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.2),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            '남은 뽑기 횟수',
            style: TextStyle(
              fontFamily: 'PFStardust',
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            widget.remainingCount.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontFamily: 'PFStardust',
              fontSize: 22,
              color: AppColors.neonPurple,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixelMachineFrame() {
    return SizedBox(
      width: 280,
      height: 580,
      child: Column(
        children: <Widget>[
          // 1. 머신 상단부 - 유리 돔 보관통
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                // 메인 캡슐 보관통
                Container(
                  width: 260,
                  decoration: BoxDecoration(
                    // 상단을 훨씬 둥글게 -> 캡슐 머신 유리 돔 실루엣
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(90),
                      topRight: Radius.circular(90),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    // 반투명 짙은 배경 (유리 느낌)
                    color: const Color(0xFF1A1030).withValues(alpha: 0.7),
                    border: Border.all(
                      color: AppColors.neonPurple.withValues(alpha: 0.6),
                      width: 2.5,
                    ),
                    boxShadow: <BoxShadow>[
                      // 외부 네온 글로우
                      BoxShadow(
                        color: AppColors.neonPurple.withValues(alpha: 0.3),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                      // 내부 바닥 조명
                      BoxShadow(
                        color: AppColors.neonPurple.withValues(alpha: 0.08),
                        blurRadius: 40,
                        spreadRadius: -10,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(88),
                      topRight: Radius.circular(88),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        // 캡슐들
                        Positioned.fill(child: _buildCapsulesInside()),
                        // 유리 상단 반사광 (왼쪽 하이라이트)
                        Positioned(
                          top: 10,
                          left: 30,
                          child: Container(
                            width: 60,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  Colors.white.withValues(alpha: 0.13),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        // 상단 안쪽 네온 테두리 글로우
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 3,
                            decoration: const BoxDecoration(
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: AppColors.neonPurple,
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 하단 금속 림 (보관통 & 본체 사이 연결고리)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 270,
                    height: 14,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        colors: <Color>[
                          const Color(0xFF3D2A5F),
                          AppColors.neonPurple.withValues(alpha: 0.8),
                          const Color(0xFF3D2A5F),
                        ],
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.neonPurple.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 2. 머신 본체 (Base)
          Container(
            height: 250,
            width: 280,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF130E1F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.neonPurple.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.neonPurple.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (int i) => Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      color: AppColors.neonPurple.withValues(alpha: 0.3),
                    ),
                  ),
                ),
                const Spacer(),
                _buildMachineKnob(),
                const Spacer(),
                GachaDrawButton(
                  isEnabled: widget.remainingCount > 0 && !_isAnimating,
                  isLoading: _isWaitingForServer,
                  onTap: _handleDraw,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineKnob() {
    return RotationTransition(
      turns: _knobAnimation,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1E1626),
          border: Border.all(
            color: AppColors.neonPurple.withValues(alpha: 0.6),
            width: 2,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.neonPurple.withValues(alpha: 0.3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 10,
            decoration: BoxDecoration(
              color: AppColors.neonPurple,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCapsulesInside() {
    final int count = 18;
    // 고정 시드로 매번 위치가 흔들리지 않고 안정적으로 쌓여 있도록 유지
    final math.Random random = math.Random(1234);

    return Stack(
      clipBehavior: Clip.none,
      children: List.generate(count, (int index) {
        final Color color = _dotPalette[index % _dotPalette.length];

        // 헥스 그리드 형태로 박스 아래에서부터 쌓이도록 계산 (캡슐 너비 68px)
        int r = 0;
        int remain = index;
        while (true) {
          int cap = (r % 2 == 0) ? 4 : 3;
          if (remain < cap) break;
          remain -= cap;
          r++;
        }
        int col = remain;
        bool isEvenRow = (r % 2 == 0);

        // 컨테이너 너비 260px, 캡슐 너비 68px
        double targetX =
            (isEvenRow ? -6.0 : 28.0) +
            col * 68.0 +
            random.nextDouble() * 6 -
            3;
        // 컨테이너 높이 약 318px, 바닥 Y좌표 = 240px, 위로 쌓일때마다 약 58px씩 상승
        double targetY = 240.0 - r * 58.0 + random.nextDouble() * 8 - 4;

        // 최종 안착 시 회전 각도
        double targetAngle = random.nextDouble() * math.pi * 2;

        // 순차적 떨어짐 연출을 위한 딜레이 및 시간 설정
        int delayMs = index * 100; // 캡슐 하나당 100ms 씩 늦게 출발
        int activeMs = 800 + random.nextInt(300); // 떨어지는 속도 약간 랜덤
        int totalMs = delayMs + activeMs;
        double delayRatio = delayMs / totalMs;

        return TweenAnimationBuilder<double>(
          key: ValueKey<int>(index), // 고유 키를 부여하여 리스트 변경 시 안정성 확보
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: totalMs),
          curve: Curves.linear, // 커브는 빌더 내부에서 적용
          builder: (BuildContext context, double time, Widget? child) {
            double value = 0.0;
            if (time > delayRatio) {
              // 딜레이 이후부터 1.0까지 진행도를 0.0~1.0으로 정규화
              double normalizedTime = (time - delayRatio) / (1.0 - delayRatio);
              // 바운스 효과를 1.0 도달 시 넘어서면서 튕기도록 처리
              value = Curves.bounceOut.transform(normalizedTime);
            }

            // Y좌표: 위(-120)에서부터 목표 지점(targetY)으로 이동
            double currentY = -120 + (targetY + 120) * value;

            return Positioned(
              left: targetX,
              top: currentY,
              child: Transform.rotate(angle: targetAngle * value, child: child),
            );
          },
          child: IgnorePointer(
            // 내부 캡슐 크기는 68.0으로 25% 축소 (기존 90 기준)
            child: _buildCapsule(color, 0.0, size: 68.0),
          ),
        );
      }),
    );
  }
}

class GachaDrawButton extends StatefulWidget {
  final bool isEnabled;
  final bool isLoading;
  final VoidCallback? onTap;

  const GachaDrawButton({
    super.key,
    required this.isEnabled,
    this.isLoading = false,
    this.onTap,
  });

  @override
  State<GachaDrawButton> createState() => _GachaDrawButtonState();
}

class _GachaDrawButtonState extends State<GachaDrawButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(_pulseController);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled && !widget.isLoading) {
      return _buildButton(isEnabled: false);
    }
    return ScaleTransition(
      scale: _pulseAnimation,
      child: _buildButton(isEnabled: widget.isEnabled),
    );
  }

  Widget _buildButton({required bool isEnabled}) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled && !widget.isLoading ? widget.onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: isEnabled
                    ? <Color>[const Color(0xFFBC13FE), const Color(0xFF8B5CF6)]
                    : <Color>[Colors.grey.shade800, Colors.grey.shade900],
              ),
              boxShadow: isEnabled
                  ? <BoxShadow>[
                      BoxShadow(
                        color: const Color(0xFFBC13FE).withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (widget.isLoading)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  else
                    Text(
                      'DRAW NOW',
                      style: TextStyle(
                        fontFamily: 'PFStardust',
                        fontSize: 18,
                        color: isEnabled ? Colors.white : Colors.grey,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GachaHistoryPanel extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  final String userName;
  final String inviteCode;

  const GachaHistoryPanel({
    super.key,
    required this.history,
    required this.userName,
    required this.inviteCode,
  });

  @override
  State<GachaHistoryPanel> createState() => _GachaHistoryPanelState();
}

class _GachaHistoryPanelState extends State<GachaHistoryPanel> {
  final ScreenshotController _screenshotController = ScreenshotController();

  void _handleShare() {
    if (widget.history.isEmpty) return;

    // 당첨 목록을 이름 리스트로 변환하여 ShareHelper에 위임
    final List<String> itemNames = widget.history.map((
      Map<String, dynamic> record,
    ) {
      final GachaItem item = record['item'] as GachaItem;
      return item.itemName;
    }).toList();

    ShareHelper.shareResultToClipboard(
      context: context,
      userName: widget.userName,
      inviteCode: widget.inviteCode,
      itemNames: itemNames,
    );
  }

  Future<void> _handleDownload(GachaItem item, String time) async {
    // 1. 캡쳐 진행 알림 (로딩 상태)
    context.read<DownloadBloc>().add(const SetDownloadLoadingEvent());

    // 2. 기프티콘 프레임 위젯 생성 (캡쳐용)
    // 폰트 및 이미지 로드 대기를 위해 약간의 지연 처리 권장
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final String qrUrl = '${Uri.base.origin}/gift/code/${widget.inviteCode}';

    try {
      final Uint8List imageBytes = await _screenshotController
          .captureFromWidget(
            GifticonFrame(
              itemName: item.itemName,
              imageUrl: item.imageUrl,
              recipientName: widget.userName,
              issueDate: time,
              inviteCode: widget.inviteCode,
              qrUrl: qrUrl,
            ),
            delay: const Duration(milliseconds: 100),
          );

      if (mounted) {
        // 3. 공용 DownloadBloc을 통해 실제 다운로드 실행
        final String fileName = 'gifticon_${item.itemName}_$time.png';
        context.read<DownloadBloc>().add(
          ProcessDownloadEvent(
            filesInfo: <Map<String, dynamic>>[
              <String, dynamic>{'name': fileName, 'bytes': imageBytes},
            ],
          ),
        );
      }
    } catch (e) {
      debugPrint('[GachaHistoryPanel] Capture Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLarge = screenWidth >= AppBreakpoints.desktop;
    final double scale = isLarge ? 1.2 : 1.0;

    return Container(
      width: isLarge ? 300 : double.infinity,
      padding: EdgeInsets.all(isLarge ? 20 : 0),
      decoration: isLarge
          ? BoxDecoration(
              color: const Color(0xFF130E1F),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.neonPurple.withValues(alpha: 0.3),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.celebration_rounded, // 히스토리 아이콘을 폭죽 아이콘으로 변경
                color: AppColors.neonPurple,
                size: 20 * scale,
              ),
              const SizedBox(width: 10),
              Text(
                '당첨된 기록',
                style: TextStyle(
                  fontFamily: 'PFStardust',
                  fontSize: 16 * scale,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              if (widget.history.isNotEmpty) ...<Widget>[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.neonPurple,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.history.length > 99
                        ? '99+'
                        : widget.history.length.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _handleShare,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(
                    Icons.share_rounded,
                    size: 16,
                    color: AppColors.neonPurple,
                  ),
                  label: const Text(
                    '공유하기',
                    style: TextStyle(
                      fontFamily: 'WantedSans',
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 20 * scale),
          Expanded(
            child: widget.history.isEmpty
                ? _buildEmptyState(scale)
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: widget.history.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(color: Colors.white10),
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> record = widget.history[index];
                      final GachaItem? item = record['item'] is GachaItem
                          ? record['item'] as GachaItem
                          : null;
                      final String time = record['time']?.toString() ?? '';

                      if (item == null) return const SizedBox.shrink();

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40 * scale,
                          height: 40 * scale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.neonPurple),
                            image: DecorationImage(
                              image: NetworkImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          item.itemName,
                          style: TextStyle(
                            fontFamily: 'WantedSans',
                            color: Colors.white,
                            fontSize: 14 * scale,
                          ),
                        ),
                        subtitle: Text(
                          time,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12 * scale,
                          ),
                        ),
                        // 우측에 다운로드 아이콘 배치
                        trailing: IconButton(
                          icon: Icon(
                            Icons.file_download_outlined,
                            color: AppColors.neonPurple.withOpacity(0.8),
                            size: 20 * scale,
                          ),
                          onPressed: () => _handleDownload(item, time),
                          tooltip: '기프티콘 이미지 저장',
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double scale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.inventory_2_outlined,
            color: Colors.white.withValues(alpha: 0.2),
            size: 40 * scale,
          ),
          SizedBox(height: 12 * scale),
          Text(
            '아직 뽑은 기록이 없습니다.',
            style: TextStyle(
              fontFamily: 'WantedSans',
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 12 * scale,
            ),
          ),
        ],
      ),
    );
  }
}

class GachaPrizeListPanel extends StatelessWidget {
  final List<GachaItem> items;

  const GachaPrizeListPanel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLarge = screenWidth >= AppBreakpoints.desktop;
    final double scale = isLarge ? 1.2 : 1.0;

    return Container(
      width: isLarge ? 300 : double.infinity,
      padding: EdgeInsets.all(isLarge ? 24 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF130E1F), // 히스토리 패널과 통일감 있는 배경색
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.neonPurple.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.stars_rounded,
                color: AppColors.neonPurple,
                size: 20 * scale,
              ),
              SizedBox(width: 10 * scale),
              Text(
                '경품 목록',
                style: TextStyle(
                  fontFamily: 'PFStardust',
                  fontSize: 16 * scale,
                  color: Colors.white,
                  letterSpacing: 1,
                  shadows: <Shadow>[
                    Shadow(
                      color: AppColors.neonPurple.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20 * scale),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 12 * scale),
              itemBuilder: (BuildContext context, int index) {
                final GachaItem item = items[index];
                return Container(
                  padding: EdgeInsets.all(12 * scale),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(8),
                    // 아이템 좌측에 네온 포인트 바 추가
                    border: Border(
                      left: BorderSide(
                        color: AppColors.neonPurple.withValues(alpha: 0.4),
                        width: 4,
                      ),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 44 * scale,
                        height: 44 * scale,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(item.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.itemName,
                              style: TextStyle(
                                fontFamily: 'WantedSans',
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.bold,
                                fontSize: 13 * scale,
                              ),
                            ),
                            SizedBox(height: 4 * scale),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.bolt_rounded,
                                  size: 10 * scale,
                                  color: AppColors.neonPurple,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.percentOpen
                                      ? '${(item.percent * 100).toStringAsFixed(2)}%'
                                      : '확률 미공개',
                                  style: TextStyle(
                                    color: AppColors.neonPurple.withValues(
                                      alpha: 0.8,
                                    ),
                                    fontFamily: 'WantedSans',
                                    fontSize: 11 * scale,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
