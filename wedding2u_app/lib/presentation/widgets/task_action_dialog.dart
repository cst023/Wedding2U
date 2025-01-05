import 'package:flutter/material.dart';

class TaskActionResult {
  final bool isDelete;
  final String? updatedTaskName;

  TaskActionResult({required this.isDelete, this.updatedTaskName});
}

class TaskActionDialog extends StatefulWidget {
  final String initialTaskName;

  const TaskActionDialog({super.key, required this.initialTaskName});

  @override
  _TaskActionDialogState createState() => _TaskActionDialogState();
}

class _TaskActionDialogState extends State<TaskActionDialog> {
  late TextEditingController _taskNameController;

  @override
  void initState() {
    super.initState();
    _taskNameController = TextEditingController(text: widget.initialTaskName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: TextField(
        controller: _taskNameController,
        decoration: const InputDecoration(labelText: 'Task Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              TaskActionResult(isDelete: true),
            );
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              TaskActionResult(
                isDelete: false,
                updatedTaskName: _taskNameController.text.trim(),
              ),
            );
          },
          child: const Text('Save Changes'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    super.dispose();
  }
}
