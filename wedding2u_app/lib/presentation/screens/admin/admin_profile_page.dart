import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedding2u_app/application/user_profile_controller.dart';
import 'package:wedding2u_app/presentation/screens/admin/admin_dashboard.dart';
import 'package:wedding2u_app/presentation/screens/admin/admin_dashboard2.dart';
import 'package:wedding2u_app/presentation/screens/admin/admin_edit_profile.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
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
          title: Text('Profile'),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminDashboard2()));
            },
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : userData == null
                ? Center(child: Text('Failed to load profile data'))
                : SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/profile_cover.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -50,
                                      child: CircleAvatar(
                                        radius: 60,
                                        backgroundImage: AssetImage(
                                            'assets/images/profile_avatar.jpg'),
                                        backgroundColor: Colors.grey[200],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 60),

                                // Name
                                Text(
                                  userData!['name'] ?? '',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),

                                // Location
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      userData!['country'] ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Social media icons row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Link to Instagram as saved in the user's data
                                        // userData['instagram'] if available, go to that link, if not, show message saying url not available
                                        print('Instagram clicked');
                                      },
                                      child: Image.asset(
                                        'assets/images/ig_icon.jpg',
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            20), // Add spacing between images
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Link to Facebook
                                        print('Facebook clicked');
                                      },
                                      child: Image.asset(
                                        'assets/images/fb_icon.jpg',
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Link to WhatsApp
                                        print('WhatsApp clicked');
                                      },
                                      child: Image.asset(
                                        'assets/images/whatsapp_icon.jpg',
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                      onTap: () {
                                        // TODO: Link to X (Twitter)
                                        print('X clicked');
                                      },
                                      child: Image.asset(
                                        'assets/images/x_icon.jpg',
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Edit Profile button
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AdminEditProfile(),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.pink[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    'Edit Profile',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),

                        // Log out button
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextButton(
                            onPressed: () {
                              auth.signOut();
                              Navigator.pushNamed(context, 'SignIn');
                            },
                            child: Text(
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
