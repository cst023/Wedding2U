import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_edit_portfolio.dart';

class VendorPortfolio extends StatefulWidget {
  @override
  _VendorPortfolioState createState() => _VendorPortfolioState();
}

class _VendorPortfolioState extends State<VendorPortfolio> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Your portfolio',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section with Image and Profile
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background Image
                Container(
                  height: 110,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/vendor_role_images/background_photo.jpg'), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Circular Profile Image
                Positioned(
                  bottom: -50,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: AssetImage('assets/vendor_images/gerry.jpg'), 
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
            // Profile Name and Description
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
                  SizedBox(height: 4),
                  Text(
                    'Professional Photographer',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '📍 Sarawak, Malaysia',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Social Media Icons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt, size: 30),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.facebook, size: 30),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.link, size: 30),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.email, size: 30),
                ),
              ],
            ),
            const SizedBox(height: 7),
            // Edit Portfolio Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditPortfolio()),
                          );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 20),
                label: const Text('Edit Portfolio'),
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 5),
            Container(
              height: 120,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: AssetImage('assets/vendor_images/wedding1.jpg'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Description Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "I'm a wedding photographer based in Kuching, dedicated to capturing the beauty and joy of your special day. With a focus on candid moments and heartfelt storytelling, I aim to create timeless images that reflect your unique love story. Let's make unforgettable memories together!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Projects Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Projects',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                ProjectCard(
                  imagePath: 'assets/vendor_images/project1.jpg', 
                  title: 'Amir & Aisyah | Hilton',
                ),
                ProjectCard(
                  imagePath: 'assets/vendor_images/project2.jpg', 
                  title: 'Iswan & Nurin | Cove55',
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const ProjectCard({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 150,
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
