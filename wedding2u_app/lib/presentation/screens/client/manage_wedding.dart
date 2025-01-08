import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding2u_app/application/manage_wedding_controller.dart';
import 'package:wedding2u_app/presentation/screens/client/countdown.dart';

class ManageWedding extends StatefulWidget {
  const ManageWedding({super.key});

  @override
  _ManageWeddingState createState() => _ManageWeddingState();
}

class _ManageWeddingState extends State<ManageWedding> {
  final ManageWeddingController _controller = ManageWeddingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = true;
  Map<String, dynamic>? _bookingData;
  DateTime? _weddingDate;
  Map<String, Map<String, dynamic>> _tasks = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final clientId = _auth.currentUser!.uid;
      final bookingData = await _controller.fetchBooking(clientId);
      final countdownDate = await _controller.fetchWeddingCountdown(clientId);
      final checklist = await _controller.fetchChecklist(clientId);

      setState(() {
        _bookingData = bookingData;
        _weddingDate = countdownDate;
        _tasks = checklist; // Replace with tasks fetched from Firestore
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage My Wedding',
            style: TextStyle(color: Colors.black)),
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bookingData != null
                      ? _buildVenueCard(context)
                      : const Center(child: Text('No active bookings found')),
                  const SizedBox(height: 24.0),
                  _buildCountdown(),
                  const SizedBox(height: 24.0),
                  _buildWeddingTentativeCard(context),
                  const SizedBox(height: 16.0),
                  _buildGuestListCard(context),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Checklist:',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  _tasks.isEmpty
                      ? const Center(child: Text('No tasks found'))
                      : ManageWeddingController.buildChecklist(
                          _tasks,
                          (taskId) {
                            _controller.handleTaskTap(
                              taskId,
                              context,
                              _tasks,
                              (updatedTasks) {
                                setState(() {
                                  _tasks = updatedTasks;
                                });
                              },
                              true,
                            );
                          },
                          (taskId, newValue) {
                            _controller.handleChecklistToggle(
                              taskId,
                              newValue,
                              _tasks,
                              () => setState(() {}),
                              _auth.currentUser!.uid,
                            );
                          },
                        ),
                  const SizedBox(height: 14.0),
                  Center(child: _buildAddTaskButton()),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
    );
  }

  Widget _buildVenueCard(BuildContext context) {
    final venueName = _bookingData?['venue_name'] ?? 'Unknown Venue';
    final status = _bookingData?['status'] ?? 'Unknown Status';
    final statusColor = status == 'Approved' ? Colors.green : Colors.orange;

    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Wedding Venue:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
            const SizedBox(height: 12.0),
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                'assets/images/wedding_dais.jpg',
                height: 150.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12.0),
            Text(venueName),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Booking Status: $status',
                    style: TextStyle(color: statusColor)),
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, 'VenueBookingStatus'),
                  child: const Text('Booking Details',
                      style: TextStyle(color: Color(0xFFf7706d))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountdown() {
    if (_weddingDate == null) {
      return GestureDetector(
        onTap: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
          );
          if (selectedDate != null) {
            final clientId = _auth.currentUser!.uid;
            await _controller.saveWeddingDate(context, clientId, selectedDate,
                (date) {
              setState(() {
                _weddingDate = date;
              });
            });
          }
        },
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: const Text(
              'Set Wedding Date',
              style: TextStyle(
                fontSize: 16.0,
                color: Color(0xFFf7706d),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    } else {
      final now = DateTime.now();
      final difference = _weddingDate!.difference(now);
      final days = difference.inDays;
      final hours = difference.inHours % 24;
      final minutes = difference.inMinutes % 60;

      return GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CountdownPage()),
          );
          _fetchData(); // Refresh data when returning from CountdownPage
        },
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                const Text(
                  'Wedding Countdown',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${_weddingDate!.day}/${_weddingDate!.month}/${_weddingDate!.year}',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  '$days Days, $hours Hours, $minutes Minutes',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildWeddingTentativeCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Navigate to Wedding Tentative');
        Navigator.pushNamed(context, 'TentativePage');
      },
      child: Card(
        color: Colors.white, // Set the card background color to white
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Wedding Tentative',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 12.0),
              Text(
                'Plan and manage your wedding schedule.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestListCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Navigate to Guest List');
        Navigator.pushNamed(context, 'GuestsPage');
      },
      child: Card(
        color: Colors.white, // Set the card background color to white
        elevation: 3.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Guest List',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
              ),
              const SizedBox(height: 12.0),
              Text(
                'Manage your wedding guest list and RSVPs.',
                style: TextStyle(fontSize: 16.0, color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddTaskButton() {
    return OutlinedButton.icon(
      onPressed: () async {
        await _controller.addNewTask(
          context,
          _tasks,
          (updatedTasks) {
            setState(() {
              _tasks.addAll(updatedTasks);
            });
          },
        );
      },
      icon: const Icon(Icons.add, color: Color(0xFFf7706d)),
      label: const Text('Add More Task',
          style: TextStyle(color: Color(0xFFf7706d))),
    );
  }
}
