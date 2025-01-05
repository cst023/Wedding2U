import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/client/gerryportfolio.dart';

class PhotographersPage extends StatelessWidget {
  const PhotographersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Photographers',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        children:  [

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GerryPortfolioPage()), // Navigate to Gerry's portfolio
              );
            },
            child: const PhotographerCard(
              imagePath: 'assets/vendor_images/gerry.jpg',
              name: 'Gerry Photography',
              role: 'Professional Photographer',
              location: 'Sarawak, Malaysia',
           ),),
          
          const PhotographerCard(
            imagePath: 'assets/vendor_images/js_camera.jpg',
            name: 'J’s Camera',
            role: 'Professional Photographer',
            location: 'Kuala Lumpur, Malaysia',
          ),
          const PhotographerCard(
            imagePath: 'assets/vendor_images/capture_studio.jpg',
            name: 'Capture Studio',
            role: 'Professional Photographer',
            location: 'Sarawak, Malaysia',
          ),
          const PhotographerCard(
            imagePath: 'assets/vendor_images/forever_moments.jpg',
            name: 'Forever Moments',
            role: 'Professional Photographer',
            location: 'Sabah, Malaysia',
          ),
        ],
      ),
    );
  }
}

class PhotographerCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String role;
  final String location;

  const PhotographerCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.role,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              role,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.black54,
                ),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}