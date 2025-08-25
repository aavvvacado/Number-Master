# Number Master - Flutter Game

A challenging number-matching puzzle game built with Flutter, featuring advanced game mechanics, state management, and enhanced difficulty scaling.

## 🎮 Game Overview

Number Master is a strategic puzzle game where players match numbers that are either equal or sum to 10. The game features progressive difficulty, undo/redo functionality, and intelligent hint systems.

### Video


https://github.com/user-attachments/assets/e668671d-a5cd-413e-8e82-1ae5d9a4e77c









## 🏗️ Architecture & Design Patterns

### State Management
- **BLoC Pattern**: Implemented using `flutter_bloc` for reactive state management
- **Event-Driven Architecture**: Clean separation between UI events and business logic
- **Immutable State**: Game state is immutable, ensuring predictable state transitions

### Core Components
- **GameLogic**: Main game logic class handling all game mechanics
- **NumberMasterLogic**: Enhanced logic engine with advanced features
- **GameCell**: Immutable cell representation with Equatable for efficient comparisons
- **GameLevel**: Configurable level system with progressive difficulty

## 🧠 Game Logic Features

### 1. Self-Matching Prevention ✅
**Implementation**: Enhanced cell selection system with proper validation
```dart
// Prevents selecting the same cell twice
if (selectedCellIndex == index) {
  selectedCellIndex = null;
  highlightedCells.clear();
  return false;
}
```

**Key Features**:
- Tracks `selectedCellIndex` to prevent same cell selection
- Enhanced `selectCell()` method with proper validation
- Multiple checks in `areCellsAMatch()` and `isValidPair()` to prevent self-matching
- Cell deselection when tapped twice


**Key Features**:
- `GameState` class for comprehensive state management
- `gameHistory` list with configurable size (50 states by default)

### 3. Enhanced Game Mechanics ✅
**Implementation**: Strategic number placement and matching algorithms
```dart
// Target-based level completion
static bool isLevelCompleted() {
  return matchesFound >= targetMatches;
}
```

**Key Features**:
- Better selection highlighting system
- Move counter and match tracking
- Target-based level completion system
- Strategic number placement algorithms
- Enhanced scoring with higher bonuses

### 4. Increased Difficulty Scaling ✅
**Implementation**: Dynamic difficulty adjustment based on level progression
```dart
// More targets required: Dynamic target calculation (60% of board)
targetMatches = (nonNullCells * 0.6).ceil();

// Larger grids: Enhanced generateRandomBoard() with 80% fill rate
int filledCells = (totalCells * 0.8).ceil();
```

**Key Features**:
- **More targets required**: Dynamic target calculation (60% of board)
- **Larger grids**: Enhanced `generateRandomBoard()` with 80% fill rate
- **More cells per row**: 30% increase in `generateNewRow()`
- **Strategic number distribution**: Weighted generation favoring challenging combinations
- **Additional numbers**: 30% more numbers added when reshuffling

### 5. Advanced Matching Rules ✅
**Implementation**: Complex adjacency and connection validation
```dart
// Check if two indexes can connect diagonally through empty cells
static bool canConnectDiagonally(int i, int j) {
  // Diagonal connection logic with path validation
}

// Check if two indexes can wrap from end of row to start of next row
static bool canWrap(int i, int j) {
  // Row wrapping logic
}
```

**Key Features**:
- **Horizontal adjacency**: Cells in same row, adjacent columns
- **Vertical adjacency**: Cells in same column, adjacent rows
- **Diagonal adjacency**: Cells diagonally adjacent
- **Diagonal connections**: Through empty cells with path validation
- **Row wrapping**: From end of row to start of next row

## 🔧 Technical Implementation

### Board Representation
- **Flexible Grid System**: Configurable row length with dynamic sizing
- **Index Mapping**: Efficient conversion between row/col and linear indices
- **State Persistence**: Complete board state saved for undo/redo operations

### Cell Selection System
```dart
static bool selectCell(int index) {
  // Enhanced selection with self-match prevention
  // Proper state management and validation
}
```

### Pair Validation
```dart
static bool isValidPair(int i, int j) {
  // Comprehensive validation including:
  // - Value matching (equal or sum to 10)
  // - Adjacency rules
  // - Connection validation
  // - Self-matching prevention
}
```

