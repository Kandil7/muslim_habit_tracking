import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/quotes_repository.dart';
import '../models/motivational_quote.dart';
import '../utils/services/notification_service.dart';

/// Enhanced notification service that includes motivational quotes and Islamic teachings
class EnhancedNotificationService {
  final NotificationService _notificationService;
  final QuotesRepository _quotesRepository;

  /// Creates a new EnhancedNotificationService
  EnhancedNotificationService({
    required NotificationService notificationService,
    required QuotesRepository quotesRepository,
  }) : _notificationService = notificationService,
       _quotesRepository = quotesRepository;

  /// Show an immediate notification with a motivational quote
  Future<void> showMotivationalNotification({
    required int id,
    required String title,
    required String body,
    String? tag,
    String? payload,
  }) async {
    // Get a motivational quote based on the tag
    final MotivationalQuote quote =
        tag != null
            ? _quotesRepository.getRandomQuoteByTag(tag) ??
                _quotesRepository.getRandomQuote()
            : _quotesRepository.getRandomQuote();

    // Enhance the notification body with the quote
    final enhancedBody =
        '$body\n\n"${quote.text}"\n— ${quote.source} (${quote.reference})';

    // Show the notification with the enhanced body
    await _notificationService.showNotification(
      id: id,
      title: title,
      body: enhancedBody,
      payload: payload,
    );
  }

  /// Schedule a notification with a motivational quote
  Future<void> scheduleMotivationalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? tag,
    String? payload,
    bool repeats = false,
    RepeatInterval? repeatInterval,
  }) async {
    // Get a motivational quote based on the tag
    final MotivationalQuote quote =
        tag != null
            ? _quotesRepository.getRandomQuoteByTag(tag) ??
                _quotesRepository.getRandomQuote()
            : _quotesRepository.getRandomQuote();

    // Enhance the notification body with the quote
    final enhancedBody =
        '$body\n\n"${quote.text}"\n— ${quote.source} (${quote.reference})';

    // Schedule the notification with the enhanced body
    await _notificationService.scheduleNotification(
      id: id,
      title: title,
      body: enhancedBody,
      scheduledDate: scheduledDate,
      payload: payload,
      repeats: repeats,
      repeatInterval: repeatInterval,
    );
  }

  /// Schedule a daily notification with a motivational quote
  Future<void> scheduleMotivationalDailyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay timeOfDay,
    String? tag,
    String? payload,
  }) async {
    // Get a motivational quote based on the tag
    final MotivationalQuote quote =
        tag != null
            ? _quotesRepository.getRandomQuoteByTag(tag) ??
                _quotesRepository.getRandomQuote()
            : _quotesRepository.getRandomQuote();

    // Enhance the notification body with the quote
    final enhancedBody =
        '$body\n\n"${quote.text}"\n— ${quote.source} (${quote.reference})';

    // Schedule the daily notification with the enhanced body
    await _notificationService.scheduleDailyNotification(
      id: id,
      title: title,
      body: enhancedBody,
      timeOfDay: timeOfDay,
      payload: payload,
    );
  }

  /// Schedule a prayer notification with a relevant Islamic teaching
  Future<void> scheduleEnhancedPrayerNotification({
    required int id,
    required String prayerName,
    required DateTime prayerTime,
    int minutesBefore = 15,
  }) async {
    // Get a prayer-related quote
    final MotivationalQuote quote =
        _quotesRepository.getRandomQuoteByTag('prayer') ??
        _quotesRepository.getRandomQuote();

    final notificationTime = prayerTime.subtract(
      Duration(minutes: minutesBefore),
    );

    // Only schedule if the prayer time is in the future
    if (notificationTime.isAfter(DateTime.now())) {
      // Create an enhanced notification body with the quote
      final enhancedBody =
          '$prayerName prayer time in $minutesBefore minutes\n\n"${quote.text}"\n— ${quote.source} (${quote.reference})';

      await _notificationService.scheduleNotification(
        id: id,
        title: 'Prayer Time Reminder',
        body: enhancedBody,
        scheduledDate: notificationTime,
        payload: 'prayer_$prayerName',
      );
    }
  }

  /// Schedule a habit reminder with a motivational quote
  Future<void> scheduleEnhancedHabitReminder({
    required int id,
    required String habitName,
    required TimeOfDay reminderTime,
    required String habitType,
  }) async {
    // Get a habit-specific quote
    final MotivationalQuote quote = _quotesRepository.getQuoteForHabit(
      habitType,
    );

    // Create an enhanced notification body with the quote
    final enhancedBody =
        'Time to complete your habit: $habitName\n\n"${quote.text}"\n— ${quote.source} (${quote.reference})';

    await _notificationService.scheduleDailyNotification(
      id: id,
      title: 'Habit Reminder',
      body: enhancedBody,
      timeOfDay: reminderTime,
      payload: 'habit_$id',
    );
  }
}
