import 'package:flutter/material.dart';
import 'package:wedding2u_app/data/firestore_service.dart';
import 'package:wedding2u_app/presentation/widgets/add_task_dialog.dart';
import 'package:wedding2u_app/presentation/widgets/task_action_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ManageWeddingController {
  final FirestoreService _firestoreService = FirestoreService();
 
static Widget buildChecklist(
  Map<String, Map<String, dynamic>> tasks,
  Function(String) onTap,
  Function(String, bool) onTaskToggle,
) {
  return Column(
    children: tasks.entries.map((entry) {
      final taskId = entry.key; // Task ID
      final taskData = entry.value; 

      return Card(
        elevation: 2.0,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListTile(
          leading: Checkbox(
            value: taskData['task_status'],
            onChanged: (bool? newValue) {
              onTaskToggle(taskId, newValue ?? false); // Pass taskId and new status
            },
          ),
          title: Text(taskData['task_name']),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey[600]),
          onTap: () => onTap(taskId), // Pass taskId to the onTap handler
        ),
      );
    }).toList(),
  );
}



  Future<void> addTaskToFirestore({
  required String clientId,
  required String taskName,
}) async {
  try {
    await _firestoreService.addTaskToChecklist(
      clientId: clientId,
      taskName: taskName,
      taskStatus: false, // Default status is "not completed"
    );
  } catch (e) {
    throw Exception('Error adding task to Firestore: $e');
  }
}

