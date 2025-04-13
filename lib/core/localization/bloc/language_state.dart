import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Represents the state of the language settings
class LanguageState extends Equatable {
  final Locale locale;

  const LanguageState({required this.locale});

  /// Initial state with English locale
  factory LanguageState.initial() => const LanguageState(locale: Locale('en'));

  /// Create a copy of this state with given parameters
  LanguageState copyWith({Locale? locale}) {
    return LanguageState(
      locale: locale ?? this.locale,
    );
  }

  /// Check if the current locale is RTL
  bool get isRtl => locale.languageCode == 'ar';

  @override
  List<Object> get props => [locale];
}
