part of 'dua_dhikr_bloc.dart';

@immutable
sealed class DuaDhikrEvent {
  const DuaDhikrEvent();
}

final class LoadInitialData extends DuaDhikrEvent {
  const LoadInitialData();
}

final class LoadDuaCategories extends DuaDhikrEvent {
  const LoadDuaCategories();
}

final class LoadDuasByCategory extends DuaDhikrEvent {
  final String category;
  const LoadDuasByCategory(this.category);
}

final class LoadAllDhikrs extends DuaDhikrEvent {
  const LoadAllDhikrs();
}

final class LoadFavoriteDuas extends DuaDhikrEvent {
  const LoadFavoriteDuas();
}

final class LoadFavoriteDhikrs extends DuaDhikrEvent {
  const LoadFavoriteDhikrs();
}

final class ToggleDuaFavoriteStatus extends DuaDhikrEvent {
  final String duaId;
  const ToggleDuaFavoriteStatus(this.duaId);
}

final class ToggleDhikrFavoriteStatus extends DuaDhikrEvent {
  final String dhikrId;
  const ToggleDhikrFavoriteStatus(this.dhikrId);
}

final class RefreshData extends DuaDhikrEvent {
  const RefreshData();
}

final class ResetState extends DuaDhikrEvent {
  const ResetState();
}
