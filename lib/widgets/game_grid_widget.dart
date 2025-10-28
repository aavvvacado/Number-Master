import 'package:flutter/material.dart';
import 'package:number_master/Models/game_cell.dart';
import 'package:number_master/widgets/game_cell_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class GameGridWidget extends StatelessWidget {
  final List<GameCell> cells;
  final Function(int) onCellTap;
  final List<int> invalidMatchIds;
  final List<int> hintCellIds;

  const GameGridWidget({
    super.key,
    required this.cells,
    required this.onCellTap,
    this.invalidMatchIds = const [],
    this.hintCellIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    if (cells.isEmpty) {
      return const Center(
        child: Text('No cells to display', style: TextStyle(fontSize: 18)),
      );
    }

    // Group cells by row
    Map<int, List<GameCell>> cellsByRow = {};
    for (var cell in cells) {
      cellsByRow.putIfAbsent(cell.row, () => []).add(cell);
    }

    // Sort rows and cells within each row
    List<int> sortedRows = cellsByRow.keys.toList()..sort();
    for (var row in sortedRows) {
      cellsByRow[row]!.sort((a, b) => a.col.compareTo(b.col));
    }

    // Calculate the maximum number of columns to determine grid crossAxisCount
    int maxColumns = 0;
    for (var rowCells in cellsByRow.values) {
      if (rowCells.length > maxColumns) {
        maxColumns = rowCells.length;
      }
    }

    return AnimationLimiter(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 2),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade50,
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: maxColumns,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: 1.0,
          ),
          itemCount: cells.length,
          itemBuilder: (context, index) {
            final cell = cells[index];
            final isInvalid = invalidMatchIds.contains(cell.id);
            final isHint = hintCellIds.contains(cell.id);

            return AnimationConfiguration.staggeredGrid(
              position: index,
              columnCount: maxColumns,
              duration: const Duration(milliseconds: 375),
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: GameCellWidget(
                    cell: cell,
                    onTap: onCellTap,
                    isInvalid: isInvalid,
                    isHint: isHint,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
