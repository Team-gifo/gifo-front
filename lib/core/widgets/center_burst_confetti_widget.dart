import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CenterBurstConfettiWidget extends StatefulWidget {
  final Duration duration;
  final bool autoPlay;
  final int numberOfParticles;
  final double emissionFrequency;
  final double maxBlastForce;
  final double minBlastForce;
  final double gravity;
  final List<Color>? colors;

  const CenterBurstConfettiWidget({
    super.key,
    this.duration = const Duration(milliseconds: 100), // 단 한 번만 짧고 강하게 터지도록 제어
    this.autoPlay = true,
    this.emissionFrequency = 0.5, // 짧은 시간 내에 입자가 밀도 있게 방출되게 상향
    this.numberOfParticles = 24,
    this.maxBlastForce = 300, // 터지는 반경을 넓히기 위해 폭발력을 크게 강화
    this.minBlastForce = 100,
    this.gravity = 0.3, // 잔해들이 천천히 떨어지도록 중력을 조절
    this.colors = const <Color>[
      Colors.redAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
      Colors.cyanAccent,
    ],
  });

  @override
  State<CenterBurstConfettiWidget> createState() =>
      _CenterBurstConfettiWidgetState();
}

class _CenterBurstConfettiWidgetState extends State<CenterBurstConfettiWidget> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: widget.duration);

    if (widget.autoPlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: _confettiController,
      blastDirectionality: BlastDirectionality.explosive, // 중앙에서 사방으로 퍼지는 옵션
      emissionFrequency: widget.emissionFrequency,
      numberOfParticles: widget.numberOfParticles,
      maxBlastForce: widget.maxBlastForce,
      minBlastForce: widget.minBlastForce,
      gravity: widget.gravity,
      colors: widget.colors,
    );
  }
}
