import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_add_new_project.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_edit_project.dart';

class EditPortfolio extends StatefulWidget {
  const EditPortfolio({super.key});

  @override
  @override
  _EditPortfolioState createState() => _EditPortfolioState();
}

class _EditPortfolioState extends State<EditPortfolio> {
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
        title: const Text(
          'Edit portfolio',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Type Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Service type:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8), // Spacing between text and dropdown
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: 'Photographer',
                      isExpanded: true,
                      underline: const SizedBox(), // Remove default underline
                      icon: const Icon(Icons.arrow_drop_down),
                      items: const [
                        DropdownMenuItem(
                          value: 'Photographer',
                          child: Text('Photographer'),
                        ),
                        DropdownMenuItem(
                          value: 'Videographer',
                          child: Text('Videographer'),
                        ),
                      ],
                      onChanged: (value) {
                        // Handle dropdown change
                      },
                    ),
                  ),
                ),
              ],
            ),

            // Gallery Section
            const Text(
              'Gallery',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Add photos to showcase your service (up to 6)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 4, // 3 photos + 1 add button
              itemBuilder: (context, index) {
                if (index < 3) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: AssetImage('assets/vendor_images/wedding1.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Icon(Icons.add, color: Colors.grey, size: 32),
                  );
                }
              },
            ),
            const SizedBox(height: 16),

            // Description Section
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText:
                      'I’m a wedding photographer based in Kuching, dedicated to capturing the beauty and joy...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Projects Section
            const Text(
              'Projects',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildProjectCard('Amir & Aisyah | Hilton',
                    'assets/vendor_images/project1.jpg'),
                const SizedBox(width: 12),
                _buildProjectCard('Iswan & Nurin | Cove55',
                    'assets/vendor_images/project2.jpg'),
              ],
            ),
            const SizedBox(height: 12),
            _buildAddBox(),
            const SizedBox(height: 32),

            // Done Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Widget for Projects Cards
  Widget _buildProjectCard(String title, String imagePath) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Handle navigation or action when the project card is tapped
          print('Tapped on project: $title');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EditProject()),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

// Add Box for Projects Section
  Widget _buildAddBox() {
    return GestureDetector(
      onTap: () {
        // Handle navigation or action when the add box is tapped
        print('Tapped on Add Project box');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VendorAddNewProject()),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey),
        ),
        child: const Icon(Icons.add, color: Colors.grey, size: 32),
      ),
    );
  }
}
