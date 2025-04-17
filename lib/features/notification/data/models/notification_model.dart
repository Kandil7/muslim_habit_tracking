import 'package:timezone/timezone.dart';

class NotificationModel {
  final int? id;
  final String title, body;
  final DateTime? date;
  final TZDateTime? scheduledDate;

  NotificationModel(
      {this.id,
      required this.title,
      required this.body,
      this.date,
      this.scheduledDate});
}
