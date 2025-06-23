import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/calendar_event.dart';

class CalendarProvider extends ChangeNotifier {
  List<CalendarEvent> _events = [];
  List<CalendarEvent> get events => _events;

  CalendarProvider() {
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = prefs.getStringList('calendar_events') ?? [];

    _events = eventsJson
        .map((json) => CalendarEvent.fromJson(jsonDecode(json)))
        .toList();

    notifyListeners();
  }

  Future<void> _saveEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = _events
        .map((event) => jsonEncode(event.toJson()))
        .toList();

    await prefs.setStringList('calendar_events', eventsJson);
  }

  List<CalendarEvent> getEventsForDay(DateTime day) {
    return _events
        .where(
          (event) =>
              event.date.year == day.year &&
              event.date.month == day.month &&
              event.date.day == day.day,
        )
        .toList();
  }

  Future<void> addEvent(DateTime date, EventType type, String notes) async {
    final event = CalendarEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: date,
      type: type,
      notes: notes,
      createdAt: DateTime.now(),
    );

    _events.add(event);
    await _saveEvents();
    notifyListeners();
  }

  Future<void> updateEvent(String eventId, String notes) async {
    final index = _events.indexWhere((event) => event.id == eventId);
    if (index != -1) {
      final oldEvent = _events[index];
      final updatedEvent = CalendarEvent(
        id: oldEvent.id,
        date: oldEvent.date,
        type: oldEvent.type,
        notes: notes,
        createdAt: oldEvent.createdAt,
      );

      _events[index] = updatedEvent;
      await _saveEvents();
      notifyListeners();
    }
  }

  Future<void> deleteEvent(String eventId) async {
    _events.removeWhere((event) => event.id == eventId);
    await _saveEvents();
    notifyListeners();
  }

  List<CalendarEvent> getEventsForDate(DateTime date) {
    return _events
        .where(
          (event) =>
              event.date.year == date.year &&
              event.date.month == date.month &&
              event.date.day == date.day,
        )
        .toList();
  }
}
