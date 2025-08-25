import 'dart:math';

import 'package:number_master/Models/game_cell.dart';
import 'package:number_master/Models/game_level.dart';

// Game state for undo/redo functionality
class GameState {
  final List<int?> board;
  final int score;
  final int moves;
  final DateTime timestamp;

  GameState({
    required this.board,
    required this.score,
    required this.moves,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  GameState copyWith({
    List<int?>? board,
    int? score,
    int? moves,
  }) {
    return GameState(
      board: board ?? List<int?>.from(this.board),
      score: score ?? this.score,
      moves: moves ?? this.moves,
    );
  }
}

class NumberMasterLogic {
  // Board representation as List<int?> with configurable row length
  static List<int?> board = [];
  static int rowLength = 6; // Default row length
  static int score = 0;
  static int moves = 0;

  // Enhanced game state management for undo/redo
  static List<GameState> gameHistory = [];
  static int currentHistoryIndex = -1;
  static const int maxHistorySize = 50;

  // Game difficulty and challenge settings
  static int targetMatches = 10; // Increased difficulty
  static int matchesFound = 0;

  // Selected cells tracking to prevent self-matching
  static int? selectedCellIndex;
  static List<int> highlightedCells = [];

  // Initialize the board and save initial state
  static void initializeBoard(List<int?> initialBoard, int rowLength,
      {int? targetCount}) {
    board = List<int?>.from(initialBoard);
    NumberMasterLogic.rowLength = rowLength;
    score = 0;
    moves = 0;
    matchesFound = 0;
    selectedCellIndex = null;
    highlightedCells.clear();

    // Set target matches based on board size and difficulty
    if (targetCount != null) {
      targetMatches = targetCount;
    } else {
      // Increased difficulty: more targets required
      int nonNullCells = initialBoard.where((cell) => cell != null).length;
      targetMatches =
          (nonNullCells * 0.6).ceil(); // 60% of cells need to be matched
    }

    // Save initial game state
    _saveGameState();
  }

  // Save current game state to history
  static void _saveGameState() {
    // Remove any states after current index (when we're in middle of history)
    if (currentHistoryIndex < gameHistory.length - 1) {
      gameHistory.removeRange(currentHistoryIndex + 1, gameHistory.length);
    }

    // Add new state
    gameHistory.add(GameState(
      board: List<int?>.from(board),
      score: score,
      moves: moves,
    ));

    // Maintain history size limit
    if (gameHistory.length > maxHistorySize) {
      gameHistory.removeAt(0);
    } else {
      currentHistoryIndex++;
    }
  }

  // Undo last move
  static bool undoMove() {
    if (currentHistoryIndex > 0) {
      currentHistoryIndex--;
      _restoreGameState(gameHistory[currentHistoryIndex]);
      return true;
    }
    return false;
  }

  // Redo next move
  static bool redoMove() {
    if (currentHistoryIndex < gameHistory.length - 1) {
      currentHistoryIndex++;
      _restoreGameState(gameHistory[currentHistoryIndex]);
      return true;
    }
    return false;
  }

  // Restore game state from history
  static void _restoreGameState(GameState state) {
    board = List<int?>.from(state.board);
    score = state.score;
    moves = state.moves;
    selectedCellIndex = null;
    highlightedCells.clear();
  }

  // Check if undo is available
  static bool canUndo() => currentHistoryIndex > 0;

  // Check if redo is available
  static bool canRedo() => currentHistoryIndex < gameHistory.length - 1;

  // Enhanced cell selection with self-matching prevention
  static bool selectCell(int index) {
    if (!isValidIndex(index) || board[index] == null) {
      return false;
    }

    // **Rule 1: Self-Matching Fix** - Prevent selecting the same cell twice
    if (selectedCellIndex == index) {
      // Deselect if same cell is tapped again
      selectedCellIndex = null;
      highlightedCells.clear();
      return false;
    }

    if (selectedCellIndex == null) {
      // First cell selection
      selectedCellIndex = index;
      highlightedCells = [index];
      return false; // Not a match yet, waiting for second cell
    } else {
      // Second cell selection - attempt to make a match
      bool matchResult = attemptMatch(selectedCellIndex!, index);
      selectedCellIndex = null;
      highlightedCells.clear();

      if (matchResult) {
        moves++;
        matchesFound++;
        _saveGameState(); // **Rule 2: Save state after successful move**
      }

      return matchResult;
    }
  }

  // Attempt to match two cells
  static bool attemptMatch(int i, int j) {
    // **Rule 1: Ensure different cells**
    if (i == j) return false;

    if (isValidPair(i, j)) {
      return removePair(i, j);
    }
    return false;
  }

  // Get row and column from index
  static int getRow(int index) => index ~/ rowLength;
  static int getCol(int index) => index % rowLength;

  // Get index from row and column
  static int getIndex(int row, int col) => row * rowLength + col;

  // Check if index is valid
  static bool isValidIndex(int index) => index >= 0 && index < board.length;

  // Check if two numbers can form a valid pair (equal or sum to 10)
  static bool canFormPair(int? a, int? b) {
    if (a == null || b == null) return false;
    return a == b || a + b == 10;
  }

  // Check if two indexes are adjacent horizontally
  static bool isAdjacentHorizontal(int i, int j) {
    if (!isValidIndex(i) || !isValidIndex(j)) return false;
    int rowI = getRow(i), colI = getCol(i);
    int rowJ = getRow(j), colJ = getCol(j);
    return rowI == rowJ && (colI - colJ).abs() == 1;
  }

  // Check if two indexes are adjacent vertically
  static bool isAdjacentVertical(int i, int j) {
    if (!isValidIndex(i) || !isValidIndex(j)) return false;
    int rowI = getRow(i), colI = getCol(i);
    int rowJ = getRow(j), colJ = getCol(j);
    return colI == colJ && (rowI - rowJ).abs() == 1;
  }

  // Check if two indexes are adjacent diagonally
  static bool isAdjacentDiagonal(int i, int j) {
    if (!isValidIndex(i) || !isValidIndex(j)) return false;
    int rowI = getRow(i), colI = getCol(i);
    int rowJ = getRow(j), colJ = getCol(j);
    return (rowI - rowJ).abs() == 1 && (colI - colJ).abs() == 1;
  }

  // Check if two indexes can connect diagonally through empty cells
  static bool canConnectDiagonally(int i, int j) {
    if (!isValidIndex(i) || !isValidIndex(j)) return false;
    if (board[i] == null || board[j] == null) return false;

    int rowI = getRow(i), colI = getCol(i);
    int rowJ = getRow(j), colJ = getCol(j);

    // Must be diagonal (same row and column difference)
    int rowDiff = (rowI - rowJ).abs();
    int colDiff = (colI - colJ).abs();
    if (rowDiff != colDiff) return false;

    // If adjacent, always allow
    if (rowDiff == 1) return true;

    // For longer diagonals, check if path is clear
    int startRow = rowI < rowJ ? rowI : rowJ;
    int startCol = colI < colJ ? colI : colJ;
    int endCol = colI > colJ ? colI : colJ;

    // Determine diagonal direction
    bool isTopLeftToBottomRight =
        (rowI < rowJ && colI < colJ) || (rowJ < rowI && colJ < colI);

    // Check each position in the diagonal path (excluding start and end)
    for (int k = 1; k < rowDiff; k++) {
      int checkRow, checkCol;

      if (isTopLeftToBottomRight) {
        checkRow = startRow + k;
        checkCol = startCol + k;
      } else {
        checkRow = startRow + k;
        checkCol = endCol - k;
      }

      int checkIndex = getIndex(checkRow, checkCol);
      if (isValidIndex(checkIndex) && board[checkIndex] != null) {
        return false; // Path is blocked by a number
      }
    }

    return true;
  }

  // Check if two indexes can wrap from end of row to start of next row
  static bool canWrap(int i, int j) {
    if (!isValidIndex(i) || !isValidIndex(j)) return false;
    if (board[i] == null || board[j] == null) return false;

    int rowI = getRow(i), colI = getCol(i);
    int rowJ = getRow(j), colJ = getCol(j);

    // Must be consecutive rows
    if (rowJ != rowI + 1) return false;

    // First cell must be at the end of its row, second at the start of next row
    return colI == rowLength - 1 && colJ == 0;
  }

  // Check if two indexes form a valid pair
  static bool isValidPair(int i, int j) {
    if (!isValidIndex(i) || !isValidIndex(j) || i == j) return false;
    if (board[i] == null || board[j] == null) return false;

    // Check if they can form a valid pair
    if (!canFormPair(board[i], board[j])) return false;

    // Check if they are connected (adjacent or diagonal through empty cells or wrap)
    return isAdjacentHorizontal(i, j) ||
        isAdjacentVertical(i, j) ||
        isAdjacentDiagonal(i, j) ||
        canConnectDiagonally(i, j) ||
        canWrap(i, j);
  }

  // Remove a valid pair and increase score
  static bool removePair(int i, int j) {
    if (!isValidPair(i, j)) return false;

    board[i] = null;
    board[j] = null;
    score += 10; // 10 points per pair

    return true;
  }

  // Find all possible valid pairs on the board
  static List<List<int>> findAllPairs() {
    List<List<int>> pairs = [];

    for (int i = 0; i < board.length; i++) {
      for (int j = i + 1; j < board.length; j++) {
        if (isValidPair(i, j)) {
          pairs.add([i, j]);
        }
      }
    }

    return pairs;
  }

  // **Rule 5: Enhanced difficulty** - Add more numbers with strategic placement
  static void addMoreNumbers() {
    List<int> remainingNumbers = [];

    // Collect all non-null numbers in order
    for (int i = 0; i < board.length; i++) {
      if (board[i] != null) {
        remainingNumbers.add(board[i]!);
      }
    }

    // **Rule 5: Increase difficulty** - Add more random numbers to challenge
    Random random = Random();
    int additionalNumbers =
        (remainingNumbers.length * 0.3).ceil(); // Add 30% more numbers
    for (int i = 0; i < additionalNumbers; i++) {
      remainingNumbers.add(random.nextInt(9) + 1);
    }

    // Clear the board and expand if necessary
    int requiredSize = remainingNumbers.length;
    int requiredRows = (requiredSize / rowLength).ceil();
    int newBoardSize = requiredRows * rowLength;

    board = List<int?>.filled(newBoardSize, null);

    // Add remaining numbers back in order
    for (int i = 0; i < remainingNumbers.length && i < board.length; i++) {
      board[i] = remainingNumbers[i];
    }

    // Save state after adding numbers
    _saveGameState();
  }

  // Check if the board is completely cleared
  static bool isCleared() {
    return board.every((cell) => cell == null);
  }

  // Check if level is completed (enough matches found)
  static bool isLevelCompleted() {
    return matchesFound >= targetMatches;
  }

  // Get current score
  static int getScore() => score;

  // Get current moves
  static int getMoves() => moves;

  // Get matches found
  static int getMatchesFound() => matchesFound;

  // Get target matches
  static int getTargetMatches() => targetMatches;

  // Add bonus points for clearing the board or completing level
  static void addClearBonus() {
    if (isCleared()) {
      score += 200; // Increased bonus for complete clear
    } else if (isLevelCompleted()) {
      score += 100; // Bonus for reaching target
    }
  }

  // **Rule 5: Enhanced difficulty** - Generate more challenging boards
  static List<int?> generateRandomBoard(int rows, int cols,
      {bool increasedDifficulty = true}) {
    List<int?> board = [];
    Random random = Random();

    int totalCells = rows * cols;
    int filledCells = increasedDifficulty
        ? (totalCells * 0.8).ceil()
        : // 80% filled for increased difficulty
        (totalCells * 0.6).ceil(); // 60% filled for normal

    // Generate numbers with strategic distribution
    List<int> numbers = [];
    for (int i = 0; i < filledCells; i++) {
      // Weighted distribution: more mid-range numbers (4-7) for matching challenges
      int weight = random.nextInt(100);
      int number;
      if (weight < 40) {
        number = random.nextInt(4) + 4; // 4-7 (40% chance)
      } else if (weight < 70) {
        number = random.nextInt(3) + 1; // 1-3 (30% chance)
      } else {
        number = random.nextInt(2) + 8; // 8-9 (30% chance)
      }
      numbers.add(number);
    }

    // Shuffle and place numbers
    numbers.shuffle();

    for (int i = 0; i < totalCells; i++) {
      if (i < numbers.length) {
        board.add(numbers[i]);
      } else {
        board.add(null);
      }
    }

    return board;
  }

  // Get hint for next possible move
  static List<int>? getHint() {
    var pairs = findAllPairs();
    if (pairs.isNotEmpty) {
      return pairs.first;
    }
    return null;
  }

  // Reset selection state
  static void clearSelection() {
    selectedCellIndex = null;
    highlightedCells.clear();
  }

  // Get currently selected cell
  static int? getSelectedCell() => selectedCellIndex;

  // Get highlighted cells
  static List<int> getHighlightedCells() => List<int>.from(highlightedCells);

  // Print board for debugging
  static void printBoard() {
    print(
        'Score: $score | Moves: $moves | Matches: $matchesFound/$targetMatches');
    print('Selected: $selectedCellIndex');
    print('Board:');
    for (int row = 0; row < board.length ~/ rowLength; row++) {
      String rowStr = '';
      for (int col = 0; col < rowLength; col++) {
        int index = getIndex(row, col);
        if (index < board.length) {
          String cell = board[index]?.toString() ?? '_';
          if (highlightedCells.contains(index)) {
            cell = '[$cell]';
          }
          rowStr += '$cell ';
        }
      }
      print(rowStr);
    }
    print('');
  }
}

// Enhanced GameLogic class for compatibility with existing code
class GameLogic {
  // **Rule 5: Increased difficulty** - Generate more challenging rows
  static List<GameCell> generateNewRow(
      int startRow, int startId, GameLevel level) {
    final List<GameCell> newRow = [];
    final Random random = Random();

    // Increased difficulty: generate more cells per row
    final int maxCells = (level.maxCellsPerRow * 1.3).ceil(); // 30% more cells
    final int minCells =
        (level.minCellsPerRow * 1.2).ceil(); // 20% more minimum

    final int numCells = random.nextInt(maxCells - minCells + 1) + minCells;

    for (int i = 0; i < numCells; i++) {
      // Strategic number generation for increased difficulty
      int weight = random.nextInt(100);
      int value;
      if (weight < 35) {
        value = random.nextInt(4) + 4; // 4-7 (35% chance)
      } else if (weight < 65) {
        value = random.nextInt(3) + 1; // 1-3 (30% chance)
      } else {
        value = random.nextInt(2) + 8; // 8-9 (35% chance)
      }

      newRow.add(GameCell(
        id: startId + i,
        value: value,
        row: startRow,
        col: i,
      ));
    }
    return newRow;
  }

  // Convert GameCell list to NumberMasterLogic board and find pairs
  static List<List<GameCell>> findAllPossiblePairs(List<GameCell> cells) {
    // Convert GameCell list to board representation
    // Determine the rowLength from the existing cells for NumberMasterLogic initialization.
    // This assumes `cells` contains cells with valid `row` and `col` properties.
    int currentMaxCol = 0;
    if (cells.isNotEmpty) {
      currentMaxCol = cells.map((cell) => cell.col).reduce(max);
    }
    int tempRowLength = currentMaxCol + 1;

    _syncBoardWithNumberMasterLogic(cells, tempRowLength);
    var pairIndexes = NumberMasterLogic.findAllPairs();

    // Convert back to GameCell pairs
    List<List<GameCell>> result = [];
    // We need to map the NumberMasterLogic board indices back to the original GameCells
    // For this, we need a mapping from NumberMasterLogic board index to GameCell
    Map<int, GameCell> boardIndexToGameCell = {};
    for (var cell in cells) {
      if (cell.state != CellState.matched) {
        // Map using row/col positions to board indices
        int boardIndex = cell.row * tempRowLength + cell.col;
        boardIndexToGameCell[boardIndex] = cell;
      }
    }

    for (var pair in pairIndexes) {
      var index1 = pair[0];
      var index2 = pair[1];
      if (boardIndexToGameCell.containsKey(index1) &&
          boardIndexToGameCell.containsKey(index2)) {
        var cell1 = boardIndexToGameCell[index1]!;
        var cell2 = boardIndexToGameCell[index2]!;
        result.add([cell1, cell2]);
      }
    }

    return result;
  }

  // Check if there are any possible moves left
  static bool hasPossibleMoves(List<GameCell> cells) {
    // Determine the rowLength from the existing cells
    int currentMaxCol = 0;
    if (cells.isNotEmpty) {
      currentMaxCol = cells.map((cell) => cell.col).reduce(max);
    }
    int tempRowLength = currentMaxCol + 1;
    _syncBoardWithNumberMasterLogic(cells, tempRowLength);
    return NumberMasterLogic.findAllPairs().isNotEmpty;
  }

  // Helper to convert GameCell list to NumberMasterLogic board format
  static void _syncBoardWithNumberMasterLogic(List<GameCell> cells, int rowLength) {
    // Create a proper board representation based on row/col positions, not cell IDs
    int maxRow = 0;
    int maxCol = 0;
    
    // Find the maximum row and column values
    for (var cell in cells) {
      if (cell.state != CellState.matched) {
        if (cell.row > maxRow) maxRow = cell.row;
        if (cell.col > maxCol) maxCol = cell.col;
      }
    }
    
    // Create board with proper dimensions
    int totalCells = (maxRow + 1) * rowLength;
    List<int?> tempBoard = List<int?>.filled(totalCells, null);
    
    // Fill the board based on row/col positions
    for (var cell in cells) {
      if (cell.state != CellState.matched) {
        int index = cell.row * rowLength + cell.col;
        if (index < tempBoard.length) {
          tempBoard[index] = cell.value;
        }
      }
    }
    
    NumberMasterLogic.initializeBoard(tempBoard, rowLength);
  }

  // New method to handle cell selection using NumberMasterLogic
  static bool handleCellSelection(GameCell cell, List<GameCell> currentCells, int rowLength) {
    _syncBoardWithNumberMasterLogic(currentCells, rowLength);
    
    // Convert cell position to board index
    int boardIndex = cell.row * rowLength + cell.col;
    bool matched = NumberMasterLogic.selectCell(boardIndex);

    // After selection, update the currentCells list based on NumberMasterLogic.board
    // Rebuild the currentCells list to reflect changes in NumberMasterLogic.board
    if (matched || NumberMasterLogic.getSelectedCell() == null) { // If a match occurred or selection cleared
      _restoreGameCellsFromNumberMasterLogic(currentCells, rowLength);
    } else if (NumberMasterLogic.getSelectedCell() != null) {
      // Only update highlighted cells if a cell is selected
      for (int i = 0; i < currentCells.length; i++) {
        var gc = currentCells[i];
        CellState newState = CellState.active;
        int gcBoardIndex = gc.row * rowLength + gc.col;
        if (gcBoardIndex == NumberMasterLogic.getSelectedCell()) {
          newState = CellState.selected;
        } else if (NumberMasterLogic.getHighlightedCells().contains(gcBoardIndex)) {
          newState = CellState.selected; // Use selected for highlighted since there's no highlighted state
        }
        currentCells[i] = gc.copyWith(state: newState);
      }
    }
    return matched;
  }

  // Undo last move
  static bool undoMove(List<GameCell> currentCells, int rowLength) {
    _syncBoardWithNumberMasterLogic(currentCells, rowLength);
    bool success = NumberMasterLogic.undoMove();
    if (success) {
      // After undo, restore currentCells from NumberMasterLogic.board
      _restoreGameCellsFromNumberMasterLogic(currentCells, rowLength);
    }
    return success;
  }

  // Redo next move
  static bool redoMove(List<GameCell> currentCells, int rowLength) {
    _syncBoardWithNumberMasterLogic(currentCells, rowLength);
    bool success = NumberMasterLogic.redoMove();
    if (success) {
      // After redo, restore currentCells from NumberMasterLogic.board
      _restoreGameCellsFromNumberMasterLogic(currentCells, rowLength);
    }
    return success;
  }

  // Helper to restore GameCell list from NumberMasterLogic board format
  static void _restoreGameCellsFromNumberMasterLogic(List<GameCell> currentCells, int rowLength) {
    // Clear current cells and rebuild from NumberMasterLogic.board
    currentCells.clear();
    // Reconstruct GameCells with proper row/col based on rowLength
    int currentId = 0;
    for (int i = 0; i < NumberMasterLogic.board.length; i++) {
      if (NumberMasterLogic.board[i] != null) {
        currentCells.add(GameCell(
          id: currentId,
          value: NumberMasterLogic.board[i]!,
          row: NumberMasterLogic.getRow(i),
          col: NumberMasterLogic.getCol(i),
          state: CellState.active,
        ));
        currentId++;
      }
    }
  }

  // Check if undo is available
  static bool canUndo() => NumberMasterLogic.canUndo();

  // Check if redo is available
  static bool canRedo() => NumberMasterLogic.canRedo();

  // Get current score
  static int getScore() => NumberMasterLogic.getScore();

  // Get current moves
  static int getMoves() => NumberMasterLogic.getMoves();

  // Get matches found
  static int getMatchesFound() => NumberMasterLogic.getMatchesFound();

  // Get target matches
  static int getTargetMatches() => NumberMasterLogic.getTargetMatches();

  // Check if level is completed (enough matches found)
  static bool isLevelCompleted() => NumberMasterLogic.isLevelCompleted();

  // Reset selection state
  static void clearSelection() => NumberMasterLogic.clearSelection();

  // Get currently selected cell
  static int? getSelectedCell() => NumberMasterLogic.getSelectedCell();

  // Get highlighted cells
  static List<int> getHighlightedCells() => NumberMasterLogic.getHighlightedCells();

  // Helper method to check if two GameCell objects can form a valid pair
  static bool areCellsAMatch(GameCell cell1, GameCell cell2) {
    // Prevent a cell from matching with itself
    if (cell1.id == cell2.id) return false;
    if (cell1.row == cell2.row && cell1.col == cell2.col) return false;
    
    // Check if they can form a valid pair (equal or sum to 10)
    if (!(cell1.value == cell2.value || cell1.value + cell2.value == 10)) return false;
    
    // Convert to NumberMasterLogic board format to check adjacency/connection rules
    int maxRow = [cell1.row, cell2.row].reduce((a, b) => a > b ? a : b);
    int maxCol = [cell1.col, cell2.col].reduce((a, b) => a > b ? a : b);
    int rowLength = maxCol + 1;
    
    // Create a board with proper dimensions based on actual row/col positions
    int totalCells = (maxRow + 1) * rowLength;
    List<int?> tempBoard = List<int?>.filled(totalCells, null);
    
    // Place the cells in their correct positions
    int index1 = cell1.row * rowLength + cell1.col;
    int index2 = cell2.row * rowLength + cell2.col;
    
    // Ensure indices are within bounds
    if (index1 < tempBoard.length && index2 < tempBoard.length) {
      tempBoard[index1] = cell1.value;
      tempBoard[index2] = cell2.value;
      
      NumberMasterLogic.initializeBoard(tempBoard, rowLength);
      
      return NumberMasterLogic.isValidPair(index1, index2);
    }
    
    return false;
  }

  // **Rule 5: Enhanced difficulty** - Add more numbers when needed
  static List<GameCell> addRemainingNumbers(
      List<GameCell> cells, GameLevel level) {
    // Determine the rowLength from the existing cells
    int currentMaxCol = 0;
    if (cells.isNotEmpty) {
      currentMaxCol = cells.map((cell) => cell.col).reduce(max);
    }
    int tempRowLength = currentMaxCol + 1;

    // Convert to board representation
    _syncBoardWithNumberMasterLogic(cells, tempRowLength);

    // Add more numbers with increased difficulty
    NumberMasterLogic.addMoreNumbers();

    // Convert back to GameCells
    List<GameCell> newCells = [];
    int currentId = 0;

    // Reconstruct GameCells with proper row/col based on NumberMasterLogic.rowLength
    for (int i = 0; i < NumberMasterLogic.board.length; i++) {
      if (NumberMasterLogic.board[i] != null) {
        newCells.add(GameCell(
          id: currentId,
          value: NumberMasterLogic.board[i]!,
          row: NumberMasterLogic.getRow(i),
          col: NumberMasterLogic.getCol(i),
          state: CellState.active,
        ));
        currentId++;
      }
    }

    return newCells;
  }

  // Get a hint for the next possible move
  static List<GameCell>? getHint(List<GameCell> cells) {
    // Determine the rowLength from the existing cells
    int currentMaxCol = 0;
    if (cells.isNotEmpty) {
      currentMaxCol = cells.map((cell) => cell.col).reduce(max);
    }
    int tempRowLength = currentMaxCol + 1;

    _syncBoardWithNumberMasterLogic(cells, tempRowLength);
    var pairIndexes = NumberMasterLogic.getHint();

    if (pairIndexes != null && pairIndexes.isNotEmpty) {
      // Map the hint indices back to GameCells using row/col positions
      Map<int, GameCell> boardIndexToGameCell = {};
      for (var cell in cells) {
        if (cell.state != CellState.matched) {
          int boardIndex = cell.row * tempRowLength + cell.col;
          boardIndexToGameCell[boardIndex] = cell;
        }
      }
      var cell1 = boardIndexToGameCell[pairIndexes[0]]!;
      var cell2 = boardIndexToGameCell[pairIndexes[1]]!;
      return [cell1, cell2];
    }
    return null;
  }
}