Future<void> addNewTask(
  BuildContext context,
  Map<String, Map<String, dynamic>> tasks,
  Function(Map<String, Map<String, dynamic>>) onTaskUpdate,
) async {
  final result = await showDialog<String?>(
    context: context,
    builder: (context) => const AddTaskDialog(),
  );

  if (result == null || result.isEmpty) return;

  final clientId = FirebaseAuth.instance.currentUser!.uid;

  try {
    // Add the task to Firestore
    final taskId = await _firestoreService.addTaskToChecklist(
      clientId: clientId,
      taskName: result,
      taskStatus: false,
    );

    // Add the task locally with the Firestore task ID
    tasks[taskId] = {
      'task_name': result,
      'task_status': false,
    };

    // Update the UI
    onTaskUpdate(tasks);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error adding task: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Future<Map<String, dynamic>?> fetchBooking(String clientId) async {
    try {
      final bookings = await _firestoreService.getClientBookings(clientId);
      return bookings.isNotEmpty ? bookings.first : null;
    } catch (e) {
      throw Exception('Error fetching booking: $e');
    }
  }

  Future<DateTime?> fetchWeddingCountdown(String clientId) async {
    return await _firestoreService.fetchWeddingCountdown(clientId);
  }

  Future<void> saveWeddingCountdown({
  required String clientId,
  required DateTime countdownDate,
}) async {
  await _firestoreService.saveWeddingCountdown(
    clientId: clientId,
    countdownDate: countdownDate,
  );
}


  Future<Map<String, dynamic>> fetchWeddingPlan(String clientId) async {
    return await _firestoreService.getWeddingPlan(clientId);
  }

  Future<void> updateWeddingPlan({
    required String clientId,
    required String weddingCouple,
    required String weddingVenue,
    required DateTime countdownDate,
  }) async {
    await _firestoreService.updateWeddingPlan(
      clientId: clientId,
      weddingCouple: weddingCouple,
      weddingVenue: weddingVenue,
      countdownDate: countdownDate,
    );
  }
/*
Future<void> handleChecklistToggle(
  String taskKey,
  bool newValue,
  Map<String, bool> tasks,
  Function() onUpdate,
) async {
  tasks[taskKey] = newValue;
  onUpdate(); // Notify the UI to rebuild with updated state
}*/


Future<void> handleChecklistToggle(
  String taskId,
  bool newValue,
  Map<String, Map<String, dynamic>> tasks,
  Function() onUpdate,
  String clientId,
) async {
  tasks[taskId]!['task_status'] = newValue;
  onUpdate();

  await _firestoreService.updateTaskStatus(
    clientId: clientId,
    taskId: taskId,
    taskStatus: newValue,
  );
}


Future<void> handleTaskTap(
  String taskKey,
  BuildContext context,
  Map<String, Map<String, dynamic>> tasks,
  Function(Map<String, Map<String, dynamic>>) onTaskUpdate,
  bool isClientAdded,
) async {
  final clientId = FirebaseAuth.instance.currentUser!.uid;
  if (isClientAdded) {
    await editOrDeleteTask(context, taskKey, tasks, onTaskUpdate, clientId);
  } else {
    switch (taskKey) {
      case 'Wedding Tentative':
        Navigator.pushNamed(context, 'TimelinePage');
        break;
      case 'Guest List':
        Navigator.pushNamed(context, 'GuestsPage');
        break;
      case 'Find Photographer':
        Navigator.pushNamed(context, 'PhotographersPage');
        break;
      default:
        break;
    }
  }
}


Future<void> saveWeddingDate(BuildContext context, String clientId, DateTime date,
    Function(DateTime) onWeddingDateSelected) async {
  try {
    await saveWeddingCountdown(
      clientId: clientId, // Explicitly use the passed clientId
      countdownDate: date,
    );
    onWeddingDateSelected(date); // Notify the caller of the successful update
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error saving wedding date: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> editOrDeleteTask(
  BuildContext context,
  String taskId,
  Map<String, Map<String, dynamic>> tasks,
  Function(Map<String, Map<String, dynamic>>) onTaskUpdate,
  String clientId,
) async {
  final taskName = tasks[taskId]!['task_name'];
  final result = await showDialog<TaskActionResult?>(
    context: context,
    builder: (context) => TaskActionDialog(initialTaskName: taskName),
  );

  if (result == null) return;

  if (result.isDelete) {
    tasks.remove(taskId);
    await _firestoreService.deleteTaskFromChecklist(clientId: clientId, taskId: taskId);
  } else if (result.updatedTaskName != null && result.updatedTaskName!.isNotEmpty) {
    tasks[taskId]!['task_name'] = result.updatedTaskName!;
    await _firestoreService.updateTaskName(
      clientId: clientId,
      taskId: taskId,
      newTaskName: result.updatedTaskName!,
    );
  }

  onTaskUpdate(tasks);
}

Future<Map<String, Map<String, dynamic>>> fetchChecklist(String clientId) async {
  try {
    final checklist = await _firestoreService.getChecklist(clientId);
    return checklist; // No need to map again since the data is already in the correct format
  } catch (e) {
    throw Exception('Error fetching checklist: $e');
  }
}

Future<void> updateTaskName({
  required String clientId,
  required String taskId,
  required String newTaskName,
}) async {
  await _firestoreService.updateTaskName(
    clientId: clientId,
    taskId: taskId,
    newTaskName: newTaskName,
  );
}

Future<void> updateTaskStatus({
  required String clientId,
  required String taskId,
  required bool taskStatus,
}) async {
  await _firestoreService.updateTaskStatus(
    clientId: clientId,
    taskId: taskId,
    taskStatus: taskStatus,
  );
}

Future<String> addEvent({
  required String clientId,
  required String eventName,
  required String startTime,
  String? description,
}) async {
  try {
    final eventId = await _firestoreService.addEventToTentative(
      clientId: clientId,
      eventName: eventName,
      startTime: startTime,
      description: description,
    );
    return eventId;  // Return the event ID
  } catch (e) {
    throw Exception('Error adding event: $e');
  }
}

Future<List<Map<String, dynamic>>> fetchTentative(String clientId) async {
  try {
    return await _firestoreService.fetchTentative(clientId);
  } catch (e) {
    throw Exception('Error fetching tentative: $e');
  }
}

Future<void> deleteEvent({
  required String clientId,
  required String eventId,
}) async {
  try {
    await _firestoreService.deleteEvent(clientId: clientId, eventId: eventId);
  } catch (e) {
    throw Exception('Error deleting event: $e');
  }
}

Future<void> updateEvent({
  required String clientId,
  required String eventId,
  required String eventName,
  required String startTime,
  String? description,
}) async {
  try {
    await FirestoreService().updateEvent(
      clientId: clientId,
      eventId: eventId,
      eventName: eventName,
      startTime: startTime,
      description: description,
    );
  } catch (e) {
    throw Exception('Error updating event: $e');
  }
}


}

