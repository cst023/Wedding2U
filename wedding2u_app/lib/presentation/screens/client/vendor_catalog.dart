import 'package:flutter/material.dart'; 
import 'package:wedding2u_app/presentation/screens/client/photographers.dart'; 


class VendorCatalog extends StatefulWidget {
  const VendorCatalog({super.key});

  //const VendorCatalog({super.key});

  @override
  _VendorCatalogState createState() => _VendorCatalogState();
}

class _VendorCatalogState extends State<VendorCatalog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Vendors'),
        centerTitle: true,
        leading:  IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Photographer Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PhotographersPage()),
                );
              },
              child: const VendorCard(
                imagePath: 'assets/vendor_images/photographers.jpg',
                icon: Icons.camera_alt_outlined,
                label: 'Photographers',
              ),
            ),
            // Make-Up Artist Section
            const VendorCard(
              imagePath: 'assets/vendor_images/makeup.jpg',
              icon: Icons.brush_outlined,
              label: 'Make-Up Artist',
            ),
            // Caterer Section
            const VendorCard(
              imagePath: 'assets/vendor_images/catering.jpg',
              icon: Icons.restaurant_outlined,
              label: 'Caterer',
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
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5),
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

