import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:number_master/Models/game_cell.dart';
import 'package:number_master/Models/game_level.dart';
import 'package:number_master/utils/game_logic.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc() : super(GameState.initial()) {
    on<GameInitialized>(_onGameInitialized);
    on<CellTapped>(_onCellTapped);
    on<AddRowRequested>(_onAddRowRequested);
    on<GetHintRequested>(_onGetHintRequested);
  }

  void _onGameInitialized(GameInitialized event, Emitter<GameState> emit) {
    final initialCells = <GameCell>[];
    final currentLevel = GameLevel.levels[0];
    int startId = 0;
    for (int i = 0; i < currentLevel.initialRowCount; i++) {
      final newRow = GameLogic.generateNewRow(i, startId, currentLevel);
      initialCells.addAll(newRow);
      startId += newRow.length;
    }

    final initialState = state.copyWith(
      cells: initialCells,
      status: GameStatus.playing,
      currentLevel: 1,
      matchesMade: 0,
      selectedCells: [],
      score: 0,
    );
    
    emit(initialState);
  }

  Future<void> _onCellTapped(CellTapped event, Emitter<GameState> emit) async {
    if (state.status != GameStatus.playing) return;

    final tappedCell = state.cells.firstWhere((cell) => cell.id == event.id);

    // If the cell is already matched, do nothing.
    if (tappedCell.state == CellState.matched) return;

    final newSelectedCells = List<GameCell>.from(state.selectedCells);
    final newCells = List<GameCell>.from(state.cells);

    // Check if the cell is being deselected
    bool isDeselecting = false;
    if (newSelectedCells.contains(tappedCell)) {
      newSelectedCells.remove(tappedCell);
      newCells[newCells.indexWhere((cell) => cell.id == event.id)] =
          tappedCell.copyWith(state: CellState.active);
      isDeselecting = true;
    } else {
      // Select the cell
      if (newSelectedCells.length < 2) {
        newSelectedCells.add(tappedCell);
        newCells[newCells.indexWhere((cell) => cell.id == event.id)] =
            tappedCell.copyWith(state: CellState.selected);
      }
    }

    emit(state.copyWith(cells: newCells, selectedCells: newSelectedCells, invalidMatchIds: const []));

    // Check for a match if two cells are selected and not a deselecting action
    if (newSelectedCells.length == 2 && !isDeselecting) {
      final cell1 = newSelectedCells[0];
      final cell2 = newSelectedCells[1];

      if (GameLogic.areCellsAMatch(cell1, cell2)) {
        // Handle a valid match
        final updatedCells = state.cells.map((cell) {
          if (cell.id == cell1.id || cell.id == cell2.id) {
            return cell.copyWith(state: CellState.matched);
          }
          return cell;
        }).toList();

        final newMatches = state.matchesMade + 1;
        final newScore = state.score + 10; // Base score for each match

        emit(state.copyWith(
          cells: updatedCells,
          selectedCells: [],
          matchesMade: newMatches,
          score: newScore,
        ));

        // Check if there are any remaining unmatched cells
        final unmatchedCells = updatedCells.where((cell) => cell.state != CellState.matched).toList();
        
        // If all cells are matched, add bonus points for clearing the field
        if (unmatchedCells.isEmpty) {
          final bonusScore = newScore + 100; // Bonus for clearing the field
          emit(state.copyWith(score: bonusScore));
        } else {
          // Check if there are any more possible moves
          if (!GameLogic.hasPossibleMoves(updatedCells)) {
            // Automatically add remaining numbers as new rows
            final currentLevel = GameLevel.levels[state.currentLevel - 1];
            final newCells = GameLogic.addRemainingNumbers(updatedCells, currentLevel);
            final bonusScore = newScore + 50; // Bonus for completing a cycle
            
            emit(state.copyWith(
              cells: newCells,
              score: bonusScore,
            ));
          }
        }

        // Check for win condition for the current level
        final currentLevel = GameLevel.levels[state.currentLevel - 1];
        if (newMatches >= currentLevel.requiredMatches) {
          if (state.currentLevel < GameLevel.levels.length) {
            final nextLevel = GameLevel.levels[state.currentLevel];
            // Move to the next level
            final nextLevelCells = <GameCell>[];
            int nextStartId = 0;
            for (int i = 0; i < nextLevel.initialRowCount; i++) {
              final newRow =
                  GameLogic.generateNewRow(i, nextStartId, nextLevel);
              nextLevelCells.addAll(newRow);
              nextStartId += newRow.length;
            }

            final nextLevelState = state.copyWith(
              status: GameStatus.playing,
              currentLevel: nextLevel.levelNumber,
              matchesMade: 0,
              cells: nextLevelCells,
              selectedCells: [],
              addedRowsCount: 0,
            );
            emit(nextLevelState);
          } else {
            // Game is won
            emit(state.copyWith(status: GameStatus.won));
          }
        }
      } else {
        // Handle invalid match with UI feedback
        final invalidIds = [cell1.id, cell2.id];
        emit(state.copyWith(
          invalidMatchIds: invalidIds,
          status: GameStatus.playing,
        ));
        // Reset selections after a short delay for visual feedback.
        await Future.delayed(const Duration(milliseconds: 450));

        final updatedCells = state.cells.map((cell) {
          if (cell.id == cell1.id || cell.id == cell2.id) {
            return cell.copyWith(state: CellState.active);
          }
          return cell;
        }).toList();

        if (!emit.isDone) {
          emit(state.copyWith(
            cells: updatedCells,
            selectedCells: [],
            invalidMatchIds: const [],
          ));
        }
      }
    }
  }

  void _onAddRowRequested(AddRowRequested event, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;

    final currentLevelConfig = GameLevel.levels[state.currentLevel - 1];
    if (state.addedRowsCount >= currentLevelConfig.maxAdditionalRows) {
      return; // limit reached
    }

    final newCells = List<GameCell>.from(state.cells);
    final lastRow = newCells.isEmpty ? -1 : newCells.last.row;
    final lastId = newCells.isEmpty ? -1 : newCells.last.id;
    final currentLevel = GameLevel.levels[state.currentLevel - 1];

    final newRow =
        GameLogic.generateNewRow(lastRow + 1, lastId + 1, currentLevel);
    newCells.addAll(newRow);

    emit(state.copyWith(
      cells: newCells,
      addedRowsCount: state.addedRowsCount + 1,
    ));
  }

  void _onGetHintRequested(GetHintRequested event, Emitter<GameState> emit) {
    if (state.status != GameStatus.playing) return;

    final hint = GameLogic.getHint(state.cells);
    if (hint != null) {
      final hintIds = hint.map((cell) => cell.id).toList();
      emit(state.copyWith(hintCellIds: hintIds));
      
      // Clear hint after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (!emit.isDone) {
          emit(state.copyWith(hintCellIds: const []));
        }
      });
    }
  }
}
