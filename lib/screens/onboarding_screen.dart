import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard_screen.dart'; // Import your main screen
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Save that the user has seen the tutorial
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80), // Space for bottom sheet
        child: PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(
              () => isLastPage = index == 2,
            ); // We have 3 pages (0, 1, 2)
          },
          children: [
            _buildPage(
              color: Colors.green.shade50,
              lottiePath:
                  'assets/lottie/privacy.json', // Path to your animation
              title: "100% Private",
              subtitle:
                  "Your financial data stays securely on your device. No cloud, no tracking.",
            ),
            _buildPage(
              color: Colors.blue.shade50,
              lottiePath:
                  'assets/lottie/calendar.json', // Path to your animation
              title: "Custom Payday Cycles",
              subtitle:
                  "Set your budget to reset exactly on the day you get paid, not just the 1st of the month."
                  "\n You can add Multiple Expenses according to the calendar.",
            ),
            _buildPage(
              color: Colors.orange.shade50,
              lottiePath: 'assets/lottie/alert.json', // Path to your animation
              title: "Smart Alerts",
              subtitle:
                  "Let's take control of your money!"
                  "\n Add your Categories & money limit to calculate your over all Budget",
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SKIP BUTTON
            TextButton(
              onPressed: () => _controller.jumpToPage(2),
              child: const Text('SKIP'),
            ),

            // DOT INDICATOR
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                spacing: 8.0,
                dotWidth: 10.0,
                dotHeight: 10.0,
                activeDotColor: Theme.of(context).primaryColor,
              ),
              onDotClicked: (index) => _controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              ),
            ),

            // NEXT / DONE BUTTON
            isLastPage
                ? FilledButton(
                    onPressed: _completeOnboarding,
                    child: const Text('GET STARTED'),
                  )
                : TextButton(
                    onPressed: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text('NEXT'),
                  ),
          ],
        ),
      ),
    );
  }

  // Helper widget to build each page cleanly
  Widget _buildPage({
    required Color color,
    required String lottiePath,
    required String title,
    required String subtitle,
  }) {
    return Container(
      color: color,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // THE MAGIC HAPPENS HERE
          Lottie.asset(
            lottiePath,
            height: 250, // Make it big and beautiful
            repeat: true, // Keep the animation looping
            reverse: false,
            animate: true,
          ),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
