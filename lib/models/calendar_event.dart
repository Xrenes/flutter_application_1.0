import 'package:flutter/material.dart';

enum EventType { quiz, assignment, presentation, midExam, finalExam }

class CalendarEvent {
  final String id;
  final DateTime date;
  final EventType type;
  final String notes;
  final DateTime createdAt;

  CalendarEvent({
    required this.id,
    required this.date,
    required this.type,
    required this.notes,
    required this.createdAt,
  });

  Color get color {
    switch (type) {
      case EventType.quiz:
        return Colors.red;
      case EventType.assignment:
        return Colors.blue;
      case EventType.presentation:
        return Colors.green;
      case EventType.midExam:
        return Colors.orange;
      case EventType.finalExam:
        return Colors.purple;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type.name,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'],
      date: DateTime.parse(json['date']),
      type: EventType.values.firstWhere((e) => e.name == json['type']),
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
