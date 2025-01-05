import 'package:flutter/material.dart';

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 18),
              _buildPostCard(
                imagePath: 'assets/post_images/javier1.jpg', 
                title: "Javier Miguel's Wedding",
                reviewText: "No reviews yet",
              ),
              SizedBox(height: 16),
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
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Icon(Icons.delete), // Add delete Icon
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                SizedBox(width: 4),
                Text(
                  reviewText,
                  style: TextStyle(color: Colors.grey), 
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}