import 'package:flutter/material.dart';
import 'package:number_master/Models/game_cell.dart';

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
          cardColor = Colors.blue.shade400;
          textColor = Colors.white;
          borderColor = Colors.blue.shade700;
          break;
        case CellState.matched:
          cardColor = Colors.grey.shade300;
          textColor = Colors.grey.shade600;
          borderColor = Colors.grey.shade400;
          opacity = 0.6; // Faded effect
          break;
        case CellState.active:
        default:
          cardColor = Colors.white;
          textColor = Colors.black87;
          borderColor = Colors.grey.shade400;
          break;
      }
    }

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
              width: isInvalid ? 3 : (isHint ? 3 : 2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${cell.value}',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
                shadows: cell.state == CellState.selected ? [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ] : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
