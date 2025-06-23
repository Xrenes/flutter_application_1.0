import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calendar_provider.dart';
import '../models/calendar_event.dart';

class EventEntryScreen extends StatefulWidget {
  final DateTime selectedDate;
  final EventType? preSelectedEventType;
  final CalendarEvent? editingEvent;
  const EventEntryScreen({
    super.key,
    required this.selectedDate,
    this.preSelectedEventType,
    this.editingEvent,
  });

  @override
  State<EventEntryScreen> createState() => _EventEntryScreenState();
}

class _EventEntryScreenState extends State<EventEntryScreen> {
  late EventType _eventType;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editingEvent != null) {
      _eventType = widget.editingEvent!.type;
      _notesController.text = widget.editingEvent!.notes;
    } else {
      _eventType = widget.preSelectedEventType!;
      _notesController.text = '';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveEvent() async {
    if (_notesController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter notes.')));
      return;
    }
    final calendarProvider = context.read<CalendarProvider>();
    // Only add the new event, do not delete existing events for this date
    await calendarProvider.addEvent(
      widget.selectedDate,
      _eventType,
      _notesController.text.trim(),
    );
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event saved successfully!')),
      );
    }
  }

  Color _eventColor(EventType type) {
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

  String _eventTypeLabel(EventType type) {
    switch (type) {
      case EventType.quiz:
        return 'Quiz';
      case EventType.assignment:
        return 'Assignment';
      case EventType.presentation:
        return 'Presentation';
      case EventType.midExam:
        return 'Mid exam';
      case EventType.finalExam:
        return 'Final exam';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _eventColor(_eventType);
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _eventTypeLabel(_eventType),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: Colors.grey[700],
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            // Text Editor
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                controller: _notesController,
                maxLines: 10,
                minLines: 6,
                style: TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Enter notes for ${_eventTypeLabel(_eventType)}',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color, width: 2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                  fillColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Save Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveEvent,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
