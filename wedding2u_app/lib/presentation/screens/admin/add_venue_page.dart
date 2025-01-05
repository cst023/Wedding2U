import 'package:flutter/material.dart';
import 'package:wedding2u_app/data/firestore_service.dart';

class AddVenueDetailsScreen extends StatefulWidget {
  @override
  _AddVenueDetailsScreenState createState() => _AddVenueDetailsScreenState();
}

class _AddVenueDetailsScreenState extends State<AddVenueDetailsScreen> {
  final TextEditingController _venueNameController = TextEditingController();
  final TextEditingController _venueDescriptionController = TextEditingController();
  final TextEditingController _packageDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSaving = false;

  void _saveVenue() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSaving = true;
      });

      try {
        await _firestoreService.addVenue(
          name: _venueNameController.text.trim(),
          venueDesc: _venueDescriptionController.text.trim(),
          serviceIncluded: _packageDescriptionController.text.trim(),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Venue added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context); // Go back to the previous screen after saving.
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding venue: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Venue',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter Venue Details', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16.0),
              Text('Venue Name:', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _venueNameController,
                decoration: InputDecoration(
                  labelText: 'Venue Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a venue name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              Text('Venue Description:', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _venueDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Venue Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a venue description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              Text('Package Description:', style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 8.0),
              TextFormField(
                controller: _packageDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Package Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a package description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveVenue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[400],
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: _isSaving
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Save',
                          style: TextStyle(fontSize: 16.0, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

