part of 'sura_cubit.dart';

@immutable
sealed class SuraState {}

final class SuraInitial extends SuraState {}

final class CreatePageController extends SuraState {}

final class ChangeViewState extends SuraState {}

final class SaveMarker extends SuraState {}

final class GetMarker extends SuraState {}

final class GetPage extends SuraState {}
