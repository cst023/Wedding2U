import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding2u_app/application/user_profile_controller.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_profile_page.dart';

class VendorEditProfile extends StatefulWidget {
  const VendorEditProfile({super.key});

  @override
  _VendorEditProfileState createState() => _VendorEditProfileState();
}

class _VendorEditProfileState extends State<VendorEditProfile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserProfileController _profileController = UserProfileController();
  late String uid;

  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  late TextEditingController _countryController;
  late TextEditingController _instagramController;
  late TextEditingController _facebookController;
  late TextEditingController _whatsAppController;
  late TextEditingController _twitterController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    uid = auth.currentUser!.uid;
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dobController = TextEditingController();
    _countryController = TextEditingController();
    _instagramController = TextEditingController();
    _facebookController = TextEditingController();
    _whatsAppController = TextEditingController();
    _twitterController = TextEditingController();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      Map<String, dynamic> userData = await _profileController.getUserData(uid);

      setState(() {
        _nameController = TextEditingController(text: userData['name']);
        _emailController = TextEditingController(text: userData['email']);
        _phoneController = TextEditingController(text: userData['phoneNumber']);
        _dobController = TextEditingController(text: userData['dob']);
        _countryController = TextEditingController(text: userData['country']);
        _instagramController =
            TextEditingController(text: userData['instagram']);
        _facebookController = TextEditingController(text: userData['facebook']);
        _whatsAppController = TextEditingController(text: userData['whatsapp']);
        _twitterController = TextEditingController(text: userData['twitter']);
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors
      print(e);
    }
  }

  Future<void> _saveChanges() async {
    Map<String, dynamic> updatedData = {
      'name': _nameController.text,
      'phoneNumber': _phoneController.text,
      'dob': _dobController.text,
      'country': _countryController.text,
      'instagram': _instagramController.text,
      'facebook': _facebookController.text,
      'whatsapp': _whatsAppController.text,
      'twitter': _twitterController.text,
    };

    try {
      await _profileController.updateUserData(uid, updatedData);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VendorProfilePage()),
      );
    } catch (e) {
      // Handle errors
      print(e);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _countryController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    _whatsAppController.dispose();
    _twitterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator()) // Show loading spinner
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile Picture Section
                    Center(
                      child: Stack(
                        children: [
                          // Profile Picture
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: const AssetImage(
                                'assets/vendor_images/gerry.jpg'),
                            backgroundColor: Colors.grey[300],
                          ),
                          // Camera Icon Overlay
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.pink[300],
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // Input Fields with Sample Data
                    buildTextField(
                      controller: _nameController,
                      label: 'Name',
                      hintText: 'Enter your name',
                    ),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      isReadOnly: true, // Assuming email is non-editable
                    ),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      hintText: 'Enter your phone number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      controller: _dobController,
                      label: 'Date of Birth',
                      hintText: 'DD/MM/YYYY',
                      keyboardType: TextInputType.datetime,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dobController.text =
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      controller: _countryController,
                      label: 'Country/Region',
                      hintText: 'Enter your country/region',
                    ),

                    const SizedBox(height: 30.0),

                    // Social Media Section
                    const Text(
                      'Social Media Links',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      controller: _instagramController,
                      label: 'Instagram',
                      hintText: 'Enter your Instagram profile URL',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      controller: _facebookController,
                      label: 'Facebook',
                      hintText: 'Enter your Facebook profile URL',
                      keyboardType: TextInputType.url,
                    ),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      controller: _whatsAppController,
                      label: 'WhatsApp',
                      hintText: 'Enter your WhatsApp number',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16.0),
                    buildTextField(
                      controller: _twitterController,
                      label: 'X (Twitter)',
                      hintText: 'Enter your Twitter profile URL',
                      keyboardType: TextInputType.url,
                    ),

                    const SizedBox(height: 30.0),

                    // Save Changes Button
                    ElevatedButton(
                      onPressed: () {
                        _saveChanges();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[200],
                        foregroundColor:
                            Colors.white, // Set text color to white
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  // Helper method for creating input fields
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: isReadOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
