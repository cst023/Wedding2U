import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/client/photographers.dart';
import 'package:wedding2u_app/presentation/screens/client/makeupartists.dart';
import 'package:wedding2u_app/presentation/screens/client/caterers.dart';

class VendorCatalog extends StatefulWidget {
  const VendorCatalog({super.key});

  @override
  _VendorCatalogState createState() => _VendorCatalogState();
}

class _VendorCatalogState extends State<VendorCatalog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 255, 255, 255), // White background
      appBar: AppBar(
        title: const Text(
          'Vendors',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontWeight: FontWeight.bold, // Makes the text bold
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFFf7706d),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            // Photographer Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PhotographersPage()),
                );
              },
              child: const VendorCard(
                imagePath: 'assets/vendor_images/photographers.jpg',
                icon: Icons.camera_alt_outlined,
                label: 'Photographers',
              ),
            ),
            // Make-Up Artist Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MakeupArtistsPage()),
                );
              },
              child: const VendorCard(
                imagePath: 'assets/vendor_images/makeup.jpg',
                icon: Icons.brush_outlined,
                label: 'Make-Up Artist',
              ),
            ),
            // Caterer Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CaterersPage()),
                );
              },
              child: const VendorCard(
                imagePath: 'assets/vendor_images/catering.jpg',
                icon: Icons.restaurant_outlined,
                label: 'Caterer',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Vendor Card Component
class VendorCard extends StatelessWidget {
  final String imagePath;
  final IconData icon;
  final String label;

  const VendorCard({
    super.key,
    required this.imagePath,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      width: double.infinity, // Full width
      height: 210, // Fixed height for consistent size
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.grey.withOpacity(0.2),
            BlendMode.darken,
          ),
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
