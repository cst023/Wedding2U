import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wedding2u_app/application/guest_list_controller.dart';
import 'dart:async';
import 'package:device_calendar/device_calendar.dart';

class CountdownScreen extends StatefulWidget {
  final String invitationCode;

  const CountdownScreen({super.key, required this.invitationCode});

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  late Future<Map<String, dynamic>> _weddingPlanFuture;
  late Timer _timer;
  Duration _duration = const Duration();
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();

  @override
  void initState() {
    super.initState();
    _weddingPlanFuture = GuestListController().getWeddingPlanDetailsByInvitationCode(widget.invitationCode);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) => _updateCountdown());
  }

  void _updateCountdown() async {
    try {
      final weddingPlan = await _weddingPlanFuture;
      final weddingDate = (weddingPlan['countdown_date'] as Timestamp).toDate();
      final now = DateTime.now();

      setState(() {
        _duration = weddingDate.difference(now);
      });
    } catch (e) {
      // Handle error if needed
    }
  }

  Future<void> _addEventToCalendar(Map<String, dynamic> weddingPlan) async {
    try {
      final permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      if (!(permissionsGranted.data ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Calendar permission denied. Please enable it in your device settings.'),
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

      final weddingDate = (weddingPlan['countdown_date'] as Timestamp).toDate();
      final event = Event(
        calendar.id,
        title: '${weddingPlan['wedding_couple']} Wedding Ceremony',
        description: 'Venue: ${weddingPlan['wedding_venue']}',
        start: TZDateTime.from(weddingDate, local),
        end: TZDateTime.from(weddingDate.add(const Duration(hours: 3)), local), // Assuming a 3-hour event
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
          content: Text('Error adding event to calendar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countdown'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _weddingPlanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text('Wedding plan not found.'),
            );
          }

          final weddingPlan = snapshot.data!;
          final weddingCouple = weddingPlan['wedding_couple'] ?? 'Couple';
          final weddingVenue = weddingPlan['wedding_venue'] ?? 'Venue';
          final weddingDate = (weddingPlan['countdown_date'] as Timestamp).toDate();
          final formattedDate = DateFormat('d MMMM yyyy').format(weddingDate);

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    'assets/guest_images/wedding.jpg', // Local asset image
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  weddingCouple,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Cursive'),
                ),
                const SizedBox(height: 8),
                Text(
                  '$weddingVenue\n$formattedDate',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  '${_duration.inDays} Days\n${_duration.inHours % 24} Hours\n${_duration.inMinutes % 60} Minutes',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                /*
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  onPressed: () => _addEventToCalendar(weddingPlan),
                  child: const Text(
                    'Add To Calendar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),*/
              ],
            ),
          );
        },
      ),
    );
  }
}
