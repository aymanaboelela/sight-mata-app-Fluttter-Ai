import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class PageTransitionManager {
  PageTransitionManager._();

  // Slide transition from right to left
  static CustomTransitionPage slideTransition(Widget screen,
      {Duration duration = const Duration(milliseconds: 300)}) {
    return CustomTransitionPage(
      child: screen,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(tween);
        var fadeAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(animation);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  // Fade transition
  static CustomTransitionPage fadeTransition(Widget screen,
      {Duration duration = const Duration(milliseconds: 300)}) {
    return CustomTransitionPage(
      child: screen,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  // Scale transition (zoom effect)
  static CustomTransitionPage scaleTransition(Widget screen,
      {Duration duration = const Duration(milliseconds: 300)}) {
    return CustomTransitionPage(
      child: screen,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  // Rotation transition
  static CustomTransitionPage rotationTransition(Widget screen,
      {Duration duration = const Duration(milliseconds: 300)}) {
    return CustomTransitionPage(
      child: screen,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  // Size transition (expand effect)
  static CustomTransitionPage sizeTransition(Widget screen,
      {Duration duration = const Duration(milliseconds: 300)}) {
    return CustomTransitionPage(
      child: screen,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SizeTransition(
          sizeFactor: animation,
          child: child,
        );
      },
    );
  }

  // Slide transition from left to right
  static CustomTransitionPage slideFromLeftTransition(Widget screen,
      {Duration duration = const Duration(milliseconds: 300)}) {
    return CustomTransitionPage(
      child: screen,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0); // Slide from left
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(tween);

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }

  // Slide transition from bottom to top
  static CustomTransitionPage slideFromBottomTransition(Widget screen,
      {Duration duration = const Duration(milliseconds: 300)}) {
    return CustomTransitionPage(
      child: screen,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Slide from bottom
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(tween);

        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }

  // Custom transition with custom animation
  static CustomTransitionPage customTransition({
    required Widget screen,
    required Widget Function(
            BuildContext, Animation<double>, Animation<double>, Widget)
        transitionsBuilder,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return CustomTransitionPage(
      child: screen,
      transitionDuration: duration,
      transitionsBuilder: transitionsBuilder,
    );
  }
}
