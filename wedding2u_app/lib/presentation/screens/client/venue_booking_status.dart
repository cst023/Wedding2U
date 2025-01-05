import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/venue_booking_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VenueBookingStatus extends StatefulWidget {
  const VenueBookingStatus({super.key});

  @override
  _VenueBookingStatusState createState() => _VenueBookingStatusState();
}

class _VenueBookingStatusState extends State<VenueBookingStatus> {
  final VenueBookingController _bookingController = VenueBookingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = true;
  List<Map<String, dynamic>> _bookings = [];

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    try {
      final clientId = _auth.currentUser!.uid;
      List<Map<String, dynamic>> bookings =
          await _bookingController.getClientBookings(clientId);

      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching bookings: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Venue Booking Status',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookings.isEmpty
              ? const Center(child: Text('No bookings found'))
              : SafeArea(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _bookings.length,
                    itemBuilder: (context, index) {
                      final booking = _bookings[index];
                      return _buildBookingCard(booking);
                    },
                  ),
                ),
    );
  }

Widget _buildBookingCard(Map<String, dynamic> booking) {
  final statusColor =
      booking['status'] == 'Approved' ? Colors.green : Colors.orange;

  // Format the request_date (Timestamp to readable date)
  String formattedRequestDate = '';
  if (booking['request_date'] is Timestamp) {
    DateTime requestDate = (booking['request_date'] as Timestamp).toDate();
    formattedRequestDate = DateFormat('dd/MM/yyyy').format(requestDate);
  }

  return Card(
    elevation: 3.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    margin: const EdgeInsets.only(bottom: 16.0),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Venue Name
          Text(
            booking['venue_name'] ?? 'Unknown Venue',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),

          // Booking Date
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.grey[600], size: 16.0),
              const SizedBox(width: 8.0),
              Text(
                'Booking Date: ${booking['booking_date']}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Booking Status
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.grey[600], size: 16.0),
              const SizedBox(width: 8.0),
              Text(
                'Status: ${booking['status']}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),

          // Request Date
          Text(
            'Request Date: $formattedRequestDate',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16.0),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              booking['status'] == 'Pending'
                  ? ElevatedButton(
                      onPressed: () => _showCancelConfirmation(booking),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Cancel Booking',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'ManageWedding');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Go to Wedding Plan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ],
      ),
    ),
  );
}

// Show Confirmation Dialog for Cancel Booking
void _showCancelConfirmation(Map<String, dynamic> booking) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Cancel Booking'),
      content: const Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context); // Close the dialog
            try {
              // Call the controller method to delete the booking
              await _bookingController.deleteBooking(booking['id']);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking canceled successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              _fetchBookings(); // Refresh the booking list
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error canceling booking: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Yes, Cancel'),
        ),
      ],
    ),
  );
}


}
