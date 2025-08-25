part of 'game_bloc.dart';

enum GameStatus { initial, playing, won, lost }

class GameState extends Equatable {
  final List<GameCell> cells;
  final GameStatus status;
  final int currentLevel;
  final int matchesMade;
  final List<GameCell> selectedCells;
  final List<int> invalidMatchIds;
  final int addedRowsCount;
  final int score;
  final List<int> hintCellIds;

  const GameState({
    required this.cells,
    required this.status,
    required this.currentLevel,
    required this.matchesMade,
    required this.selectedCells,
    this.invalidMatchIds = const [],
    this.addedRowsCount = 0,
    this.score = 0,
    this.hintCellIds = const [],
  });

  factory GameState.initial() {
    return const GameState(
      cells: [], // Initial cells are now generated in GameInitialized
      status: GameStatus.initial,
      currentLevel: 1,
      matchesMade: 0,
      selectedCells: [],
      invalidMatchIds: [],
      addedRowsCount: 0,
      score: 0,
      hintCellIds: [],
    );
  }

  GameState copyWith({
    List<GameCell>? cells,
    GameStatus? status,
    int? currentLevel,
    int? matchesMade,
    List<GameCell>? selectedCells,
    List<int>? invalidMatchIds,
    int? addedRowsCount,
    int? score,
    List<int>? hintCellIds,
  }) {
    return GameState(
      cells: cells ?? this.cells,
      status: status ?? this.status,
      currentLevel: currentLevel ?? this.currentLevel,
      matchesMade: matchesMade ?? this.matchesMade,
      selectedCells: selectedCells ?? this.selectedCells,
      invalidMatchIds: invalidMatchIds ?? this.invalidMatchIds,
      addedRowsCount: addedRowsCount ?? this.addedRowsCount,
      score: score ?? this.score,
      hintCellIds: hintCellIds ?? this.hintCellIds,
    );
  }

  @override
  List<Object?> get props => [
        cells,
        status,
        currentLevel,
        matchesMade,
        selectedCells,
        invalidMatchIds,
        addedRowsCount,
        score,
        hintCellIds,
      ];
}
