import 'package:flutter/material.dart';
import 'app_localizations.dart';

// Extension on BuildContext to easily access translations
extension LocalizationExtension on BuildContext {
  AppLocalizations get tr => AppLocalizations.of(this);
  
  // Check if the current locale is RTL
  bool get isRtl => AppLocalizations.of(this).isRtl;
  
  // Get the current locale
  Locale get currentLocale => AppLocalizations.of(this).currentLocale;
}
