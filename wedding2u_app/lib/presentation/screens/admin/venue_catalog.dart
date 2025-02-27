import 'package:flutter/material.dart';
import 'package:wedding2u_app/data/firestore_service.dart';
import 'package:wedding2u_app/presentation/screens/admin/admin_dashboard2.dart';
import 'package:wedding2u_app/presentation/screens/admin/venue_detail_page.dart';
import 'add_venue_page.dart'; // Add venue page

class VenueCatalog extends StatefulWidget {
  const VenueCatalog({super.key});

  @override
  _VenueCatalogState createState() => _VenueCatalogState();
}

class _VenueCatalogState extends State<VenueCatalog> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> venues = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVenueData();
  }

  Future<void> _fetchVenueData() async {
    try {
      List<Map<String, dynamic>> fetchedVenues =
          await _firestoreService.fetchVenues();
      setState(() {
        venues = fetchedVenues;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching venue data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Venues',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminDashboard2(),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[300],
            height: 1.0,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : venues.isEmpty
              ? const Center(child: Text('No venues available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: venues.length,
                  itemBuilder: (context, index) {
                    final venue = venues[index];
                    return buildVenueCard(
                      context: context,
                      imagePath:
                          'assets/images/wedding_dais.jpg', // Placeholder
                      venueName: venue['name'],
                      venueDetails: venue['venue_desc'],
                      rating: venue['rating'],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VenueDetailPage(venueId: venue['id']),
                          ),
                        );
                      },
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddVenueDetailsScreen(),
            ),
          ).then((_) =>
              _fetchVenueData()); // Refresh data after adding a new venue
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildVenueCard({
    required BuildContext context,
    required String imagePath,
    required String venueName,
    required String venueDetails,
    required String rating,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white, // Set the card background color to white
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Venue Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12.0)),
              child: Image.asset(
                imagePath,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Venue Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Venue Name
                      Text(
                        venueName,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Rating with Star Icon
                      Row(
                        children: [
                          Text(
                            rating, // e.g., '4.5/5'
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20.0,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  // Venue Description
                  Text(
                    venueDetails,
                    style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
