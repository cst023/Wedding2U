import 'package:flutter/material.dart';
import '../../application/models/post.dart';
import 'photo_gallery.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  void _navigateToGallery(BuildContext context) {
    // Create a map for each post's respective images
    Map<String, List<String>> imagesMap = {
      "Javier Miguel’s": [
        'assets/post_images/javier1.jpg',
        'assets/post_images/javier2.jpg',
        'assets/post_images/javier3.jpg',
      ],
      "Azeleen Jane’s": [
        'assets/post_images/azeleen1.jpg',
        'assets/post_images/azeleen2.jpg',
        'assets/post_images/azeleen3.jpg',
      ],
      "John & Emma’s": [
        'assets/post_images/john1.jpg',
        'assets/post_images/john2.jpg',
        'assets/post_images/john3.jpg',
      ],
    };

    // Get the correct image list based on the post's name
    List<String> galleryImages = imagesMap[widget.post.name] ?? [];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoGalleryScreen(
          title: "${widget.post.name} Wedding",
          imagePaths: galleryImages,
          post: widget.post,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToGallery(context),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 3,
        color: Colors.white, // Set the card background color to white
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post Image
            Image.asset(
              widget.post.imagePath,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Post Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${widget.post.name} Wedding",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow[700], size: 18),
                      const SizedBox(width: 4),
                      Text(
                        widget.post.reviews.isEmpty
                            ? "No comments yet"
                            : "${widget.post.averageRating.toStringAsFixed(1)} ★ (${widget.post.totalReviews} comments)",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
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
