import 'package:flutter/material.dart';
import 'label.dart';

class Event {
  final String title;
  final DateTime date;
  final Label? label;
  final String? comments;
  final bool isAllDay;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  Event({
    required this.title,
    required this.date,
    this.label,
    this.comments,
    this.isAllDay = false,
    this.startTime,
    this.endTime,
  });
}