### Hint System
```dart
static List<int>? getHint() {
  // Finds all possible valid pairs
  // Returns first available match
  // Integrates with NumberMasterLogic
}
```

## 📊 Game Statistics & Tracking

### Score System
- **Base Score**: 10 points per successful match
- **Clear Bonus**: 200 points for complete board clear
- **Level Completion**: 100 points for reaching target matches
- **Cycle Bonus**: 50 points for completing a cycle

### Progress Tracking
- **Move Counter**: Tracks total moves made
- **Match Counter**: Tracks successful matches
- **Target System**: Dynamic target calculation based on board size
- **Level Progression**: Automatic level advancement

## 🎯 Level System

### Dynamic Difficulty
- **Progressive Complexity**: Each level increases in difficulty
- **Adaptive Targets**: Target matches calculated as 60% of board cells
- **Strategic Placement**: Numbers placed to create challenging combinations
- **Enhanced Grids**: Larger grids with more cells per row

### Level Configuration
```dart
class GameLevel {
  final int levelNumber;
  final int initialRowCount;
  final int minCellsPerRow;
  final int maxCellsPerRow;
  final int requiredMatches;
}
```

## 🔄 State Management Integration

### BLoC Integration
- **Event Handling**: `CellTapped`, `UndoRequested`, `RedoRequested`
- **State Updates**: Reactive UI updates based on game state changes
- **Error Handling**: Proper error states and user feedback

### Game State Synchronization
```dart
// Synchronizes GameCell list with NumberMasterLogic board
static void _syncBoardWithNumberMasterLogic(List<GameCell> cells, int rowLength) {
  // Converts GameCell list to board representation
  // Maintains consistency between UI and logic layers
}
```

## 🛠️ Development Features

### Debugging Tools
```dart
static void printBoard() {
  // Comprehensive board visualization
  // Shows selection state, score, moves, and progress
  // Enhanced debugging with visual indicators
}
```

### Error Handling
- **Bounds Checking**: All array accesses validated
- **Null Safety**: Comprehensive null checking throughout
- **State Validation**: Ensures consistent state across operations

## 📱 User Interface Features

### Visual Feedback
- **Selection Highlighting**: Clear visual indication of selected cells
- **Match Animation**: Visual feedback for successful matches
- **Invalid Match Feedback**: Temporary highlighting for invalid selections
- **Progress Indicators**: Real-time progress tracking

### Accessibility
- **Responsive Design**: Adapts to different screen sizes
- **Touch Optimization**: Optimized for touch interactions
- **Visual Clarity**: Clear visual hierarchy and contrast

## 🔮 Future Enhancements

### Planned Features
- **Sound Effects**: Audio feedback for game actions
- **Achievement System**: Unlockable achievements and milestones
- **Custom Themes**: Multiple visual themes
- **Statistics Tracking**: Detailed game statistics and analytics
- **Multiplayer Support**: Competitive multiplayer modes

### Technical Improvements
- **Performance Optimization**: Further optimization for large grids
- **Animation System**: Smooth animations for all interactions
- **Localization**: Multi-language support
- **Cloud Sync**: Game progress synchronization

## 🎥 Demo Video

*[Video demonstration will be added here]*

## 📋 Assignment Submission Details

### Implementation Highlights
1. **Advanced Game Logic**: Complex matching rules with multiple adjacency types
2. **State Management**: Robust undo/redo system with configurable history
3. **Difficulty Scaling**: Dynamic difficulty adjustment based on level progression
4. **Error Prevention**: Comprehensive validation and bounds checking
5. **Performance Optimization**: Efficient algorithms for large grid operations

### Technical Achievements
- **Clean Architecture**: Separation of concerns with BLoC pattern
- **Immutable Design**: Predictable state management with immutable objects
- **Scalable Logic**: Modular design allowing easy feature additions
- **Comprehensive Testing**: Thorough validation of all game mechanics

### Learning Outcomes
- **Flutter Development**: Advanced Flutter concepts and best practices
- **State Management**: Complex state management with BLoC pattern
- **Algorithm Design**: Efficient algorithms for game logic
- **Error Handling**: Comprehensive error prevention and handling
- **User Experience**: Focus on smooth and intuitive gameplay

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

### Building
- **Debug**: `flutter run`
- **Release**: `flutter build apk` or `flutter build ios`

## 📄 License

This project is developed as an academic assignment submission.

---

**Developed with ❤️ using Flutter and Dart**
