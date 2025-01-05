import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/admin/admin_profile_page.dart';
import 'package:wedding2u_app/presentation/screens/admin/posts_page.dart';
import 'package:wedding2u_app/presentation/screens/admin/venue_catalog.dart';

class AdminDashboard extends StatefulWidget {
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner
                Container(
                  width: double.infinity, // Full width of the screen
                  decoration: BoxDecoration(
                    color: Colors.pink[100],
                    borderRadius: BorderRadius.circular(0),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Text Widgets
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi Admin!',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Let's prepare some wedding!",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Image
                      Image.asset(
                        'assets/images/wedding_rings.png',
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ),

                // Padding for the rest of the elements
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Search bar widget
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                hintText: 'Search...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: 16.0),

                          // Clickable image for the profile picture
                          GestureDetector(
                            onTap: () {
                    
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminProfilePage(),
                                ),
                              );
                            },
                            child: CircleAvatar(
                              radius: 32.0, // Profile picture size
                              backgroundImage: AssetImage(
                                  'assets/images/profile_image_men.jpg'),
                              backgroundColor:
                                  Colors.grey[200], // Fallback color
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20),
                      // Scrollable Row of Clickable Images with Borders
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Action for the first image
                                print("venue clicked");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VenueCatalog()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Border color
                                    width: 1, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      2), // Rounded corners
                                ),
                                child: Image.asset(
                                  'assets/images/venues2_icon.jpg',
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16), // Space between images

                            GestureDetector(
                              onTap: () {
                                // Action for the second image
                                print("posts clicked");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostPage()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Border color
                                    width: 1, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      2), // Rounded corners
                                ),
                                child: Image.asset(
                                  'assets/images/posts2_icon.jpg',
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 16), // Space between images

                            GestureDetector(
                              onTap: () {
                                // Action for the third image
                                print("vendors clicked");
                                //TODO: Add navigation
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Border color
                                    width: 1, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      2), // Rounded corners
                                ),
                                child: Image.asset(
                                  'assets/images/vendors2_icon.jpg',
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20.0),

                      Text('Manage My Wedding',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),

                      SizedBox(height: 20.0),

                      // Rectangular Clickable Image
                      GestureDetector(
                        onTap: () {
                          // TODO: Go to My Wedding Page
                          //TODO: Add navigation
                          print('Rectangular image clicked');
                          /*
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BookingListPage()),
                          );*/
                        },
                        child: Container(
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.pink[50],
                            image: DecorationImage(
                              image:
                                  AssetImage('assets/images/wedding_dais.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),

                      Text('Customer Reviews',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),

                      SizedBox(height: 20.0),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                //TODO: Add navigation
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostPage()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Border color
                                    width: 1, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                ),
                                child: Image.asset(
                                  'assets/post_images/javier1.jpg',
                                  width: 190,
                                  height: 190,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(width: 20), // Space between images

                            GestureDetector(
                              onTap: () {
                                //TODO: Add navigation
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PostPage()),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey, // Border color
                                    width: 1, // Border width
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      8), // Rounded corners
                                ),
                                child: Image.asset(
                                  'assets/post_images/azeleen1.jpg',
                                  width: 190,
                                  height: 190,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
