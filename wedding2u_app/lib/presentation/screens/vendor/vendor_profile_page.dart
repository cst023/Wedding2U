import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding2u_app/application/user_profile_controller.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_edit_profile.dart';

class VendorProfilePage extends StatefulWidget {
  const VendorProfilePage({super.key});

  @override
  _VendorProfilePageState createState() => _VendorProfilePageState();
}

class _VendorProfilePageState extends State<VendorProfilePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserProfileController _profileController = UserProfileController();

  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      String uid = auth.currentUser!.uid; // Get current user's UID
      Map<String, dynamic> data = await _profileController.getUserData(uid);
      setState(() {
        userData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : userData == null
                ? const Center(child: Text('Failed to load profile data'))
                : SafeArea(
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Space between elements
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile cover image
                      Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            height: 200,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/vendor_role_images/background_photo.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -50, // Adjust positioning
                            child: CircleAvatar(
                              radius: 60,
                              backgroundImage: const AssetImage(
                                  'assets/vendor_images/gerry.jpg'),
                              backgroundColor:
                                  Colors.grey[200], // Fallback color
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height:
                              60), // Space to account for profile picture overlap

                      // Name
                      Text(
                                  userData!['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                      const SizedBox(height: 8),

                      // Location
                       Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      userData!['country'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),

                      const SizedBox(height: 20),

                      // Social media icons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // TODO: Link to Instagram
                              print('Instagram clicked');
                            },
                            child: Image.asset(
                              'assets/images/ig_icon.jpg', // Replace with your IG image path
                              height: 40,
                              width: 40,
                            ),
                          ),
                          const SizedBox(width: 20), // Add spacing between images
                          GestureDetector(
                            onTap: () {
                              // TODO: Link to Facebook
                              print('Facebook clicked');
                            },
                            child: Image.asset(
                              'assets/images/fb_icon.jpg', // Replace with your Facebook image path
                              height: 40,
                              width: 40,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // TODO: Link to WhatsApp
                              print('WhatsApp clicked');
                            },
                            child: Image.asset(
                              'assets/images/whatsapp_icon.jpg', // Replace with your WhatsApp image path
                              height: 40,
                              width: 40,
                            ),
                          ),
                          const SizedBox(width: 20),
                          GestureDetector(
                            onTap: () {
                              // TODO: Link to X (Twitter)
                              print('X clicked');
                            },
                            child: Image.asset(
                              'assets/images/x_icon.jpg', // Replace with your Twitter image path
                              height: 40,
                              width: 40,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Edit Profile button
                      ElevatedButton(
                        onPressed: () {
                          
                          print('Edit Profile Button Pressed');
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VendorEditProfile()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      const SizedBox(height: 20),

                    ],
                  ),
                ),
              ),

              // Log out text at the bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextButton(
                  onPressed: () {
                    // TODO: Handle log out action
                    auth.signOut();
                    Navigator.pushNamed(context, 'SignIn');
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
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