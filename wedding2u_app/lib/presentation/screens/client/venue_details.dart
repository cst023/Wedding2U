import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedding2u_app/application/venue_booking_controller.dart';

class VenueDetails extends StatefulWidget {
  final String venueId; // ID of the venue to fetch details for

  const VenueDetails({super.key, required this.venueId});

  @override
  _VenueDetailsState createState() => _VenueDetailsState();
}

class _VenueDetailsState extends State<VenueDetails> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final VenueBookingController _bookingController = VenueBookingController();
  bool isLoading = true;
  Map<String, dynamic>? venueData;
  DateTime? selectedDate; // Holds the selected date
  bool isBooked = false; // To track if the venue is booked
  String clientId = "";
  @override
  void initState() {
    super.initState();
    _fetchVenueDetails();
    clientId = auth.currentUser!.uid;
    _checkExistingBooking();
  }

  Future<void> _fetchVenueDetails() async {
    setState(() {
      isLoading = true;
    });
    try {
      venueData = await _bookingController.fetchVenueDetails(widget.venueId);
      if (venueData == null) {
        throw Exception('Venue not found');
      }
    } catch (e) {
      _showMessage('Error fetching venue details: $e', Colors.red);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _checkExistingBooking() async {
    try {
      QuerySnapshot bookingSnapshot = await _firestore
          .collection('bookings')
          .where('client_id', isEqualTo: clientId)
          .where('venue_id', isEqualTo: widget.venueId)
          .get();

      if (bookingSnapshot.docs.isNotEmpty) {
        setState(() {
          isBooked = true; // Client has already booked this venue
        });
      }
    } catch (e) {
      print('Error checking existing booking: $e');
    }
  }

  void _showMessage(String message, Color color) {
    //todo: investigate how to use this method
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleBooking() async {
    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a date before booking."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _bookingController.createBooking(
        bookingDate:
            "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
        clientId: clientId,
        venueId: widget.venueId,
        venueName: venueData!['name'],
        requestDate: DateTime.now(),
        status: "Pending", // Default status for new bookings
      );

      setState(() {
        isBooked = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text("Venue booking request sent. Waiting for confirmation."),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create booking: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Venue Details',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold, // Makes the text bold
          ),
        ),
        backgroundColor: const Color(0xFFf7706d),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 226, 226, 226)),
          onPressed: () {
            Navigator.pop(context);
          },
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
          : venueData == null
              ? const Center(child: Text('Venue details not available'))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors
                          .white, // Set the card background color to white
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Venue Image
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12.0)),
                            child: Image.asset(
                              'assets/images/wedding_dais.jpg',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Venue Name and Rating
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  venueData!['name'] ?? 'Unknown',
                                  style: const TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      venueData!['rating'] ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    const Icon(Icons.star,
                                        color: Colors.amber, size: 20.0),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Venue Details
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              venueData!['venue_desc'] ??
                                  'Description not available',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[700]),
                            ),
                          ),

                          const SizedBox(height: 12.0),

                          // Venue Details
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              venueData!['service_included'] ??
                                  'Description not available',
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[700]),
                            ),
                          ),

                          const SizedBox(height: 12.0),

                          Divider(height: 1.0, color: Colors.grey[300]),

                          // Date Picker
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Booking Date',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                GestureDetector(
                                  onTap: () {
                                    _selectDate(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.grey[400]!),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          selectedDate == null
                                              ? 'Choose a date'
                                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.grey[600]),
                                        ),
                                        Icon(Icons.calendar_today,
                                            color: Colors.grey[700]),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12.0),

                          // Book Button
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: isBooked ? null : _handleBooking,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    backgroundColor: isBooked
                                        ? Colors.grey
                                        : const Color(0xFF222D52),
                                  ),
                                  child: Text(
                                    isBooked ? 'Booked' : 'Book Venue',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
