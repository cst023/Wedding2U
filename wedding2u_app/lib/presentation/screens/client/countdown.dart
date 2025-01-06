import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/manage_wedding_controller.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:device_calendar/device_calendar.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage({super.key});

  @override
  _CountdownPageState createState() => _CountdownPageState();
}
 
class _CountdownPageState extends State<CountdownPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ManageWeddingController _manageWeddingController =
      ManageWeddingController();
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  DateTime? _weddingDate;
  bool _isLoading = true;
  bool _isEditing = false;

  final TextEditingController _coupleNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _weddingDateController = TextEditingController();

  Future<void> _fetchWeddingCountdown() async {
  try {
    final clientId = _auth.currentUser!.uid;

    // Fetch wedding plan data from Firestore
    final weddingPlan =
        await _manageWeddingController.fetchWeddingPlan(clientId);

    setState(() {
      if (weddingPlan['countdown_date'] != null) {
        // Parse the countdown_date as DateTime
        _weddingDate = (weddingPlan['countdown_date'] as Timestamp).toDate();
        _weddingDateController.text =
            DateFormat('MMMM d, yyyy').format(_weddingDate!);
      }
      _coupleNameController.text = weddingPlan['wedding_couple'] ?? '';
      _locationController.text = weddingPlan['wedding_venue'] ?? '';
      _isLoading = false;
    });
  } catch (e) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error fetching wedding plan: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


Future<void> _addEventToCalendar() async {
  try {
    final permissionsGranted =
        await _deviceCalendarPlugin.requestPermissions();
    if (!(permissionsGranted.data ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Calendar permissions denied.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (!(calendarsResult.isSuccess) || calendarsResult.data == null) {
      throw Exception('Failed to retrieve calendars.');
    }

    final calendar = calendarsResult.data!.firstWhere(
      (cal) => cal.isDefault ?? false,
      orElse: () => calendarsResult.data!.first,
    );

    print('Using Calendar: ${calendar.name}, ID: ${calendar.id}');

    final event = Event(
      calendar.id,
      title: _coupleNameController.text.isEmpty
          ? 'Wedding Countdown'
          : '${_coupleNameController.text} Wedding',
      location: _locationController.text,
      start: TZDateTime.from(_weddingDate!, local),
      end: TZDateTime.from(_weddingDate!.add(const Duration(hours: 4)), local),
      description: 'Wedding ceremony countdown',
    );

    final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    if (result?.isSuccess ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event added to calendar successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      throw Exception('Failed to add event to calendar.');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error adding to calendar: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


  @override
  void initState() {
    super.initState();
    _fetchWeddingCountdown();
  }

  void _saveChanges() async {
    try {
      final clientId = _auth.currentUser!.uid;
      final weddingCouple = _coupleNameController.text.trim();
      final weddingVenue = _locationController.text.trim();
      final countdownDate = _weddingDate!;

      await _manageWeddingController.updateWeddingPlan(
        clientId: clientId,
        weddingCouple: weddingCouple,
        weddingVenue: weddingVenue,
        countdownDate: countdownDate,
      );

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving changes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _coupleNameController.dispose();
    _locationController.dispose();
    _weddingDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Countdown',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
            },
            icon: Icon(
              _isEditing ? Icons.close : Icons.edit,
              color: Colors.pinkAccent,
            ),
            label: Text(
              _isEditing ? 'Cancel' : 'Edit',
              style: const TextStyle(color: Colors.pinkAccent),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.asset(
                      'assets/guest_images/wedding.jpg',
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Couple Name Section
                  _isEditing
                      ? TextField(
                          controller: _coupleNameController,
                          decoration: const InputDecoration(
                            labelText: 'Couple Name',
                            hintText: 'Enter Couple Name (e.g. Javier & Syahira)',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Text(
                          _coupleNameController.text.isEmpty
                              ? ''
                              : _coupleNameController.text,
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cursive',
                          ),
                        ),
                  const SizedBox(height: 16.0),
                  // Location Section
                  _isEditing
                      ? TextField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Location',
                            hintText: 'Enter Wedding Venue',
                            border: OutlineInputBorder(),
                          ),
                        )
                      : Text(
                          _locationController.text.isEmpty
                              ? 'Enter Wedding Venue'
                              : _locationController.text,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[700],
                          ),
                        ),
                  const SizedBox(height: 16.0),
                  // Wedding Date Section
                  _isEditing
                      ? GestureDetector(
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: _weddingDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                _weddingDate = selectedDate;
                                _weddingDateController.text =
                                    DateFormat('MMMM d, yyyy')
                                        .format(selectedDate);
                              });
                            }
                          },
                          child: TextField(
                            controller: _weddingDateController,
                            enabled: false, 
                            decoration: const InputDecoration(
                              labelText: 'Wedding Date',
                              hintText: 'Select Wedding Date',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        )
                      : Text(
                          _weddingDate != null
                              ? DateFormat('MMMM d, yyyy').format(_weddingDate!)
                              : 'Select Wedding Date',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[700],
                          ),
                        ),
                  const SizedBox(height: 16.0),

                  // Countdown Section
                  if (_weddingDate != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CountdownItem(label: 'Days', value: '${_daysLeft()}'),
                        CountdownItem(label: 'Hours', value: '${_hoursLeft()}'),
                        CountdownItem(
                            label: 'Minutes', value: '${_minutesLeft()}'),
                      ],
                    ),
                  const Spacer(),

                  // Button Section
                  if (_isEditing)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: _saveChanges,
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                 /* else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        onPressed: () {
                          // Add to calendar logic
                          if (_weddingDate != null) {
                            _addEventToCalendar();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a wedding date.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Add To Calendar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),*/
                ],
              ),
            ),
    );
  }

  int _daysLeft() {
    final now = DateTime.now();
    return _weddingDate != null ? _weddingDate!.difference(now).inDays : 0;
  }

  int _hoursLeft() {
    final now = DateTime.now();
    return _weddingDate != null
        ? _weddingDate!.difference(now).inHours % 24
        : 0;
  }

  int _minutesLeft() {
    final now = DateTime.now();
    return _weddingDate != null
        ? _weddingDate!.difference(now).inMinutes % 60
        : 0;
  }
}

class CountdownItem extends StatelessWidget {
  final String label;
  final String value;

  const CountdownItem({super.key, 
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
