import 'package:flutter/material.dart';
import 'package:number_master/Screens/intro_screen.dart';
import 'package:number_master/Transitions/pageRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- 1. Define the content for our pages with THEMED colors ---
  final List<Map<String, dynamic>> _pageData = [
    {
      "icon": Icons.numbers_rounded,
      "title": "Welcome to Number Master!",
      "description":
          "Get ready to challenge your mind and find the matching numbers.",
      "color": Colors.white,
    },
    {
      "icon": Icons.touch_app_rounded,
      "title": "How to Play",
      "description":
          "Tap on any two numbers to see if they match. Find all the pairs to win the level.",
      "color": Colors.white
    },
    {
      "icon": Icons.celebration_rounded,
      "title": "Ready to Start?",
      "description":
          "Complete all the levels and become the ultimate Number Master!",
      "color": Colors.white
    }
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Sets the flag in SharedPreferences and navigates to the IntroScreen.
  Future<void> _getStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenWelcome', true);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        ScreenTransition.createRoute(const IntroScreen()),
      );
    }
  }

  /// Handles button press
  void _onButtonPressed() {
    if (_currentPage == _pageData.length - 1) {
      // Last page: Get Started
      _getStarted();
    } else {
      // Not last page: Go to next page
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- 2. Use a Stack to layer background and content ---
    return Scaffold(
      backgroundColor: Colors.transparent, // Make scaffold transparent
      body: Stack(
        fit: StackFit.expand,
        children: [
          // --- 3. Add the same background image as other screens ---
          Image.asset(
            'assets/Theme/a.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.darken,
          ),

          // --- 4. Content layer ---
          SafeArea(
            child: Column(
              children: [
                // 1. PageView for swipeable content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pageData.length,
                    onPageChanged: (int page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPageContent(
                        icon: _pageData[index]['icon'],
                        title: _pageData[index]['title'],
                        description: _pageData[index]['description'],
                        color: _pageData[index]['color'],
                      );
                    },
                  ),
                ),

                // 2. Page Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(),
                ),
                const SizedBox(height: 30),

                // 3. Dynamic "Next" / "Get Started" Button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 20.0),
                  child: ElevatedButton(
                    onPressed: _onButtonPressed,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.white, // Use white text
                      minimumSize:
                          const Size(double.infinity, 60), // Full width
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        // side: BorderSide(
                        //   color:
                        //       _pageData[_currentPage]['color'] == Colors.amber
                        //           ? Colors.yellowAccent
                        //           : Colors.orange,
                        //   width: 2,
                        // ),
                      ),
                      elevation: 8,
                    ),
                    // Change text based on the current page
                    child: Text(
                      _currentPage == _pageData.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget to build the content for each page
  Widget _buildPageContent({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 140, color: color),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pageData.length; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  /// Helper widget for a single indicator dot
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 10.0,
      width: isActive ? 24.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? _pageData[_currentPage]['color'] : Colors.white30,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
