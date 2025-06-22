part of 'dua_dhikr_bloc.dart';

@immutable
sealed class DuaDhikrState {
  const DuaDhikrState();

  List<Object> get props => [];
}

final class DuaDhikrInitial extends DuaDhikrState {
  const DuaDhikrInitial();
}

final class DataLoading extends DuaDhikrState {
  const DataLoading();
}

final class DuaCategoriesLoaded extends DuaDhikrState {
  final List<String> categories;
  const DuaCategoriesLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

final class DuasByCategoryLoaded extends DuaDhikrState {
  final List<Dua> duas;
  const DuasByCategoryLoaded(this.duas);

  @override
  List<Object> get props => [duas];
}

final class FavoriteDuasLoaded extends DuaDhikrState {
  final List<Dua> duas;
  const FavoriteDuasLoaded(this.duas);

  @override
  List<Object> get props => [duas];
}

final class DuaFavoriteToggled extends DuaDhikrState {
  final Dua updatedDua;
  const DuaFavoriteToggled(this.updatedDua);

  @override
  List<Object> get props => [updatedDua];
}

final class DhikrsLoaded extends DuaDhikrState {
  final List<Dhikr> dhikrs;
  const DhikrsLoaded(this.dhikrs);

  @override
  List<Object> get props => [dhikrs];
}

final class FavoriteDhikrsLoaded extends DuaDhikrState {
  final List<Dhikr> dhikrs;
  const FavoriteDhikrsLoaded(this.dhikrs);

  @override
  List<Object> get props => [dhikrs];
}

final class DhikrFavoriteToggled extends DuaDhikrState {
  final Dhikr updatedDhikr;
  const DhikrFavoriteToggled(this.updatedDhikr);

  @override
  List<Object> get props => [updatedDhikr];
}

final class DataRefreshed extends DuaDhikrState {
  const DataRefreshed();
}

final class OperationFailed extends DuaDhikrState {
  final String message;
  const OperationFailed(this.message);

  @override
  List<Object> get props => [message];
}

class InitialDataLoaded extends DuaDhikrState {
  final List<String> categories;
  final List<Dhikr> dhikrs;

  const InitialDataLoaded({required this.categories, required this.dhikrs});

  @override
  List<Object> get props => [categories, dhikrs];
}
