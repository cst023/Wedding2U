import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/venue_booking_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  _BookingListPageState createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> bookings = []; // Example data structure
  List<Map<String, dynamic>> filteredBookings = [];
  Map<String, int> bookingCounts = {
    "All": 0,
    "Pending": 0,
    "Approved": 0,
    "Declined": 0,
  };
  bool _isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Map<String, dynamic>> fetchedBookings =
          await VenueBookingController().fetchAllBookingsWithClientNames();

      setState(() {
        bookings = fetchedBookings.map((booking) {
          // Format the request_date
          final Timestamp? requestTimestamp = booking['requestDate'];
          final String formattedRequestDate = requestTimestamp != null
              ? DateFormat('dd/MM/yyyy').format(requestTimestamp.toDate())
              : 'Unknown';

          return {
            'id': booking['id'],
            'clientName': booking['clientName'],
            'venueName': booking['venueName'],
            'bookingDate': booking['bookingDate'],
            'requestDate': formattedRequestDate, // Use formatted date
            'status': booking['status'],
          };
        }).toList();

        filteredBookings = bookings;
        _updateBookingCounts();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching bookings: $e");
    }
  }

  void _filterBookings(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredBookings = bookings.where((booking) {
        final clientName = booking['clientName']?.toLowerCase() ?? '';
        final venueName = booking['venueName']?.toLowerCase() ?? '';
        return clientName.contains(searchQuery) ||
            venueName.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Manage Venue Bookings"),
        bottom: TabBar(
          controller: _tabController,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
          tabs: [
            Tab(text: "All (${bookingCounts["All"]})"),
            Tab(text: "Pending (${bookingCounts["Pending"]})"),
            Tab(text: "Approved (${bookingCounts["Approved"]})"),
            Tab(text: "Declined (${bookingCounts["Declined"]})"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterBookings,
              decoration: InputDecoration(
                hintText: "Search by client name or venue...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // Booking List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBookingList("All"),
                      _buildBookingList("Pending"),
                      _buildBookingList("Approved"),
                      _buildBookingList("Declined"),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList(String filter) {
    List<Map<String, dynamic>> currentList = filteredBookings;
    if (filter != "All") {
      currentList =
          filteredBookings.where((b) => b["status"] == filter).toList();
    }

    if (currentList.isEmpty) {
      return Center(child: Text("No $filter bookings found"));
    }

    return ListView.builder(
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        final booking = currentList[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            title: Text(booking["clientName"] ?? ""),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Venue: ${booking["venueName"] ?? ""}"),
                Text("Date: ${booking["bookingDate"] ?? ""}"),
              ],
            ),
            trailing: Text(
              booking["status"] ?? "",
              style: TextStyle(
                color: booking["status"] == "Approved"
                    ? Colors.green
                    : booking["status"] == "Declined"
                        ? Colors.red
                        : Colors.orange,
              ),
            ),
            onTap: () => _showBookingDetails(context, booking),
          ),
        );
      },
    );
  }

  void _showBookingDetails(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Booking Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${booking["clientName"]}",
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222D52))),
              const SizedBox(height: 8.0),
              Text("Request Date: ${booking["requestDate"]}"),
              const SizedBox(height: 8.0),
              Text("Booking Date: ${booking["bookingDate"]}"),
              const SizedBox(height: 8.0),
              Text("Venue: ${booking["venueName"]}"),
              const SizedBox(height: 8.0),
              Text("Status: ${booking["status"]}"),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _showConfirmationDialog(
                    context,
                    action: "Decline",
                    onConfirm: () async {
                      try {
                        await VenueBookingController().updateBookingStatus(
                          booking["id"],
                          "Declined",
                        );
                        setState(() {
                          booking["status"] = "Declined";
                          _updateBookingCounts(); // Recalculate counts
                        });
                        Navigator.pop(context); // Close dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking declined successfully!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(context); // Close dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error declining booking: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Decline",
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () => _showConfirmationDialog(
                    context,
                    action: "Approve",
                    onConfirm: () async {
                      try {
                        await VenueBookingController().updateBookingStatus(
                          booking["id"],
                          "Approved",
                        );
                        setState(() {
                          booking["status"] = "Approved";
                          _updateBookingCounts(); // Recalculate counts
                        });
                        Navigator.pop(context); // Close dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking approved successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        Navigator.pop(context); // Close dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error approving booking: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Approve",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _updateBookingCounts() {
    setState(() {
      bookingCounts = {
        "All": bookings.length,
        "Pending": bookings.where((b) => b["status"] == "Pending").length,
        "Approved": bookings.where((b) => b["status"] == "Approved").length,
        "Declined": bookings.where((b) => b["status"] == "Declined").length,
      };
    });
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: action == "Approve" ? Colors.green : Colors.red,
            ),
            child: Text(action),
          ),
        ],
      ),
    );
  }
}
