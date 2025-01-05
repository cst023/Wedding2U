import 'package:flutter/material.dart';

class BookingDetailPage extends StatefulWidget {
  final Map<String, String> bookingData;

  BookingDetailPage({required this.bookingData});

  @override
  _BookingDetailPageState createState() => _BookingDetailPageState();
}

class _BookingDetailPageState extends State<BookingDetailPage> {
  @override
  Widget build(BuildContext context) {
    final booking = widget.bookingData;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Client's Name and Request Date
                Text(
                  'Client: ${booking["clientName"] ?? "Unknown"}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Request Date: ${booking["requestDate"] ?? "Unknown"}',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                ),
                SizedBox(height: 16.0),

                // Booking Date
                Text(
                  'Booking Date: ${booking["bookingDate"] ?? "Unknown"}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),

                // Venue Name
                Text(
                  'Venue: ${booking["venueName"] ?? "Unknown"}',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),

                // Booking Status
                Text(
                  'Status: ${booking["status"] ?? "Pending"}',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: booking["status"] == "Approved"
                        ? Colors.green
                        : booking["status"] == "Declined"
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),

                Spacer(),

                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Decline Button
                    ElevatedButton(
                      onPressed: () => _showConfirmationDialog(
                        context,
                        action: "Decline",
                        onConfirm: () {
                          Navigator.pop(context); // Close dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Booking declined successfully!'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                      ),
                      child: Text(
                        'Decline',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    // Approve Button
                    ElevatedButton(
                      onPressed: () => _showConfirmationDialog(
                        context,
                        action: "Approve",
                        onConfirm: () {
                          Navigator.pop(context); // Close dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Booking approved successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 24.0,
                        ),
                      ),
                      child: Text(
                        'Approve',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Confirmation Dialog
  void _showConfirmationDialog(BuildContext context,
      {required String action, required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Booking'),
        content: Text(
            'Are you sure you want to $action this booking? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  action == "Approve" ? Colors.green : Colors.red,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
