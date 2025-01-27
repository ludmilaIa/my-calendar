import 'package:flutter/material.dart';

class Event {
  final String title;
  final DateTime date;
  final String? comments;
  final bool isAllDay;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  Event({
    required this.title,
    required this.date,
    this.comments,
    this.isAllDay = false,
    this.startTime,
    this.endTime,
  });
}
