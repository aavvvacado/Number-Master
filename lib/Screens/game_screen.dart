import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:number_master/Bloc/game_bloc.dart';
import 'package:number_master/Models/game_level.dart';
import 'package:number_master/widgets/game_grid_widget.dart';
import 'package:confetti/confetti.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<GameBloc>(context).add(GameInitialized());
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Master'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listenWhen: (previous, current) {
          return (previous.currentLevel < current.currentLevel &&
                  current.status != GameStatus.won) ||
              (previous.status != GameStatus.won &&
                  current.status == GameStatus.won) ||
              (previous.status != GameStatus.lost &&
                  current.status == GameStatus.lost);
        },
        listener: (context, state) {
          if (state.status == GameStatus.won) {
            _confettiController.play();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Congratulations! You beat the whole game! Score: ${state.score}'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == GameStatus.lost) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Game Over!'),
                backgroundColor: Colors.red,
              ),
            );
          } else {
            _confettiController.play();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Congratulations! You completed Level ${state.currentLevel - 1}!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        // listenWhen: (previous, current) {
        //   return previous.status != current.status ||
        //       previous.currentLevel < current.currentLevel;
        // },
        // listener: (context, state) {
        //   if (state.previousState.currentLevel < state.currentLevel) {
        //     _confettiController.play(); // Play confetti!
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text(
        //             'Congratulations! You completed Level ${state.previousState.currentLevel}!'),
        //         backgroundColor: Colors.green,
        //       ),
        //     );
        //   } else if (state.status == GameStatus.won) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(
        //         content: Text(
        //             'Congratulations! You completed Level ${state.currentLevel}!'),
        //         backgroundColor: Colors.green,
        //       ),
        //     );
        //   } else if (state.status == GameStatus.lost) {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       const SnackBar(
        //         content: Text('Game Over!'),
        //         backgroundColor: Colors.red,
        //       ),
        //     );
        //   }
        // },
        builder: (context, state) {
          if (state.status == GameStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          final currentLevel = GameLevel.levels[state.currentLevel - 1];
          final matchesNeeded =
              currentLevel.requiredMatches - state.matchesMade;

          return Stack(alignment: Alignment.topCenter, children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Game Info and Score
                    Card(
                      elevation: 4,
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
                                        size: 20, color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Level ${state.currentLevel}',
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Targets: $matchesNeeded',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.amber),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Matches: ${state.matchesMade}',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700]),
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
                    // Control buttons for Add Row and Hint
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: 150,
                          child: ElevatedButton.icon(
                            onPressed: state.status == GameStatus.playing &&
                                    state.addedRowsCount <
                                        GameLevel.levels[state.currentLevel - 1]
                                            .maxAdditionalRows
                                ? () => BlocProvider.of<GameBloc>(context)
                                    .add(AddRowRequested())
                                : null,
                            icon: const Icon(Icons.add_box),
                            label: Text(
                                'Add Row\n(${state.addedRowsCount}/${GameLevel.levels[state.currentLevel - 1].maxAdditionalRows})'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: ElevatedButton.icon(
                            onPressed: state.status == GameStatus.playing
                                ? () => BlocProvider.of<GameBloc>(context)
                                    .add(GetHintRequested())
                                : null,
                            icon: const Icon(Icons.lightbulb),
                            label: const Text('Hint'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.amber.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple
              ],
            ),
          ]);
        },
      ),
    );
  }
}
