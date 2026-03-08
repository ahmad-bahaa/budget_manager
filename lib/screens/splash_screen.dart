import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash:
            Lottie.asset(
              'assets/lottie/splash.json',
              repeat: true, // Keep the animation looping
              reverse: false,
              animate: true,
            ),
      splashIconSize: 400,
      nextScreen: const DashboardScreen(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      duration: 3000,
      backgroundColor: Colors.white,
    );
  }
}
