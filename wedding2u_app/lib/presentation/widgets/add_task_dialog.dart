import 'package:flutter/material.dart';

class AddTaskDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController taskNameController = TextEditingController();

    return AlertDialog(
      title: Text('Add New Task'),
      content: TextField(
        controller: taskNameController,
        decoration: InputDecoration(labelText: 'Task Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, taskNameController.text.trim());
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
