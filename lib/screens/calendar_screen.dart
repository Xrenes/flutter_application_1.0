import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/calendar_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../models/calendar_event.dart';
import 'event_entry_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore: unused_element
  void _showEventEntryModal([DateTime? date]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.92,
        child: EventEntryScreen(selectedDate: date ?? _focusedDay),
      ),
    );
  }

  String _parseName(String email) {
    final namePart = email.split('@').first;
    final parts = namePart.split('.');
    return parts
        .map((e) => e.isNotEmpty ? e[0].toUpperCase() + e.substring(1) : '')
        .join(' ');
  }

  Widget _buildProfileDrawer(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final email = authProvider.email ?? 'user@diu.edu.bd';
    final name = _parseName(email);
    return Drawer(
      elevation: 16,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    name.isNotEmpty ? name[0] : 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  name,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) => themeProvider.toggleTheme(),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    bool isLoading = false;
                    return StatefulBuilder(
                      builder: (context, setState) => TextButton.icon(
                        onPressed: isLoading
                            ? null
                            : () async {
                                setState(() => isLoading = true);
                                await authProvider.logout();
                                setState(() => isLoading = false);
                                Navigator.of(context).pop();
                              },
                        icon: isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.logout),
                        label: Text(isLoading ? 'Logging out...' : 'Logout'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, calendarProvider, child) {
        final events = calendarProvider.events;
        return Expanded(
          child: PagedVerticalCalendar(
            minDate: DateTime(2020, 1, 1),
            maxDate: DateTime(2030, 12, 31),
            initialDate: _focusedDay,
            startWeekWithSunday: true,
            onDayPressed: (date) {
              setState(() {
                _selectedDay = date;
                _focusedDay = date;
              });
            },
            monthBuilder: (context, month, year) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                '${_monthName(month)} $year',
                style:
                    Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ) ??
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            dayBuilder: (context, date) {
              final dayEvents = events
                  .where(
                    (e) =>
                        e.date.year == date.year &&
                        e.date.month == date.month &&
                        e.date.day == date.day,
                  )
                  .toList();
              final isSelected = isSameDay(_selectedDay, date);
              final isToday = isSameDay(DateTime.now(), date);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDay = date;
                    _focusedDay = date;
                  });
                },
                onDoubleTap: () async {
                  if (dayEvents.isNotEmpty) {
                    final selectedEvent = await showMenu<CalendarEvent>(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        100,
                        200,
                        100,
                        100,
                      ), // You may want to calculate this based on tap position
                      items: dayEvents.map((event) {
                        return PopupMenuItem<CalendarEvent>(
                          value: event,
                          child: Row(
                            children: [
                              Icon(
                                _eventIcon(event.type),
                                color: event.color,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(_eventTypeLabel(event.type)),
                              ),
                              if (event.notes.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    event.notes,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                tooltip: 'Delete',
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Event'),
                                      content: const Text(
                                        'Are you sure you want to delete this event?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text(
                                            'Delete',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) {
                                    await Provider.of<CalendarProvider>(
                                      context,
                                      listen: false,
                                    ).deleteEvent(event.id);
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Event deleted.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                    if (selectedEvent != null) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FractionallySizedBox(
                          heightFactor: 0.92,
                          child: EventEntryScreen(
                            selectedDate: selectedEvent.date,
                            preSelectedEventType: selectedEvent.type,
                            editingEvent: selectedEvent,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.15)
                            : isToday
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    if (dayEvents.isNotEmpty)
                      Positioned(
                        bottom: 6,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: dayEvents.take(5).map((event) {
                            return Container(
                              width: 7,
                              height: 7,
                              margin: const EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: event.color,
                                shape: BoxShape.circle,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              );
            },
            listPadding: const EdgeInsets.symmetric(horizontal: 8),
          ),
        );
      },
    );
  }

  Widget _buildTasks(BuildContext context) {
    return Consumer<CalendarProvider>(
      builder: (context, calendarProvider, child) {
        final now = DateTime.now();
        final upcoming =
            calendarProvider.events
                .where(
                  (e) =>
                      e.date.isAfter(now) ||
                      (e.date.year == now.year &&
                          e.date.month == now.month &&
                          e.date.day == now.day),
                )
                .toList()
              ..sort((a, b) => a.date.compareTo(b.date));
        if (upcoming.isEmpty) {
          return const Center(child: Text('No upcoming tasks.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: upcoming.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) {
            final event = upcoming[i];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: event.color.withOpacity(0.15),
                  child: Icon(_eventIcon(event.type), color: event.color),
                ),
                title: Text(
                  _eventTypeLabel(event.type),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  event.notes.length > 40
                      ? '${event.notes.substring(0, 40)}...'
                      : event.notes,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  "${event.date.day}/${event.date.month}/${event.date.year}",
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(_eventTypeLabel(event.type)),
                      content: Text(event.notes),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

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

  String _monthName(int month) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                Text(
                  _currentIndex == 0
                      ? 'Today'
                      : _currentIndex == 1
                      ? 'Tasks'
                      : 'Profile',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                if (_currentIndex == 0)
                  PopupMenuButton<EventType>(
                    icon: const Icon(Icons.add, size: 28),
                    tooltip: 'Add Event',
                    onSelected: (EventType eventType) {
                      if (_selectedDay != null) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => FractionallySizedBox(
                            heightFactor: 0.92,
                            child: EventEntryScreen(
                              selectedDate: _selectedDay!,
                              preSelectedEventType: eventType,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a date first'),
                          ),
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        EventType.values.map((eventType) {
                          return PopupMenuItem<EventType>(
                            value: eventType,
                            child: Row(
                              children: [
                                Icon(
                                  _eventIcon(eventType),
                                  color: _eventColor(eventType),
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(_eventTypeLabel(eventType)),
                              ],
                            ),
                          );
                        }).toList(),
                  )
                else
                  const SizedBox(width: 40),
              ],
            ),
          ),
        ),
      ),
      endDrawer: _buildProfileDrawer(context),
      body: _currentIndex == 0
          ? _buildCalendar(context)
          : _currentIndex == 1
          ? _buildTasks(context)
          : const SizedBox.shrink(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 2) {
              _scaffoldKey.currentState?.openEndDrawer();
            }
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
