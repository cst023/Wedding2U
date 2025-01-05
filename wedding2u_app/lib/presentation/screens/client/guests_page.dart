import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding2u_app/application/guest_list_controller.dart';

class GuestsPage extends StatefulWidget {
  const GuestsPage({super.key});

  @override
  _GuestsPageState createState() => _GuestsPageState();
}

class _GuestsPageState extends State<GuestsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock guest list
  List<Map<String, String>> guests = [];
  String invitationCode = "WED-5678"; // Example invitation code
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchGuests();
  }

  Map<String, int> guestCounts = {
    "All": 0,
    "Confirmed": 0,
    "Declined": 0,
    "Pending": 0,
  };

  Future<void> _fetchGuests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = GuestListController();
      final clientId = _auth.currentUser!.uid;
      final fetchedGuests = await controller.fetchGuests(clientId);

      setState(() {
        guests = fetchedGuests.map((guest) {
          return {
            "id": guest['id']?.toString() ?? '',
            "name": guest['guest_name']?.toString() ?? '',
            "phone": guest['guest_phone']?.toString() ?? '',
            "status": guest['rsvp_status']?.toString() ?? '',
          };
        }).toList();

        // Update guest counts
        guestCounts = {
          "All": guests.length,
          "Confirmed": guests.where((g) => g["status"] == "Confirmed").length,
          "Declined": guests.where((g) => g["status"] == "Declined").length,
          "Pending": guests.where((g) => g["status"] == "Pending").length,
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

  void _addGuest() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Guest"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Guest Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    final controller = GuestListController();
                    final clientId = _auth.currentUser!.uid;

                    await controller.addGuest(
                      clientId: clientId,
                      guestName: nameController.text,
                      guestPhone: phoneController.text,
                      rsvpStatus: "Pending",
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Guest added successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context);
                    _fetchGuests(); // Refresh the guest list
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error adding guest: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter all required fields."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _editGuest(Map<String, String> guest) {
    final TextEditingController nameController =
        TextEditingController(text: guest["name"]);
    final TextEditingController phoneController =
        TextEditingController(text: guest["phone"]);
    final String guestId = guest["id"]!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Guest"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Guest Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  setState(() {
                    _isLoading = true;
                  });

                  try {
                    final controller = GuestListController();
                    final clientId = _auth.currentUser!.uid;

                    await controller.updateGuest(
                      clientId: clientId,
                      guestId: guestId,
                      guestName: nameController.text,
                      guestPhone: phoneController.text,
                      rsvpStatus: guest["status"]!,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Guest updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context);
                    _fetchGuests(); // Refresh the guest list
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error updating guest: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter all required fields."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _deleteGuest(String guestId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = GuestListController();
      final clientId = _auth.currentUser!.uid;

      await controller.deleteGuest(clientId: clientId, guestId: guestId);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Guest deleted successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      _fetchGuests(); // Refresh the guest list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting guest: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showInvitationCode() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final controller = GuestListController();
      final clientId = _auth.currentUser!.uid;

      // Fetch the invitation code
      final fetchedCode = await controller.fetchInvitationCode(clientId);

      setState(() {
        invitationCode = fetchedCode ?? "Code unavailable. Please set your wedding countdown to obtain code.";
      });

      // Show the dialog with the invitation code
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Invitation Code"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  invitationCode,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: invitationCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Code copied to clipboard!")),
                    );
                  },
                  child: const Text("Copy Code"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error fetching invitation code: $e"),
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
            //isScrollable: true,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _addGuest,
              child: const Row(
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text("Add Guest"),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _showInvitationCode,
              child: const Row(
                children: [
                  Icon(Icons.share),
                  SizedBox(width: 8),
                  Text("Invite Your Guests"),
                ],
              ),
            ),
          ],
        ),
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
          onTap: () => _showEditGuestDialog(guest),
        );
      },
    );
  }

  void _showEditGuestDialog(Map<String, String> guest) {
    final TextEditingController nameController =
        TextEditingController(text: guest["name"]);
    final TextEditingController phoneController =
        TextEditingController(text: guest["phone"]);
    final String guestId = guest["id"]!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Guest"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Guest Name"),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  "Delete Guest",
                  style: TextStyle(color: Colors.red),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close the dialog first
                  _deleteGuest(guestId);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  try {
                    final controller = GuestListController();
                    final clientId = _auth.currentUser!.uid;

                    await controller.updateGuest(
                      clientId: clientId,
                      guestId: guestId,
                      guestName: nameController.text,
                      guestPhone: phoneController.text,
                      rsvpStatus: guest["status"]!, // Preserve RSVP status
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Guest updated successfully!"),
                        backgroundColor: Colors.green,
                      ),
                    );

                    Navigator.pop(context);
                    _fetchGuests(); // Refresh the guest list
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error updating guest: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter all required fields."),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
