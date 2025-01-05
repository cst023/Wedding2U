import 'package:flutter/material.dart';
import 'package:wedding2u_app/data/firestore_service.dart';
import 'package:wedding2u_app/presentation/screens/admin/venue_catalog.dart';

class VenueDetailPage extends StatefulWidget {
  final String venueId; // ID of the venue to fetch details for

  const VenueDetailPage({super.key, required this.venueId});

  @override
  _VenueDetailPageState createState() => _VenueDetailPageState();
}

class _VenueDetailPageState extends State<VenueDetailPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool isLoading = true;
  bool isEditing = false;
  Map<String, dynamic>? venueData;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController venueDescController = TextEditingController();
  final TextEditingController packageDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchVenueDetails();
  }

  Future<void> _fetchVenueDetails() async {
    try {
      Map<String, dynamic>? fetchedVenue =
          await _firestoreService.fetchVenueById(widget.venueId);

      setState(() {
        venueData = fetchedVenue;
        isLoading = false;

        // Populate the controllers with fetched data
        nameController.text = venueData?['name'] ?? '';
        venueDescController.text = venueData?['venue_desc'] ?? '';
        packageDescController.text = venueData?['service_included'] ?? '';
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching venue details: $e');
    }
  }

  Future<void> _saveChanges() async {
    if (nameController.text.isEmpty ||
        venueDescController.text.isEmpty ||
        packageDescController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (nameController.text == venueData!['name'] &&
        venueDescController.text == venueData!['venue_desc'] &&
        packageDescController.text == venueData!['service_included']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes to save.'),
        ),
      );
      setState(() {
        isEditing = false;
      });
      return;
    }

    try {
      await _firestoreService.updateVenue(
        widget.venueId,
        {
          'name': nameController.text,
          'venue_desc': venueDescController.text,
          'service_included': packageDescController.text,
        },
      );

      setState(() {
        isEditing = false;
        venueData = {
          'name': nameController.text,
          'venue_desc': venueDescController.text,
          'service_included': packageDescController.text,
        };
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Venue details updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error updating venue: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error updating venue details.'),
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
          'Venue Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VenueCatalog(),
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
          : venueData == null
              ? const Center(child: Text('Venue details not available'))
              : SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
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

                            // Editable Fields
                            const SizedBox(height: 16.0),
                            isEditing
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name
                                      const Text(
                                        'Venue Name',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(height: 8.0),
                                      TextField(
                                        controller: nameController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Enter Venue Name',
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),

                                      // Venue Description
                                      const Text(
                                        'Venue Description',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(height: 8.0),
                                      TextField(
                                        controller: venueDescController,
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Enter Venue Description',
                                        ),
                                      ),
                                      const SizedBox(height: 16.0),

                                      // Package Description
                                      const Text(
                                        'Package Description',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(height: 8.0),
                                      TextField(
                                        controller: packageDescController,
                                        maxLines: 3,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText:
                                              'Enter Package Description',
                                        ),
                                      ),
                                      const SizedBox(height: 26.0),

                                      // Buttons
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () async {
                                              final confirmDelete =
                                                  await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text('Delete Venue'),
                                                  content: const Text(
                                                      'Are you sure you want to delete this venue?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child: const Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.red),
                                                      child: const Text('Delete'),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirmDelete == true) {
                                                try {
                                                  await _firestoreService
                                                      .deleteVenue(
                                                          widget.venueId);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Venue deleted successfully!'),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const VenueCatalog(),
                                                    ),
                                                  ); // Go back after deletion
                                                } catch (e) {
                                                  print(
                                                      'Error deleting venue: $e');
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          'Error deleting venue.'),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                  horizontal: 24.0),
                                            ),
                                            child: const Text(
                                              'Delete Venue',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: _saveChanges,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green,
                                              padding: const EdgeInsets.symmetric(
                                                  vertical: 12.0,
                                                  horizontal: 24.0),
                                            ),
                                            child: const Text(
                                              'Save Changes',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            isEditing = false;
                                            // Reset the controllers to original data
                                            nameController.text =
                                                venueData!['name'] ?? '';
                                            venueDescController.text =
                                                venueData!['venue_desc'] ?? '';
                                            packageDescController.text =
                                                venueData![
                                                        'service_included'] ??
                                                    '';
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[500],
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 24.0),
                                        ),
                                        child: const Text(
                                          'Cancel' ,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Name
                                      Text(
                                        venueData!['name'] ?? 'Unknown',
                                        style: const TextStyle(
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),

                                      // Venue Description
                                      Text(
                                        venueData!['venue_desc'] ??
                                            'Description not available',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 8.0),

                                      // Package Description
                                      Text(
                                        venueData!['service_included'] ??
                                            'Description not available',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),

                            // Edit Button
                            const SizedBox(height: 24.0),
                            if (!isEditing)
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isEditing = true;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink[400],
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12.0, horizontal: 24.0),
                                  ),
                                  child: const Text(
                                    'Edit Venue Details',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
