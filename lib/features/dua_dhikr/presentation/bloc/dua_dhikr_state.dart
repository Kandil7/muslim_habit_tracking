import 'package:equatable/equatable.dart';

import '../../domain/entities/dua.dart';
import '../../domain/entities/dhikr.dart';

/// States for the dua & dhikr feature
abstract class DuaDhikrState extends Equatable {
  const DuaDhikrState();
  
  @override
  List<Object?> get props => [];
}

/// Initial state
class DuaDhikrInitial extends DuaDhikrState {}

/// Loading state
class DuaDhikrLoading extends DuaDhikrState {}

/// State when duas are loaded
class DuasLoaded extends DuaDhikrState {
  final List<Dua> duas;
  
  const DuasLoaded({required this.duas});
  
  @override
  List<Object?> get props => [duas];
}

/// State when dhikrs are loaded
class DhikrsLoaded extends DuaDhikrState {
  final List<Dhikr> dhikrs;
  
  const DhikrsLoaded({required this.dhikrs});
  
  @override
  List<Object?> get props => [dhikrs];
}

/// State when dua categories are loaded
class DuaCategoriesLoaded extends DuaDhikrState {
  final List<String> categories;
  
  const DuaCategoriesLoaded({required this.categories});
  
  @override
  List<Object?> get props => [categories];
}

/// State when a dua's favorite status is toggled
class DuaFavoriteToggled extends DuaDhikrState {
  final Dua dua;
  
  const DuaFavoriteToggled({required this.dua});
  
  @override
  List<Object?> get props => [dua];
}

/// State when a dhikr's favorite status is toggled
class DhikrFavoriteToggled extends DuaDhikrState {
  final Dhikr dhikr;
  
  const DhikrFavoriteToggled({required this.dhikr});
  
  @override
  List<Object?> get props => [dhikr];
}

/// Error state
class DuaDhikrError extends DuaDhikrState {
  final String message;
  
  const DuaDhikrError({required this.message});
  
  @override
  List<Object?> get props => [message];
}
