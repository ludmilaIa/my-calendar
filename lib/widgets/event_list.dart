import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:intl/intl.dart';
import 'event_details_dialog.dart';

class EventList extends StatelessWidget {
  final List<Event> events;
  final Function(int) onDelete;

  const EventList({
    super.key,
    required this.events,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return events.isEmpty
        ? Center(
            child: Text(
              'No events yet',
              style: TextStyle(color: Colors.orange.shade300),
            ),
          )
        : ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => EventDetailsDialog(
                        event: event,
                        onDelete: () => onDelete(index),
                        onEdit: () {
                          // TODO: Implement edit functionality
                        },
                      ),
                    );
                  },
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        // Date
                        Container(
                          width: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            DateFormat('d\nMMM').format(event.date),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ),
                        // Vertical Separator
                        Container(
                          width: 1,
                          color: Colors.grey.shade300,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                        ),
                        // Event title
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }
}
