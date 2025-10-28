// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:number_master/Bloc/game_bloc.dart';

import 'package:number_master/Models/game_level.dart';

import 'package:number_master/widgets/game_grid_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<GameBloc>(context).add(GameInitialized());
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use a transparent scaffold to let the Stack's background show through

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 1. Background Image Layer

          Positioned.fill(
            child: Image.asset(
              'assets/Theme/a.png', // new background image path

              fit: BoxFit.cover,

              // Apply a dark tint for better foreground readability

              color: Colors.black.withOpacity(0.5),

              colorBlendMode: BlendMode.darken,
            ),
          ),

          // 2. Game Content Layer

          BlocConsumer<GameBloc, GameState>(
            listener: (context, state) {
              if (state.status == GameStatus.won) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Congratulations! You completed Level ${state.currentLevel}!'),
                    backgroundColor: Colors.green.shade800,
                  ),
                );
              } else if (state.status == GameStatus.lost) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Game Over!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.status == GameStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }

              final currentLevel = GameLevel.levels[state.currentLevel - 1];

              final matchesNeeded =
                  currentLevel.requiredMatches - state.matchesMade;

              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  child: Column(
                    children: [
                      Container(
                          padding: EdgeInsets.all(1),
                          height: 70,
                          width: 200,
                          child: Image.asset('assets/Theme/NM2.png')),
                      // Game Info and Score - Themed Card

                      Card(
                        elevation: 8,

                        color: Colors.black
                            .withOpacity(0.6), // Semi-transparent card

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.orange.shade800),
                        ),

                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.extension,
                                          size: 20, color: Colors.deepOrange),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Level ${state.currentLevel}',

                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white), // Themed text
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Targets: $matchesNeeded',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          size: 20, color: Colors.amber),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Score: ${state.score}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Matches: ${state.matchesMade}',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // The main game grid

                      Expanded(
                        child: GameGridWidget(
                          cells: state.cells,
                          invalidMatchIds: state.invalidMatchIds,
                          hintCellIds: state.hintCellIds,
                          onCellTap: (cellId) {
                            BlocProvider.of<GameBloc>(context)
                                .add(CellTapped(cellId));
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Control buttons for Add Row and Hint - Themed

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildGameButton(
                            icon: (Icons.add_box),
                            label:
                                'Add Row\n(${state.addedRowsCount}/${GameLevel.levels[state.currentLevel - 1].maxAdditionalRows})',
                            onPressed: state.status == GameStatus.playing &&
                                    state.addedRowsCount <
                                        GameLevel.levels[state.currentLevel - 1]
                                            .maxAdditionalRows
                                ? () => BlocProvider.of<GameBloc>(context)
                                    .add(AddRowRequested())
                                : null,
                          ),
                          _buildGameButton(
                            icon: Icons.lightbulb,
                            label: 'Hint',
                            onPressed: state.status == GameStatus.playing
                                ? () => BlocProvider.of<GameBloc>(context)
                                    .add(GetHintRequested())
                                : null,
                            isHintButton: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Reusable themed button widget for game controls

  Widget _buildGameButton({
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
    bool isHintButton = false,
  }) {
    return SizedBox(
      width: 150,
      height: 74,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: isHintButton
              ? Colors.amber.shade700.withOpacity(0.8)
              : Colors.deepOrange.shade600.withOpacity(0.8),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
                color: isHintButton ? Colors.yellowAccent : Colors.orange,
                width: 2),
          ),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.5),
        ),
      ),
    );
  }
}
