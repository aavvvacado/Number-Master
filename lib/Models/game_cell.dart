import 'package:equatable/equatable.dart';

enum CellState { active, selected, matched }

class GameCell extends Equatable {
  final int value;
  final int id;
  final int row;
  final int col;
  final CellState state;

  const GameCell({
    required this.id,
    required this.value,
    required this.row,
    required this.col,
    this.state = CellState.active,
  });

  // Method to create a new GameCell with updated properties.
  GameCell copyWith({
    int? value,
    int? id,
    int? row,
    int? col,
    CellState? state,
  }) {
    return GameCell(
      id: id ?? this.id,
      value: value ?? this.value,
      row: row ?? this.row,
      col: col ?? this.col,
      state: state ?? this.state,
    );
  }

  @override
  List<Object?> get props => [id, value, row, col, state];
}
