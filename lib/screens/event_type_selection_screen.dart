import 'package:flutter/material.dart';
import '../models/calendar_event.dart';
import 'event_entry_screen.dart';

class EventTypeSelectionScreen extends StatelessWidget {
  final DateTime selectedDate;

  const EventTypeSelectionScreen({super.key, required this.selectedDate});

  IconData _eventIcon(EventType type) {
    switch (type) {
      case EventType.quiz:
        return Icons.help_outline;
      case EventType.assignment:
        return Icons.check;
      case EventType.presentation:
        return Icons.present_to_all;
      case EventType.midExam:
        return Icons.grade;
      case EventType.finalExam:
        return Icons.grade;
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

  void _selectEventType(BuildContext context, EventType eventType) {
    Navigator.of(context).pop();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.92,
        child: EventEntryScreen(
          selectedDate: selectedDate,
          preSelectedEventType: eventType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Event Type',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              // Event type grid
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: EventType.values.map((eventType) {
                  return GestureDetector(
                    onTap: () => _selectEventType(context, eventType),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _eventColor(eventType).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _eventColor(eventType).withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _eventIcon(eventType),
                            color: _eventColor(eventType),
                            size: 40,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _eventTypeLabel(eventType),
                            style: TextStyle(
                              color: _eventColor(eventType),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
