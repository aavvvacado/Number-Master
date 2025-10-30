import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:number_master/Screens/game_screen.dart';
import 'package:number_master/Transitions/pageRoute.dart';
import 'package:number_master/services/audio_player_services.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _bobbingController;

  late Animation<double> _logoSlideAnimation;
  late Animation<double> _buttonSlideAnimation;
  late Animation<double> _logoBobAnimation;
  late Animation<double> _buttonBobAnimation;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bobbingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _logoSlideAnimation = Tween<double>(begin: -300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
      ),
    );
    _buttonSlideAnimation = Tween<double>(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
      ),
    );

    _logoBobAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(
        parent: _bobbingController,
        curve: Curves.easeInOut,
      ),
    );
    _buttonBobAnimation = Tween<double>(begin: 4.0, end: -4.0).animate(
      CurvedAnimation(
        parent: _bobbingController,
        curve: Curves.easeInOut,
      ),
    );

    _entryController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bobbingController.repeat(reverse: true);
      }
    });

    _entryController.forward();
  }

  @override
  void dispose() {
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
                AudioService.instance.playTapSound();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.red[900],
              title: const Text(
                'Settings',
                style: TextStyle(
                  color: Colors.yellowAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text(
                      'Sound Effects',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: AudioService.instance.isSfxEnabled,
                    onChanged: (bool value) async {
                      // Toggle the sound
                      await AudioService.instance.toggleSfx();
                      // Rebuild the dialog's UI
                      setDialogState(() {});
                    },
                    activeColor: Colors.yellowAccent,
                  ),
                  // We will add "Background Music" toggle here in PR 2
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Done',
                    style: TextStyle(color: Colors.yellowAccent, fontSize: 16),
                  ),
                  onPressed: () {
                    AudioService.instance.playTapSound();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
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
    // --- 1. Get screen size for responsiveness ---
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Theme/a.png',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.darken,
          ),
          SafeArea(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [_entryController, _bobbingController]),
                        builder: (BuildContext context, Widget? child) {
                          return Transform.translate(
                            offset: Offset(
                                0,
                                _logoSlideAnimation.value +
                                    _logoBobAnimation.value),
                            child: child,
                          );
                        },
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          height: screenHeight * 0.4,
                          child: Image.asset(
                            "assets/Theme/NM.png",
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 4.0),
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [_entryController, _bobbingController]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                                0,
                                _buttonSlideAnimation.value +
                                    _buttonBobAnimation.value),
                            child: child,
                          );
                        },
                        child: _buildImageButton(
                          imagePath: 'assets/Theme/StartBtn.png',
                          onTap: _startGame,
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.12,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // --- Animate the Rules Button ---
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [_entryController, _bobbingController]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                                0,
                                _buttonSlideAnimation.value +
                                    _buttonBobAnimation.value),
                            child: child,
                          );
                        },
                        child: _buildImageButton(
                          imagePath: 'assets/Theme/rules.png',
                          onTap: _showRulesDialog,
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.12,
                        ),
                      ),
                      const SizedBox(height: 20.0),

                      // --- SETTINGS BUTTON HAS BEEN REMOVED FROM HERE ---

                      // --- Animate the Exit Button ---
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [_entryController, _bobbingController]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                                0,
                                _buttonSlideAnimation.value +
                                    _buttonBobAnimation.value),
                            child: child,
                          );
                        },
                        child: _buildImageButton(
                          imagePath: 'assets/Theme/exit.png',
                          onTap: _exitGame,
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.12,
                        ),
                      ),
                      const SizedBox(height: 30.0),
                    ],
                  ),
                ),
                Positioned(
                  top: 8.0,
                  right: 8.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.settings),
                      color: Colors.white,
                      iconSize: 30.0,
                      tooltip: 'Settings',
                      onPressed: () {
                        // Play tap sound *first*
                        AudioService.instance.playTapSound();
                        // Then open the dialog
                        _showSettingsDialog();
                      },
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

  Widget _buildImageButton({
    required String imagePath,
    required VoidCallback onTap,
    double? width = 270,
    double? height = 105,
  }) {
    return GestureDetector(
      onTap: () {
        AudioService.instance.playTapSound();

        onTap();
      },
      // onTap: onTap,
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
