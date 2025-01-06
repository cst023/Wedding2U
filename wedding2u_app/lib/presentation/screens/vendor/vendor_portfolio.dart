import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_edit_portfolio.dart';

class VendorPortfolio extends StatefulWidget {
  const VendorPortfolio({super.key});

  @override
  _VendorPortfolioState createState() => _VendorPortfolioState();
}

class _VendorPortfolioState extends State<VendorPortfolio> {
  final List<String> galleryImages = [
    'assets/vendor_images/wedding1.jpg',
    'assets/vendor_images/wedding2.jpg',
    'assets/vendor_images/wedding3.jpg',
  ]; // Placeholder image paths

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
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
                Container(
                  height: 110,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/vendor_role_images/background_photo.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  left: MediaQuery.of(context).size.width / 2 - 50,
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 48,
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
                    MaterialPageRoute(builder: (context) => const EditPortfolio()),
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
            const SizedBox(height: 20),
            // Gallery Section Header
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
            const SizedBox(height: 10),
            // Image Carousel
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.85),
                itemCount: galleryImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(galleryImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
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
          ],
        ),
      ),
    );
  }
}


