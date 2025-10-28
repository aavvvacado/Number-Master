import 'package:flutter/material.dart';
import 'package:number_master/Models/game_cell.dart'; // Assuming GameCell and CellState are defined here

class GameCellWidget extends StatelessWidget {
  final GameCell cell;
  final Function(int) onTap;
  final bool isInvalid;
  final bool isHint;

  const GameCellWidget({
    super.key,
    required this.cell,
    required this.onTap,
    this.isInvalid = false,
    this.isHint = false,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor;
    Color textColor;
    Color borderColor;
    double opacity = 1.0;

    // --- Define your new theme colors ---
    const Color glowColor = Color(0xFF00FFFF); // Bright cyan for the "glow"
    const Color darkCellBackground =
        Color.fromARGB(255, 76, 5, 2); // Dark purple from image
    const Color subtleBorder = Colors.transparent; // Or Colors.grey.shade800
    // ------------------------------------

    if (isInvalid) {
      cardColor = Colors.red.shade400;
      textColor = Colors.white;
      borderColor = Colors.red.shade700;
    } else if (isHint) {
      cardColor = Colors.amber.shade300;
      textColor = Colors.black87;
      borderColor = Colors.amber.shade600;
    } else {
      switch (cell.state) {
        case CellState.selected:
          // --- This is the new "selected" style ---
          cardColor = darkCellBackground;
          textColor = Colors.white;
          borderColor = const Color.fromARGB(
              255, 244, 234, 126); // Use the bright "glow" color for the border
          break;
        // --------------------------------------
        case CellState.matched:
          cardColor = const Color.fromARGB(255, 120, 2, 2);
          textColor = Colors.grey.shade600;
          borderColor = Colors.grey.shade400;
          opacity = 0.4; // Faded effect
          break;
        case CellState.active:
        default:
          // --- This is the new "active" (default) style ---
          cardColor = darkCellBackground;
          textColor = Colors.white; // Set to white for dark background
          borderColor = subtleBorder;
          break;
        // ---------------------------------------------
      }
    }

    // --- Define the shadows ---
    final glowShadow = BoxShadow(
      color: const Color.fromARGB(255, 246, 230, 113).withOpacity(0.7),
      blurRadius: 10.0,
      spreadRadius: 2.0,
    );

    final standardShadow = BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 6,
      offset: const Offset(2, 2),
    );
    // --------------------------

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: opacity,
      child: GestureDetector(
        onTap: () => onTap(cell.id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              // --- Make the border thicker when selected ---
              width: isInvalid
                  ? 3
                  : (isHint ? 3 : (cell.state == CellState.selected ? 3 : 1)),
            ),
            boxShadow: [
              // --- Conditionally add the glow shadow ---
              if (cell.state == CellState.selected) glowShadow,
              standardShadow, // Always include the standard shadow for depth
            ],
          ),
          child: Center(
            child: Text(
              '${cell.value}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
                // --- Removed the selected text shadow, as it's not in the image ---
                // shadows: ...
              ),
            ),
          ),
        ),
      ),
    );
  }
}
