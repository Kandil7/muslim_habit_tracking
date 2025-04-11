import 'package:equatable/equatable.dart';

/// Events for the dua & dhikr feature
abstract class DuaDhikrEvent extends Equatable {
  const DuaDhikrEvent();
  
  @override
  List<Object?> get props => [];
}

/// Event to get all duas
class GetAllDuasEvent extends DuaDhikrEvent {}

/// Event to get duas by category
class GetDuasByCategoryEvent extends DuaDhikrEvent {
  final String category;
  
  const GetDuasByCategoryEvent({required this.category});
  
  @override
  List<Object?> get props => [category];
}

/// Event to get favorite duas
class GetFavoriteDuasEvent extends DuaDhikrEvent {}

/// Event to toggle dua favorite status
class ToggleDuaFavoriteEvent extends DuaDhikrEvent {
  final String id;
  
  const ToggleDuaFavoriteEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}

/// Event to get all dhikrs
class GetAllDhikrsEvent extends DuaDhikrEvent {}

/// Event to get favorite dhikrs
class GetFavoriteDhikrsEvent extends DuaDhikrEvent {}

/// Event to toggle dhikr favorite status
class ToggleDhikrFavoriteEvent extends DuaDhikrEvent {
  final String id;
  
  const ToggleDhikrFavoriteEvent({required this.id});
  
  @override
  List<Object?> get props => [id];
}

/// Event to get dua categories
class GetDuaCategoriesEvent extends DuaDhikrEvent {}
