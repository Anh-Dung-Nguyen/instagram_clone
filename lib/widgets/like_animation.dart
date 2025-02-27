import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimation;
  final Duration duration;
  final VoidCallback? End;
  final bool iconlike;
  const LikeAnimation({
    Key? key,
    required this.child,
    required this.isAnimation,
    this.duration = const Duration(milliseconds: 150),
    this.End,
    this.iconlike = false,
  }) : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(
        microseconds: widget.duration.inMilliseconds
      ),
    );
    scale = Tween<double>(begin: 1, end: 1).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if (widget.isAnimation != oldWidget.isAnimation) {

    }
  }

  void startAnimation() async {
    if (widget.isAnimation || widget.iconlike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(Duration(microseconds: 200));
    }
    if (widget.End != null ) {
      widget.End!();
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}