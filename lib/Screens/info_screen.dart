// lib/intro_screen.dart

import 'package:number_master/Screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  // This controls the fade-in animation
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Start the fade-in animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        // Check if the widget is still in the widget tree
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  /// This function handles all the logic required when the user finishes the intro.
  Future<void> _completeIntro() async {
    // 1. Requirement: Store flag in local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);

    // 2. Navigate to the main game screen and *replace* this intro screen
    //    so the user can't press "back" to get to it.
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                const GameScreen()), // <-- Make sure GameScreen() is correct
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Requirement: Simple animation or logo intro
                  AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 2), // Fade-in duration
                    curve: Curves.easeIn,
                    child: Column(
                      children: [
                        // --- REPLACE THIS WITH YOUR LOGO OR ANIMATION ---
                        // You can use:
                        // - Image.asset('assets/logo.png')
                        // - A Lottie animation widget
                        const FlutterLogo(
                          size: 140,
                        ),
                        // --- END OF LOGO SECTION ---

                        const SizedBox(height: 24),
                        Text(
                          'Welcome to Number Master!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Match numbers that are equal or sum to 10. Challenge your mind and climb the levels!',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // "Get Started" Button
                  ElevatedButton(
                    onPressed: _completeIntro,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: const Text('Get Started'),
                  ),
                  const SizedBox(height: 20), // Padding at the bottom
                ],
              ),
            ),
          ),

          // Requirement: Option to skip intro
          Positioned(
            top: 40.0, // Adjust based on your device's status bar
            right: 20.0,
            child: SafeArea(
              child: TextButton(
                onPressed: _completeIntro,
                child: const Text(
                  'Skip',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
