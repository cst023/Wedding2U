import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_chat_list.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_manage_service_request.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_notification.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_portfolio.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_profile_page.dart';

class VendorDashboard extends StatelessWidget {
  const VendorDashboard({super.key});

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
              color: const Color(0xFFf7706d),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 30,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Vendor Dashboard",
                        style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const VendorNotification()),
                          );
                        },
                        icon: const Icon(
                          Icons.notifications_none,
                          size: 28,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatList()),
                          );
                        },
                        icon: const Icon(
                          Icons.chat_bubble_outline,
                          size: 28,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const VendorProfilePage()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 32.0, // Profile picture size
                          backgroundImage: const AssetImage(
                              'assets/vendor_images/gerry.jpg'),
                          backgroundColor: Colors.grey[200], // Fallback color
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            // Manage Portfolio Box
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const VendorPortfolio()),
                        );
                      },
                      child: Container(
                        child: Image.asset(
                          'assets/vendor_role_images/manage_portfolio.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ManageServiceRequest()),
                        );
                      },
                      child: Container(
                        child: Image.asset(
                          'assets/vendor_role_images/manage_service.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
