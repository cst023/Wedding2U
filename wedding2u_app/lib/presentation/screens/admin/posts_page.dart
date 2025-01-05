import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 18),
              _buildPostCard(
                imagePath: 'assets/post_images/javier1.jpg', 
                title: "Javier Miguel's Wedding",
                reviewText: "No reviews yet",
              ),
              const SizedBox(height: 16),
              _buildPostCard(
                imagePath: 'assets/post_images/azeleen1.jpg', 
                title: "Azeleen Jane's Wedding",
                reviewText: "No reviews yet",
              ),
              // Add more post cards here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostCard({ //TODO: View post details
    required String imagePath,
    required String title,
    required String reviewText,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const Icon(Icons.delete), // Add delete Icon
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text(
                  reviewText,
                  style: const TextStyle(color: Colors.grey), 
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}