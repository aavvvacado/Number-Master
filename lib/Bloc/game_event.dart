part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object?> get props => [];
}

class GameInitialized extends GameEvent {}

class CellTapped extends GameEvent {
  final int id;
  const CellTapped(this.id);

  @override
  List<Object?> get props => [id];
}

class AddRowRequested extends GameEvent {}

class GetHintRequested extends GameEvent {}