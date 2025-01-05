import 'package:flutter/material.dart';

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController taskNameController = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Task'),
      content: TextField(
        controller: taskNameController,
        decoration: const InputDecoration(labelText: 'Task Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, taskNameController.text.trim());
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
