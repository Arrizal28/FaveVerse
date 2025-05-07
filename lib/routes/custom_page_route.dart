import 'package:flutter/material.dart';

class CustomPageRoute extends Page {
  final Widget child;
  final String routeName;
  final bool isRightToLeft;

  const CustomPageRoute({
    required this.child,
    required this.routeName,
    this.isRightToLeft = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final offsetTween = isRightToLeft
            ? Tween(begin: begin, end: end)
            : Tween(begin: Offset(-1.0, 0.0), end: end);

        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return SlideTransition(
          position: offsetTween.animate(curvedAnimation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}