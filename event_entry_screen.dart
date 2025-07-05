import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../General/providers/calendar_provider.dart';
import '../General/models/calendar_event.dart';
import 'package:intl/intl.dart';

class ResizableBox extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  const ResizableBox({
    super.key,
    required this.child,
    this.minHeight = 80,
    this.maxHeight = 300,
  });
  @override
  State<ResizableBox> createState() => _ResizableBoxState();
}

class _ResizableBoxState extends State<ResizableBox> {
  double _height = 120;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: _height,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!, width: 1.2),
          ),
          child: widget.child,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _height += details.delta.dy;
                _height = _height.clamp(widget.minHeight, widget.maxHeight);
              });
            },
            child: Icon(Icons.drag_handle, size: 24, color: Colors.grey[400]),
          ),
        ),
      ],
    );
  }
}

class EventEntryScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String eventType;
  final String username;
  final CalendarEvent? editingEvent;
  const EventEntryScreen({
    super.key,
    required this.selectedDate,
    required this.eventType,
    required this.username,
    this.editingEvent,
  });

  @override
  State<EventEntryScreen> createState() => _EventEntryScreenState();
}

class _EventEntryScreenState extends State<EventEntryScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.editingEvent?.notes ?? '',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  EventType _getEventTypeFromString(String eventTypeString) {
    switch (eventTypeString.toLowerCase()) {
      case 'quiz':
        return EventType.quiz;
      case 'assignment':
        return EventType.assignment;
      case 'presentation':
        return EventType.presentation;
      case 'mid exam':
        return EventType.midExam;
      case 'final exam':
        return EventType.finalExam;
      default:
        return EventType.quiz; // Default fallback
    }
  }

  Future<void> _saveEvent() async {
    final text = _textController.text;
    if (text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter event details.')),
      );
      return;
    }
    final calendarProvider = context.read<CalendarProvider>();
    await calendarProvider.addEvent(
      widget.selectedDate,
      _getEventTypeFromString(widget.eventType),
      text.trim(),
    );
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          width: 350,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  widget.eventType,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Edited by (${widget.username})',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ResizableBox(
                minHeight: 80,
                maxHeight: 300,
                child: TextField(
                  controller: _textController,
                  minLines: 4,
                  maxLines: null,
                  expands: false,
                  decoration: const InputDecoration(
                    hintText: 'Enter event details...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12),
                  ),
                  keyboardType: TextInputType.multiline,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveEvent,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
