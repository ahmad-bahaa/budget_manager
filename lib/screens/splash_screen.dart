import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/icons/splash.jpg',
      // You can use an Icon, Image, or Lottie.asset
      nextScreen: DashboardScreen(),
      splashTransition: SplashTransition.scaleTransition,
      splashIconSize: 250,
      // Size of the splash screen icon
      duration: 2500,
      // Duration in milliseconds (3 seconds)
      backgroundColor: Colors.white,
      curve: Curves.fastEaseInToSlowEaseOut,
      centered: true,
      pageTransitionType: PageTransitionType.leftToRightWithFade,
    );
  }
}
