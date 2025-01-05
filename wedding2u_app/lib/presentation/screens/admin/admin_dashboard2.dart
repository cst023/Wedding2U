import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/admin/admin_profile_page.dart';
import 'package:wedding2u_app/presentation/screens/admin/booking_list_page.dart';
import 'package:wedding2u_app/presentation/screens/admin/posts_page.dart';
import 'package:wedding2u_app/presentation/screens/admin/venue_catalog.dart';

class AdminDashboard2 extends StatelessWidget {
  const AdminDashboard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Banner (Welcome Message and Profile)
            Container(
              color: Colors.pink.shade100,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Admin Dashboard",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminProfilePage()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 32.0, // Profile picture size
                      backgroundImage:
                          AssetImage('assets/images/profile_avatar.jpg'),
                      backgroundColor: Colors.grey[200], // Fallback color
                    ),
                  )
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
              children: [
                SizedBox(height: 10),
                GestureDetector(
                onTap: () {
                  // Navigation to manage venue catalog
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VenueCatalog()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                    ),
                  ],
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                    "Manage Venue Catalog",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                  ),
                ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                onTap: () {
                  // Navigation to manage venue bookings
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingListPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                    ),
                  ],
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                    "Manage Venue Bookings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                  ),
                ),
                ),
                const SizedBox(height: 16.0),
                GestureDetector(
                onTap: () {
                  // Navigation to moderate review posts
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PostPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                    ),
                  ],
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                    "Moderate Review Posts",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    ),
                    Icon(Icons.arrow_forward_ios),
                  ],
                  ),
                ),
                ),
              ],
              ),
            ),
  ],
  ),
        
      ),
    );
  }
}
