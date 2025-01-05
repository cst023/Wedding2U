import 'package:flutter/material.dart';

class TaskActionResult {
  final bool isDelete;
  final String? updatedTaskName;

  TaskActionResult({required this.isDelete, this.updatedTaskName});
}

class TaskActionDialog extends StatefulWidget {
  final String initialTaskName;

  TaskActionDialog({required this.initialTaskName});

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
      title: Text('Edit Task'),
      content: TextField(
        controller: _taskNameController,
        decoration: InputDecoration(labelText: 'Task Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              TaskActionResult(isDelete: true),
            );
          },
          child: Text('Delete', style: TextStyle(color: Colors.red)),
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
          child: Text('Save Changes'),
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
