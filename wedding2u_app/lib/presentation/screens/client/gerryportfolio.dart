import 'package:flutter/material.dart';

class GerryPortfolioPage extends StatelessWidget {
  const GerryPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Photographers',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/vendor_images/gerry_banner.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50, // Adjust positioning
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: const AssetImage('assets/vendor_images/gerry.jpg'),
                    backgroundColor: Colors.grey[200], // Fallback color
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            const Center(
              child: Column(
                children: [
                  Text(
                    'Gerry Photography',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Professional Photographer',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    '📍 Sarawak, Malaysia',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 10),
                  // Social Media Icons
                  SocialMediaIcons(),
                  SizedBox(height: 10),
                ],
              ),
            ),
            // Contact and Book Buttons
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add Contact functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 219, 148, 171), // Changed to pink
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Contact',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Add Book functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 219, 148, 171), // Changed to pink
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text(
                      'Book',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1),

            // Gallery Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Gallery',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Gallery Image Row with uniform alignment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  galleryImage('assets/vendor_images/wedding1.jpg'),
                  galleryImage('assets/vendor_images/wedding2.jpg'),
                  galleryImage('assets/vendor_images/wedding3.jpg'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Description Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Text(
                "I'm a wedding photographer based in Kuching, dedicated to capturing the beauty and joy of your special day. With a focus on candid moments and heartfelt storytelling, I aim to create timeless images that reflect your unique love story. Let's make unforgettable memories together!",
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
            ),

            // Projects Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Projects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Project Image Row with uniform alignment
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  projectCard(
                    imagePath: 'assets/vendor_images/project1.jpg',
                    title: 'Amir & Aisyah | Hilton',
                  ),
                  projectCard(
                    imagePath: 'assets/vendor_images/project2.jpg',
                    title: 'Irswan & Nurin | Cove55',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget for a single gallery image
  Widget galleryImage(String imagePath) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: 120,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget for a single project card
  static Widget projectCard({required String imagePath, required String title}) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      width: 150,
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(imagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// Social Media Icons Row
class SocialMediaIcons extends StatelessWidget {
  const SocialMediaIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.camera_alt_outlined, size: 30),
        SizedBox(width: 16),
        Icon(Icons.facebook_outlined, size: 30),
        SizedBox(width: 16),
        Icon(Icons.chat_outlined, size: 30),
        SizedBox(width: 16),
        Icon(Icons.share, size: 30),
      ],
    );
  }
}
