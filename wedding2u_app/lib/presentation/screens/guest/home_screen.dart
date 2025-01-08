import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wedding2u_app/data/firestore_service.dart';
import 'guest_list_screen.dart';
import 'tentative_screen.dart';
import 'countdown_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  final String invitationCode;

  const HomeScreen({super.key, required this.invitationCode});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Map<String, dynamic>> _weddingPlanFuture;

  @override
  void initState() {
    super.initState();
    _weddingPlanFuture =
        FirestoreService().getWeddingPlanDetails(widget.invitationCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guest Home')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _weddingPlanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text("Wedding plan not found."),
            );
          }

          final weddingPlan = snapshot.data!;
          final weddingCouple = weddingPlan['wedding_couple'] ?? "Couple";
          final weddingVenue = weddingPlan['wedding_venue'] ?? "Venue";
          final countdownDate = weddingPlan['countdown_date'] != null
              ? (weddingPlan['countdown_date'] as Timestamp).toDate()
              : DateTime.now();
          final formattedDate = DateFormat('d MMMM yyyy').format(countdownDate);

          return Column(
            children: [
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  'assets/guest_images/wedding.jpg',
                  width: 300,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                weddingCouple, // Dynamic wedding couple name
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFf7706d),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$formattedDate\n$weddingVenue', // Dynamic wedding date and venue
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    buildCard(
                      icon: Icons.people,
                      title: 'Guest List',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GuestListScreen(
                                invitationCode: widget.invitationCode)),
                      ),
                    ),
                    buildCard(
                      icon: Icons.event,
                      title: 'Wedding Tentative',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TentativeScreen(
                                invitationCode: widget.invitationCode)),
                      ),
                    ),
                    buildCard(
                      icon: Icons.timer,
                      title: 'Countdown',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CountdownScreen(
                                invitationCode: widget.invitationCode)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFf7706d)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFf7706d)),
        onTap: onTap,
      ),
    );
  }
}
