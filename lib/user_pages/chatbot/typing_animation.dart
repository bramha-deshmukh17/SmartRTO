import 'package:flutter/material.dart';

class TypingAnimation extends StatefulWidget {
  const TypingAnimation({Key? key}) : super(key: key);

  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _controller3;
  late Animation<double> _positionAnimation1;
  late Animation<double> _positionAnimation2;
  late Animation<double> _positionAnimation3;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _controller3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _positionAnimation1 = Tween<double>(begin: 0.0, end: -5.0).animate(
      CurvedAnimation(parent: _controller1, curve: Curves.easeInOut),
    );

    _positionAnimation2 = Tween<double>(begin: 0.0, end: -5.0).animate(
      CurvedAnimation(parent: _controller2, curve: Curves.easeInOut),
    );

    _positionAnimation3 = Tween<double>(begin: 0.0, end: -5.0).animate(
      CurvedAnimation(parent: _controller3, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    while (mounted) {
      await _controller1.forward();
      await _controller1.reverse();

      await _controller2.forward();
      await _controller2.reverse();

      await _controller3.forward();
      await _controller3.reverse();
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _positionAnimation1,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _positionAnimation1.value),
              child: const Text(
                '.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 5),
        AnimatedBuilder(
          animation: _positionAnimation2,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _positionAnimation2.value),
              child: const Text(
                '.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 5),
        AnimatedBuilder(
          animation: _positionAnimation3,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _positionAnimation3.value),
              child: const Text(
                '.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
