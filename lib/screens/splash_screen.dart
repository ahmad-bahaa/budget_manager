import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Icons.monetization_on_outlined, // You can use an Icon, Image, or Lottie.asset
      nextScreen: const DashboardScreen(), // The screen to navigate to after the splash
      splashTransition: SplashTransition.slideTransition, // Type of transition
      duration: 2000, // Duration in milliseconds (3 seconds)
      backgroundColor: Colors.green,
    );
  }
}
