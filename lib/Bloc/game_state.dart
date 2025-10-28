// part of 'game_bloc.dart';

// enum GameStatus { initial, playing, won, lost }

// class GameState extends Equatable {
//   final List<GameCell> cells;
//   final GameStatus status;
//   final int currentLevel;
//   final int matchesMade;
//   final List<GameCell> selectedCells;
//   final List<int> invalidMatchIds;
//   final int addedRowsCount;
//   final int score;
//   final List<int> hintCellIds;
//   final GameState previousState;

//   const GameState({
//     required this.cells,
//     required this.status,
//     required this.currentLevel,
//     required this.matchesMade,
//     required this.selectedCells,
//     this.previousState = const GameState.initial(),
//     this.invalidMatchIds = const [],
//     this.addedRowsCount = 0,
//     this.score = 0,
//     this.hintCellIds = const [],
//   });

//   // factory GameState.initial() {
//   //   return const GameState(
//   //     cells: [], // Initial cells are now generated in GameInitialized
//   //     status: GameStatus.initial,
//   //     currentLevel: 1,
//   //     matchesMade: 0,
//   //     selectedCells: [],
//   //     invalidMatchIds: [],
//   //     addedRowsCount: 0,
//   //     score: 0,
//   //     hintCellIds: [],
//   //   );
//   // }

//   const GameState.initial() // <-- MODIFY THIS
//       : this(
//           status: GameStatus.initial,
//           cells: const [],
//           selectedCells: const [],
//           invalidMatchIds: const [],
//           hintCellIds: const [],
//           currentLevel: 1,
//           matchesMade: 0,
//           score: 0,
//           addedRowsCount: 0,
//           previousState:
//               const GameState._internalInitial(), // Use a private constructor
//         );
//   const GameState._internalInitial()
//       : status = GameStatus.initial,
//         cells = const [],
//         selectedCells = const [],
//         invalidMatchIds = const [],
//         hintCellIds = const [],
//         currentLevel = 1,
//         matchesMade = 0,
//         score = 0,
//         addedRowsCount = 0,
//         previousState = const GameState._internalInitial();
//   GameState copyWith({
//     List<GameCell>? cells,
//     GameState? previousState,
//     GameStatus? status,
//     int? currentLevel,
//     int? matchesMade,
//     List<GameCell>? selectedCells,
//     List<int>? invalidMatchIds,
//     int? addedRowsCount,
//     int? score,
//     List<int>? hintCellIds,
//   }) {
//     return GameState(
//       previousState: previousState ?? this,
//       cells: cells ?? this.cells,
//       status: status ?? this.status,
//       currentLevel: currentLevel ?? this.currentLevel,
//       matchesMade: matchesMade ?? this.matchesMade,
//       selectedCells: selectedCells ?? this.selectedCells,
//       invalidMatchIds: invalidMatchIds ?? this.invalidMatchIds,
//       addedRowsCount: addedRowsCount ?? this.addedRowsCount,
//       score: score ?? this.score,
//       hintCellIds: hintCellIds ?? this.hintCellIds,
//     );
//   }

//   @override
//   List<Object?> get props => [
//         cells,
//         status,
//         currentLevel,
//         matchesMade,
//         selectedCells,
//         invalidMatchIds,
//         addedRowsCount,
//         score,
//         hintCellIds,
//       ];
// }

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
  // final GameState previousState; // <-- 1. DELETE THIS LINE

  const GameState({
    required this.cells,
    required this.status,
    required this.currentLevel,
    required this.matchesMade,
    required this.selectedCells,
    // this.previousState = ..., // <-- 2. DELETE THIS LINE
    this.invalidMatchIds = const [],
    this.addedRowsCount = 0,
    this.score = 0,
    this.hintCellIds = const [],
  });

  // <-- 3. RESTORE THIS FACTORY
  factory GameState.initial() {
    return const GameState(
      cells: [],
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

  // <-- 4. DELETE const GameState.initial() AND const GameState._internalInitial()

  GameState copyWith({
    List<GameCell>? cells,
    // GameState? previousState, // <-- 5. DELETE THIS LINE
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
        // No need to add previousState here
      ];
}
