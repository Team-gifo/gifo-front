import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../lobby/model/lobby_data.dart';

class GachaMachineSection extends StatefulWidget {
  final int remainingCount;
  final List<GachaItem> items;
  final VoidCallback? onDraw;
  final Function(GachaItem)? onAnimationComplete;

  const GachaMachineSection({
    super.key,
    required this.remainingCount,
    required this.items,
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
  GachaItem? _lastResult; // 내부 결과 저장 (애니메이션 연출용)

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

  // 외부(부모)에서 결과가 나오면 호출하여 애니메이션 시작
  Future<void> startResultAnimation(GachaItem item) async {
    setState(() {
      _lastResult = item;
    });

    // 1. 노브 회전 단계
    await _knobController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 100));

    // 2. 캡슐 배출 및 이동 단계 (노브 중심 -> 화면 중앙)
    await _dropController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 200));

    // 3. 캡슐 오픈 단계
    await _openController.forward();
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // 4. 완료 콜백 (모달 띄우기)
    widget.onAnimationComplete?.call(item);

    // 초기화 및 상태 해제
    _knobController.reset();
    _dropController.reset();
    _openController.reset();
    setState(() {
      _isAnimating = false;
      _lastResult = null;
    });
  }

  Future<void> _handleDraw() async {
    if (_isAnimating || widget.onDraw == null) return;
    setState(() => _isAnimating = true);

    // 1. 흔들림 애니메이션 시작
    await _shakeController.forward();
    await _shakeController.reverse(); // 중앙으로 복귀

    // 2. 부모에게 드로우 이벤트 알림 (BLoC 업데이트 호출)
    widget.onDraw?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildRemainingBadge(),
        const SizedBox(height: 24),
        Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge(<Listenable>[_dropController, _openController]),
            builder: (BuildContext context, Widget? child) {
              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: <Widget>[
                  // 머신 본체 (흔들림 적용)
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (BuildContext context, Widget? child) {
                      final double offsetX = _shakeController.isAnimating
                          ? math.sin(_shakeController.value * math.pi * 10) *
                                _shakeAnimation.value
                          : 0;
                      return Transform.translate(
                        offset: Offset(offsetX, 0),
                        child: child,
                      );
                    },
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: _buildPixelMachineFrame(),
                    ),
                  ),

                  // 노브에서 나와서 중앙으로 이동하는 캡슐
                  if (_isAnimating && _dropController.value > 0)
                    Positioned(
                      // Y좌표: 노브 위치(440) -> 중앙(300)
                      top: 440 - (140 * _dropAnimation.value),
                      child: ScaleTransition(
                        scale: _dropScaleAnimation,
                        child: _buildCapsule(
                          _lastResult != null
                              ? _dotPalette[widget.items.indexOf(_lastResult!) %
                                    _dotPalette.length]
                              : _dotPalette[math.Random().nextInt(
                                  _dotPalette.length,
                                )],
                          _openAnimation.value,
                        ),
                      ),
                    ),

                  // 오픈되는 연출 (빛 에너지 발산)
                  if (_isAnimating && _openController.value > 0)
                    FadeTransition(
                      opacity: _openAnimation,
                      child: SizedBox(
                        width: 300,
                        height: 300,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: AppColors.neonPurple.withValues(alpha: 0.6),
                                blurRadius: 150 * _openAnimation.value,
                                spreadRadius: 30 * _openAnimation.value,
                              ),
                            ],
                          ),
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

  Widget _buildCapsule(Color color, double openValue) {
    const double size = 40.0;
    const double halfSize = size / 2;
    const double iconSize = 20.0;

    // 전체 형태를 그리는 함수
    Widget buildFullCapsule() {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 2,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
          color: Colors.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: <Widget>[
            // 중앙 아이콘 (물음표)
            const Center(
              child: Icon(
                Icons.question_mark,
                size: iconSize,
                color: Colors.black87,
              ),
            ),
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
              child: Container(
                color: color.withValues(alpha: 0.7),
              ),
            ),
            // 중앙 분리선
            Align(
              alignment: Alignment.center,
              child: Container(height: 1, color: Colors.black),
            ),
          ],
        ),
      );
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
            offset: const Offset(0, halfSize / 2),
            child: ClipRect(
              child: Align(
                alignment: Alignment.bottomCenter,
                heightFactor: 0.5,
                child: buildFullCapsule(),
              ),
            ),
          ),
          // 상단부 뚜껑 (위쪽 절반 - 열릴 때 위로 이동하며 회전)
          Transform.translate(
            offset: Offset(0, -halfSize / 2 - 20.0 * openValue), // 위쪽으로 들림
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
              fontSize: 12,
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
    return Container(
      width: 280,
      height: 580,
      child: Column(
        children: <Widget>[
          // 1. 머신 상단 (캡슐 보관통)
          Expanded(
            flex: 3,
            child: Container(
              width: 260,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1626).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.neonPurple.withValues(alpha: 0.5),
                  width: 3,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.neonPurple.withValues(alpha: 0.15),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(child: _buildCapsulesInside()),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: AppColors.neonPurple,
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
    final int count = widget.remainingCount;
    final math.Random random = math.Random(42);
    return Stack(
      children: List.generate(count, (int index) {
        final Color color = _dotPalette[index % _dotPalette.length];
        return Positioned(
          left: 40 + random.nextDouble() * 180,
          top: 80 + random.nextDouble() * 260,
          child: Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: <BoxShadow>[
                BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class GachaDrawButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback? onTap;

  const GachaDrawButton({super.key, required this.isEnabled, this.onTap});

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
    if (!widget.isEnabled) {
      return _buildButton(isEnabled: false);
    }
    return ScaleTransition(
      scale: _pulseAnimation,
      child: _buildButton(isEnabled: true),
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
          onTap: isEnabled ? widget.onTap : null,
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
                  Text(
                    'DRAW',
                    style: TextStyle(
                      fontFamily: 'PFStardust',
                      fontSize: 18,
                      color: isEnabled ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '지금 뽑기',
                    style: TextStyle(
                      fontFamily: 'WantedSans',
                      fontSize: 14,
                      color: isEnabled
                          ? Colors.white.withValues(alpha: 0.9)
                          : Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.touch_app,
                    size: 16,
                    color: isEnabled
                        ? Colors.white.withValues(alpha: 0.8)
                        : Colors.grey,
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

class GachaHistoryPanel extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const GachaHistoryPanel({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Row(
            children: <Widget>[
              Icon(Icons.history, color: AppColors.neonPurple, size: 20),
              SizedBox(width: 10),
              Text(
                'HISTORY',
                style: TextStyle(
                  fontFamily: 'PFStardust',
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: history.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: history.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(color: Colors.white10),
                    itemBuilder: (BuildContext context, int index) {
                      final Map<String, dynamic> record = history[index];
                      final GachaItem? item = record['item'] is GachaItem
                          ? record['item'] as GachaItem
                          : null;
                      final String time = record['time']?.toString() ?? '';

                      if (item == null) return const SizedBox.shrink();

                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.neonPurple),
                            image: DecorationImage(
                              image: AssetImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          item.itemName,
                          style: const TextStyle(
                            fontFamily: 'WantedSans',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          time,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.inventory_2_outlined,
            color: Colors.white.withValues(alpha: 0.2),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'NO HISTORY YET',
            style: TextStyle(
              fontFamily: 'PFStardust',
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 12,
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
    return Container(
      width: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.neonPurple.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.stars, color: AppColors.neonPurple, size: 20),
              const SizedBox(width: 10),
              const Text(
                'PRIZE LIST',
                style: TextStyle(
                  fontFamily: 'PFStardust',
                  fontSize: 16,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(height: 12),
              itemBuilder: (BuildContext context, int index) {
                final GachaItem item = items[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: AssetImage(item.imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              item.itemName,
                              style: const TextStyle(
                                fontFamily: 'WantedSans',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.percentOpen
                                  ? '${(item.percent * 100).toStringAsFixed(2)}% CHANCE'
                                  : 'SECRET CHANCE',
                              style: TextStyle(
                                color: AppColors.neonPurple.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
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
