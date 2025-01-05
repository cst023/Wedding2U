import 'package:flutter/material.dart';
import 'package:wedding2u_app/application/guest_list_controller.dart';

class GuestListScreen extends StatefulWidget {
  final String invitationCode;

  const GuestListScreen({super.key, required this.invitationCode});

  @override
  _GuestListScreenState createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  List<Map<String, String>> guests = [];
  Map<String, int> guestCounts = {
    "All": 0,
    "Confirmed": 0,
    "Declined": 0,
    "Pending": 0,
  };

  final GuestListController _controller = GuestListController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchGuests();
  }

  Future<void> _fetchGuests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch guests using the controller
      final fetchedGuests = await _controller.fetchGuestsByInvitationCode(widget.invitationCode);

      setState(() {
        guests = fetchedGuests;

        // Update guest counts
        guestCounts = {
          "All": guests.length,
          "Confirmed":
              guests.where((g) => g["status"] == "Confirmed").length,
          "Declined":
              guests.where((g) => g["status"] == "Declined").length,
          "Pending":
              guests.where((g) => g["status"] == "Pending").length,
        };
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching guests: $e"),
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
      appBar: AppBar(
        title: const Text("Guests"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            indicatorPadding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.symmetric(horizontal: 5.0),
            tabs: [
              Tab(text: "All (${guestCounts["All"]})"),
              Tab(text: "Confirmed (${guestCounts["Confirmed"]})"),
              Tab(text: "Declined (${guestCounts["Declined"]})"),
              Tab(text: "Pending (${guestCounts["Pending"]})"),
            ],
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildGuestList("All"),
                _buildGuestList("Confirmed"),
                _buildGuestList("Declined"),
                _buildGuestList("Pending"),
              ],
            ),
    );
  }

  Widget _buildGuestList(String filter) {
    List<Map<String, String>> filteredGuests = guests;
    if (filter != "All") {
      filteredGuests =
          guests.where((guest) => guest["status"] == filter).toList();
    }

    if (filteredGuests.isEmpty) {
      return Center(child: Text("No $filter guests"));
    }

    return ListView.builder(
      itemCount: filteredGuests.length,
      itemBuilder: (context, index) {
        final guest = filteredGuests[index];
        return ListTile(
          title: Text(guest["name"] ?? ""),
          subtitle: Text("Phone: ${guest["phone"] ?? ""}"),
          trailing: Text(
            guest["status"] ?? "",
            style: TextStyle(
              color: guest["status"] == "Confirmed"
                  ? Colors.green
                  : guest["status"] == "Declined"
                      ? Colors.red
                      : Colors.orange,
            ),
          ),
        );
      },
    );
  }
}
