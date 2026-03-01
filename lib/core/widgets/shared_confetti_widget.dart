import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class SharedConfettiWidget extends StatefulWidget {
  final Duration duration;
  final bool autoPlay;
  final BlastDirectionality blastDirectionality;
  final double emissionFrequency;
  final int numberOfParticles;
  final double maxBlastForce;
  final double minBlastForce;
  final double gravity;
  final List<Color>? colors;

  const SharedConfettiWidget({
    super.key,
    this.duration = const Duration(seconds: 3),
    this.autoPlay = true,
    this.blastDirectionality = BlastDirectionality.explosive,
    this.emissionFrequency = 0.02,
    this.numberOfParticles = 8,
    this.maxBlastForce = 50,
    this.minBlastForce = 20,
    this.gravity = 1.0,
    this.colors = const <Color>[
      Colors.redAccent,
      Colors.blueAccent,
      Colors.yellowAccent,
      Colors.greenAccent,
      Colors.purpleAccent,
      Colors.orangeAccent,
    ],
  });

  @override
  State<SharedConfettiWidget> createState() => _SharedConfettiWidgetState();
}

class _SharedConfettiWidgetState extends State<SharedConfettiWidget> {
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
      blastDirectionality: widget.blastDirectionality,
      emissionFrequency: widget.emissionFrequency,
      numberOfParticles: widget.numberOfParticles,
      maxBlastForce: widget.maxBlastForce,
      minBlastForce: widget.minBlastForce,
      gravity: widget.gravity,
      colors: widget.colors,
    );
  }
}
