import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wedding2u_app/data/firestore_service.dart';
import 'package:wedding2u_app/application/guest_list_controller.dart';
import 'home_screen.dart';
import 'rejected_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptRejectScreen extends StatefulWidget {
  final String invitationCode;
  final String guestPhone;

  const AcceptRejectScreen(
      {super.key, required this.invitationCode, required this.guestPhone});

  @override
  _AcceptRejectScreenState createState() => _AcceptRejectScreenState();
}

class _AcceptRejectScreenState extends State<AcceptRejectScreen> {
  late Future<Map<String, dynamic>> _weddingPlanFuture;
  final GuestListController _controller = GuestListController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _weddingPlanFuture =
        FirestoreService().getWeddingPlanDetails(widget.invitationCode);
  }

  Future<void> _updateRsvpStatus(String rsvpStatus) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final weddingPlan = await _weddingPlanFuture;
      final weddingPlanId = weddingPlan['client_id'];

      await _controller.updateGuestRsvpStatus(
        weddingPlanId: weddingPlanId,
        guestPhone: widget.guestPhone,
        rsvpStatus: rsvpStatus,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('RSVP status updated to $rsvpStatus!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => rsvpStatus == "Confirmed"
              ? HomeScreen(invitationCode: widget.invitationCode)
              : const RejectedScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating RSVP status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
              future: _weddingPlanFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text("No wedding plan found."));
                }

                final weddingPlan = snapshot.data!;
                final weddingCouple = weddingPlan['wedding_couple'] ?? "Couple";
                final weddingVenue = weddingPlan['wedding_venue'] ?? "Venue";
                final countdownDate = weddingPlan['countdown_date'] != null
                    ? (weddingPlan['countdown_date'] as Timestamp).toDate()
                    : DateTime.now();
                final formattedDate =
                    DateFormat('d MMMM yyyy').format(countdownDate);

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/guest_images/wedding.jpg',
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        weddingCouple, // Dynamic wedding couple name
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFf7706d),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'You are invited to $weddingCouple’s\nWedding Ceremony at\n$weddingVenue\n$formattedDate',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 107, 106, 106),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 14),
                            ),
                            onPressed: () => _updateRsvpStatus("Confirmed"),
                            child: const Text(
                              'Accept',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF222D52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 14),
                            ),
                            onPressed: () => _updateRsvpStatus("Declined"),
                            child: const Text(
                              'Decline',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
