import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_master/Bloc/game_bloc.dart';
import 'package:number_master/Screens/game_screen.dart';
import 'package:number_master/Screens/info_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get SharedPreferences instance
  final prefs = await SharedPreferences.getInstance();

  // Check for the flag. '?? true' means default to true if it doesn't exist
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  runApp(MyApp(isFirstTime: isFirstTime));
}

// class MyApp extends StatelessWidget {
//   final bool? isFirstTime;
//   const MyApp({super.key, this.isFirstTime});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       // The GameBloc manages all the game state and logic.
//       create: (context) => GameBloc(),
//       child: MaterialApp(
//         title: 'Number Master',
//         theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
//           useMaterial3: true,
//           scaffoldBackgroundColor: const Color(0xFFF6F8FC),
//           cardTheme: CardThemeData(
//             color: Colors.white,
//             surfaceTintColor: Colors.white,
//             elevation: 2,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           appBarTheme: const AppBarTheme(
//             centerTitle: true,
//             elevation: 1,
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.indigo,
//               foregroundColor: Colors.white,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//         ),
//         home: const GameScreen(),
//         debugShowCheckedModeBanner: false,
//       ),
//     );
//   }
// }
class MyApp extends StatelessWidget {
  // 2. MAKE 'isFirstTime' REQUIRED AND NON-NULLABLE
  //    (This is cleaner than using bool?)
  final bool isFirstTime;
  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // The GameBloc manages all the game state and logic.
      create: (context) => GameBloc(),
      child: MaterialApp(
        title: 'Number Master',
        theme: ThemeData(
          // ... (Your theme data is all correct)
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF6F8FC),
          cardTheme: CardThemeData(
            color: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 1,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: isFirstTime ? const IntroScreen() : const GameScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
