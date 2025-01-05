import 'package:flutter/material.dart';
import '../../application/models/post.dart';
import '../../application/models/review.dart';

class PhotoGalleryScreen extends StatefulWidget {
  final String title;
  final List<String> imagePaths;
  final Post post;

  const PhotoGalleryScreen({
    super.key,
    required this.title,
    required this.imagePaths,
    required this.post,
  });

  @override
  State<PhotoGalleryScreen> createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;

  void _addReview() {
    if (_reviewController.text.isEmpty || _selectedRating == 0) return;

    setState(() {
      widget.post.reviews.add(
        Review(
          reviewerName:
              "Guest User", // Static for now, can integrate user input
          rating: _selectedRating,
          comment: _reviewController.text,
        ),
      );
      _reviewController.clear();
      _selectedRating = 0;
    });
  }

  Widget _buildPackageDescription() {
    String packageDescription = '';

    // Determine the package based on the wedding name
    if (widget.post.name.contains('Javier')) {
      packageDescription =
          "Package Baitulmal, Kuching\nExperience a celebration of simplified luxury at Baitulmal Hall, Kuching as its' grand room can hold-up till 500 to 1000 guests.";
    } else if (widget.post.name.contains('Azeleen')) {
      packageDescription =
          "Package Hikmah, Kuching\nHint of Moorish Architecture, with a modern twist. Hikmah (Intan), Kuching can hold-up from 400 to 1000 guests.";
    } else if (widget.post.name.contains('John')) {
      packageDescription =
          "Package CIBD, Kuching\nCIDB Convention Centre, Kuching\nCommodious Package for 400 to 600 guests.";
    }

    return packageDescription.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Text(
              packageDescription,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Display Photos
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.imagePaths.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    widget.imagePaths[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),

            // Package Description
            _buildPackageDescription(),

            const SizedBox(height: 20),

            // Reviews Section
            const Text(
              "Comments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.post.reviews.length,
              itemBuilder: (context, index) {
                final review = widget.post.reviews[index];
                return ListTile(
                  leading: Icon(Icons.star, color: Colors.yellow[700]),
                  title: Text("${review.reviewerName} ★ ${review.rating}"),
                  subtitle: Text(review.comment),
                );
              },
            ),

            // Add a Review
            const Divider(),
            const Text(
              "Add a Comment",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedRating = index + 1;
                          });
                        },
                        icon: Icon(
                          Icons.star,
                          color: index < _selectedRating
                              ? Colors.yellow[700]
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                  TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write your comment here...",
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addReview,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pinkAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Submit"),
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