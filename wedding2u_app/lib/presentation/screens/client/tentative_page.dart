import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding2u_app/application/manage_wedding_controller.dart';

class TentativePage extends StatefulWidget {
  const TentativePage({super.key});

  @override
  _TentativePageState createState() => _TentativePageState();
}

class _TentativePageState extends State<TentativePage> {
  List<Map<String, String>> events = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTentative();
  }

  Future<void> _fetchTentative() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final clientId = FirebaseAuth.instance.currentUser!.uid;
      final fetchedEvents =
          await ManageWeddingController().fetchTentative(clientId);

      setState(() {
        events = fetchedEvents.map<Map<String, String>>((event) {
          final id = event['id']?.toString();
          if (id == null || id.isEmpty) {
            throw Exception('Error: Event ID is missing in the fetched data.');
          }
          return {
            'id': id,
            'name': event['event_name']?.toString() ?? '',
            'time': event['start_time']?.toString() ?? '',
            'description': event['description']?.toString() ?? '',
          };
        }).toList();

        // Sort events by time in ascending order
        events.sort((a, b) {
          final timeA = a['time'];
          final timeB = b['time'];
          if (timeA == null && timeB == null) return 0;
          if (timeA == null) return 1;
          if (timeB == null) return -1;
          return timeA.compareTo(timeB);
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching events: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _addOrEditEvent({Map<String, String>? event, int? index}) {
    final TextEditingController eventNameController =
        TextEditingController(text: event?['name'] ?? '');
    final TextEditingController descriptionController =
        TextEditingController(text: event?['description'] ?? '');
    TimeOfDay? selectedTime = event != null ? _parseTime(event['time']) : null;

    _showEventDialog(
      eventNameController: eventNameController,
      descriptionController: descriptionController,
      selectedTime: selectedTime,
      onSave: () async {
        final isValid = _validateEventInputs(
          eventNameController: eventNameController,
          selectedTime: selectedTime,
        );

        if (!isValid) return;

        final formattedTime = _formatTime(selectedTime!);

        final newEvent = {
          'name': eventNameController.text,
          'time': formattedTime,
          'description': descriptionController.text,
        };

        if (event == null) {
          // Add a new event
          await _addEventToFirestore(newEvent);
        } else if (index != null) {
          // Update an existing event
          final eventId = event['id'];
          if (eventId == null || eventId.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Error: Event ID is missing. Cannot update.'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }
          await _updateEventInFirestore(index, eventId, newEvent);
        }

        Navigator.pop(context);
      },
      onTimeSelected: (TimeOfDay time) {
        selectedTime = time;
      },
    );
  }

  void _showEventDialog({
  required TextEditingController eventNameController,
  required TextEditingController descriptionController,
  required TimeOfDay? selectedTime,
  required VoidCallback onSave,
  required ValueChanged<TimeOfDay> onTimeSelected,
}) {
  final TextEditingController timeController = TextEditingController(
    text: selectedTime != null ? _formatTime(selectedTime) : '',
  );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add or Edit Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Event Name Field
              TextField(
                controller: eventNameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              const SizedBox(height: 10),

              // Time Input Field
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (HH:mm)',
                  suffixIcon: Icon(Icons.access_time),
                ),
                readOnly: true, // Disable manual typing to avoid format issues
                onTap: () async {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    onTimeSelected(pickedTime);
                    timeController.text = _formatTime(pickedTime);
                  }
                },
              ),
              const SizedBox(height: 10),

              // Description Field
              TextField(
                controller: descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Description (optional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onSave,
            child: const Text('Save'),
          ),
        ],
      );
    },
  );
}


  bool _validateEventInputs({
    required TextEditingController eventNameController,
    required TimeOfDay? selectedTime,
  }) {
    if (eventNameController.text.isEmpty || selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a valid event name and time.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _addEventToFirestore(Map<String, String> newEvent) async {
  try {
    final clientId = FirebaseAuth.instance.currentUser!.uid;
    final eventId = await ManageWeddingController().addEvent(
      clientId: clientId,
      eventName: newEvent['name']!,
      startTime: newEvent['time']!,
      description: newEvent['description'],
    );

    setState(() {
      events.add({...newEvent, 'id': eventId});  // Add eventId to the local map
      _sortEvents();
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error adding event: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  Future<void> _updateEventInFirestore(
    int index, String eventId, Map<String, String> updatedEvent) async {
  try {
    final clientId = FirebaseAuth.instance.currentUser!.uid;
    await ManageWeddingController().updateEvent(
      clientId: clientId,
      eventId: eventId,
      eventName: updatedEvent['name']!,
      startTime: updatedEvent['time']!,
      description: updatedEvent['description'],
    );

    setState(() {
      events[index] = {...updatedEvent, 'id': eventId};  // Preserve the eventId
      _sortEvents();
    });
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error updating event: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  void _sortEvents() {
    events.sort((a, b) {
      final timeA = a['time'] ?? '';
      final timeB = b['time'] ?? '';
      return timeA.compareTo(timeB);
    });
  }

  TimeOfDay? _parseTime(String? time) {
    if (time == null || time.isEmpty) return null;
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentative', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? const Center(child: Text('No events added.'))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.deepPurple,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              if (index < events.length - 1)
                                Container(
                                  width: 2,
                                  height: 50,
                                  color: Colors.deepPurple,
                                ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                title: Text(event['name'] ?? ''),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Time: ${event['time'] ?? ''}'),
                                    if ((event['description'] ?? '').isNotEmpty)
                                      Text('${event['description']}'),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _addOrEditEvent(
                                        event: event,
                                        index: index,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () async {
                                        final clientId = FirebaseAuth
                                            .instance.currentUser!.uid;
                                        final eventId = event['id'];

                                        // Check for null or empty event ID
                                        if (eventId == null ||
                                            eventId.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Error: Event ID is missing. Cannot delete.'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }

                                        try {
                                          await ManageWeddingController()
                                              .deleteEvent(
                                            clientId: clientId,
                                            eventId: eventId,
                                          );
                                          setState(() {
                                            events.removeAt(index);
                                          });
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  'Error deleting event: $e'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditEvent(),
        child: const Icon(Icons.add),
      ),
    );
  }
} 


