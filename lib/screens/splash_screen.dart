import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade50,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // THE MAGIC HAPPENS HERE
          Lottie.asset(
            'assets/lottie/splash.json',
            height: 250, // Make it big and beautiful
            repeat: true, // Keep the animation looping
            reverse: false,
            animate: true,
          ),
          const SizedBox(height: 40),
          Text(
            'Budget Manager',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),

        ],
      ),
    );
  }
}
