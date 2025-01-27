import 'package:flutter/material.dart';
import '../models/event.dart';

class AddEventDialog extends StatefulWidget {
  final Function(Event) onAdd;

  const AddEventDialog({super.key, required this.onAdd});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.orange.shade50,
      title: const Text('Add New Event'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(hintText: "Enter event details"),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel', style: TextStyle(color: Colors.orange)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Add', style: TextStyle(color: Colors.orange)),
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onAdd(Event(
                title: _controller.text,
                date: DateTime.now(),
              ));
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }
}
