import 'package:flutter/material.dart';

class ClientMainPage extends StatefulWidget {
  @override
  _ClientMainPageState createState() => _ClientMainPageState();
}

class _ClientMainPageState extends State<ClientMainPage> {
  
  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;    
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
                              'Hi, ${userData['name']}!',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              "Let's prepare for your wedding!",
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
                              Navigator.pushNamed(context, 'ClientProfilePage');
                            },
                            child: CircleAvatar(
                              radius: 32.0, // Profile picture size
                              backgroundImage: AssetImage(
                                  'assets/images/profile_avatar.jpg'),
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
                                Navigator.pushNamed(context, 'VenueCatalog');
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
                                Navigator.pushNamed(context, 'WeddingPosts');
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
                                Navigator.pushNamed(context, 'VendorCatalog');
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
                          Navigator.pushNamed(context, 'ManageWedding');
                          print('Rectangular image clicked');
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
                                Navigator.pushNamed(context, 'WeddingPosts');
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
                                Navigator.pushNamed(context, 'WeddingPosts');
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


