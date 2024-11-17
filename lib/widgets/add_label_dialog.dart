import 'package:flutter/material.dart';
import '../models/label.dart';

class AddLabelDialog extends StatefulWidget {
  final Function(Label) onAdd;

  const AddLabelDialog({super.key, required this.onAdd});

  @override
  State<AddLabelDialog> createState() => _AddLabelDialogState();
}

class _AddLabelDialogState extends State<AddLabelDialog> {
  final _nameController = TextEditingController();
  Color _selectedColor = Colors.blue;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Label'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Label Name'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              Colors.blue,
              Colors.red,
              Colors.green,
              Colors.orange,
              Colors.purple,
            ].map((color) => GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: color,
                child: _selectedColor == color 
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            )).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              widget.onAdd(Label(
                name: _nameController.text,
                color: _selectedColor,
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}