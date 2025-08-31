
import 'package:flutter/cupertino.dart';

class AnimatedContainerWidget extends StatefulWidget {
  final Widget child;
  final int index;
  final Offset offset;
  const AnimatedContainerWidget({super.key, required this.index, required this.offset, required this.child});

  @override
  State<AnimatedContainerWidget> createState() => _AnimatedContainerWidgetState();
}

class _AnimatedContainerWidgetState extends State<AnimatedContainerWidget> with SingleTickerProviderStateMixin {

  AnimationController? controller;
  Animation<Offset>? animationOffset;
  Animation<double>? fadeAnimation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400)
    );

    final curvedAnimation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);

    animationOffset = Tween<Offset>(
      begin: widget.offset,
      end: Offset.zero
    ).animate(curvedAnimation);

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1
    ).animate(curvedAnimation);

    Future.delayed(Duration(milliseconds: widget.index * 100),(){
      controller?.forward();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(fadeAnimation==null || animationOffset==null){
      return SizedBox.shrink();
    }
    return FadeTransition(
        opacity: fadeAnimation!,
        child: SlideTransition(
            position: animationOffset!,
            child: widget.child,
        ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
