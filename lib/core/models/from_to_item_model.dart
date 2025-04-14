import 'package:flutter/material.dart';

class FromToItemModel {
  final Color backgroundColor;
  final String title;
  final String? subtitle;
  final String startTime, endTime;

  FromToItemModel(
      {required this.backgroundColor,
      required this.title,
      this.subtitle,
      required this.startTime,
      required this.endTime});
}
