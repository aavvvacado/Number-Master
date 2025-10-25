import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_master/Screens/game_screen.dart';
import 'package:number_master/Transitions/pageRoute.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

// --- 1. Use TickerProviderStateMixin (plural) for multiple controllers ---
class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  // --- 2. Define both controllers ---
  late AnimationController _entryController;
  late AnimationController _bobbingController;

  // --- 3. Define animations for both entry AND bobbing ---
  late Animation<double> _logoSlideAnimation;
  late Animation<double> _buttonSlideAnimation;
  late Animation<double> _logoBobAnimation;
  late Animation<double> _buttonBobAnimation;

  @override
  void initState() {
    super.initState();

    // --- 4. Initialize the ENTRY controller (runs once) ---
    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // --- 5. Initialize the BOBBING controller (loops) ---
    _bobbingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // --- 6. Setup the ENTRY animations ---
    // Logo slides in from -300 (top) to 0
    _logoSlideAnimation = Tween<double>(begin: -300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
      ),
    );
    // Buttons slide in from 300 (bottom) to 0
    _buttonSlideAnimation = Tween<double>(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
      ),
    );

    // --- 7. Setup the BOBBING animations ---
    // Logo bobs between -8 and 8
    _logoBobAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _bobbingController,
        curve: Curves.easeInOut,
      ),
    );
    // Buttons bob between 4 and -4
    _buttonBobAnimation = Tween<double>(begin: 4.0, end: -4.0).animate(
      CurvedAnimation(
        parent: _bobbingController,
        curve: Curves.easeInOut,
      ),
    );

    // --- 8. Link the controllers ---
    _entryController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // When entry is done, start the bobbing
        _bobbingController.repeat(reverse: true);
      }
    });

    // --- 9. Start the entry animation ---
    _entryController.forward();
  }

  @override
  void dispose() {
    // --- 10. Dispose BOTH controllers ---
    _entryController.dispose();
    _bobbingController.dispose();
    super.dispose();
  }

  /// Navigates to the main game screen.
  void _startGame() {
    Navigator.of(context)
        .push(ScreenTransition.createRoute(const GameScreen()));
  }

  /// Shows a dialog with the game rules.
  void _showRulesDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[900],
          title: const Text(
            'Game Rules',
            style: TextStyle(
              color: Colors.yellowAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Guess the correct number to win! More rules can be explained here.',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Got it!',
                style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Exits the application.
  void _exitGame() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Image
          Image.asset(
            'assets/Theme/a.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),

          // 2. UI Elements in the foreground
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // --- 11. Animate the Logo ---
              AnimatedBuilder(
                // Listen to BOTH controllers
                animation: Listenable.merge([_entryController, _bobbingController]),
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    // ADD the slide value and the bob value together
                    offset: Offset(0, _logoSlideAnimation.value + _logoBobAnimation.value),
                    child: child,
                  );
                },
                child: SizedBox(
                  width: 600,
                  height: 400,
                  child: Image.asset(
                    "assets/Theme/NM.png",
                  ),
                ),
              ),

              const SizedBox(height: 4.0), // Spacer

              // --- 12. Animate the Start Button ---
              AnimatedBuilder(
                animation: Listenable.merge([_entryController, _bobbingController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _buttonSlideAnimation.value + _buttonBobAnimation.value),
                    child: child,
                  );
                },
                child: _buildImageButton(
                    imagePath: 'assets/Theme/StartBtn.png', onTap: _startGame),
              ),
              const SizedBox(height: 20.0),

              // --- 13. Animate the Rules Button ---
              AnimatedBuilder(
                animation: Listenable.merge([_entryController, _bobbingController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _buttonSlideAnimation.value + _buttonBobAnimation.value),
                    child: child,
                  );
                },
                child: _buildImageButton(
                    imagePath: 'assets/Theme/rules.png',
                    onTap: _showRulesDialog),
              ),
              const SizedBox(height: 20.0),

              // --- 14. Animate the Exit Button ---
              AnimatedBuilder(
                animation: Listenable.merge([_entryController, _bobbingController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _buttonSlideAnimation.value + _buttonBobAnimation.value),
                    child: child,
                  );
                },
                child: _buildImageButton(
                    imagePath: 'assets/Theme/exit.png', onTap: _exitGame),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// A helper method to build styled buttons to avoid code repetition.
  Widget _buildImageButton({
    required String imagePath,
    required VoidCallback onTap,
    double? width = 270,
    double? height = 105,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}