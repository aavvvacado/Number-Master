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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Master'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          if (state.status == GameStatus.won) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Congratulations! You completed Level ${state.currentLevel}!'),
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
                                  const Icon(Icons.extension, size: 20, color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Level ${state.currentLevel}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w600),
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
                                  const Icon(Icons.star, size: 20, color: Colors.amber),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Score: ${state.score}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber),
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
                          onPressed: state.status == GameStatus.playing
                              && state.addedRowsCount < GameLevel.levels[state.currentLevel - 1].maxAdditionalRows
                              ? () => BlocProvider.of<GameBloc>(context)
                                  .add(AddRowRequested())
                              : null,
                          icon: const Icon(Icons.add_box),
                          label: Text('Add Row\n(${state.addedRowsCount}/${GameLevel.levels[state.currentLevel - 1].maxAdditionalRows})'),
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
          );
        },
      ),
    );
  }
}
