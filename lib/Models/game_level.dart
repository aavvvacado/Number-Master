class GameLevel {
  final int levelNumber;
  final String title;
  final String description;
  final int requiredMatches;
  final int initialRowCount;
  final int minCellsPerRow;
  final int maxCellsPerRow;
  final int maxAdditionalRows;

  const GameLevel({
    required this.levelNumber,
    required this.title,
    required this.description,
    required this.requiredMatches,
    this.initialRowCount = 3,
    this.minCellsPerRow = 4,
    this.maxCellsPerRow = 6,
    this.maxAdditionalRows = 3,
  });

  static const List<GameLevel> levels = [
    GameLevel(
      levelNumber: 1,
      title: 'Level 1: The Basics',
      description: 'Match 10 pairs of cells to win.',
      requiredMatches: 10,
      initialRowCount: 3,
      minCellsPerRow: 4,
      maxCellsPerRow: 6,
      maxAdditionalRows: 3,
    ),
    GameLevel(
      levelNumber: 2,
      title: 'Level 2: Sum Challenge',
      description: 'Match 15 pairs (equal or sum to 10).',
      requiredMatches: 15,
      initialRowCount: 4,
      minCellsPerRow: 6,
      maxCellsPerRow: 8,
      maxAdditionalRows: 3,
    ),
    GameLevel(
      levelNumber: 3,
      title: 'Level 3: The Grand Finale',
      description: 'Match 25 pairs to become a master!',
      requiredMatches: 25,
      initialRowCount: 5,
      minCellsPerRow: 8,
      maxCellsPerRow: 10,
      maxAdditionalRows: 2,
    ),
  ];
}
