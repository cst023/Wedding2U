import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/widgets/upload_dialog.dart';
import 'package:wedding2u_app/presentation/widgets/post_card.dart';
import 'package:wedding2u_app/application/models/post.dart';

class WeddingPosts extends StatefulWidget {
  const WeddingPosts({super.key});

  @override
  _WeddingPostsState createState() => _WeddingPostsState();
}

class _WeddingPostsState extends State<WeddingPosts> {
  late List<Post> posts;

  @override
  void initState() {
    super.initState();
    // Initialize the list of posts
    posts = [
      Post(
          name: "Javier Miguel’s", imagePath: "assets/post_images/javier1.jpg"),
      Post(
          name: "Azeleen Jane’s", imagePath: "assets/post_images/azeleen1.jpg"),
      Post(name: "John & Emma’s", imagePath: "assets/post_images/john1.jpg"),
    ];
  }

  void _showUploadDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const UploadDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title:
            const Text('Posts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF222D52),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () => _showUploadDialog(context),
                child: const Text('Post A Review',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return PostCard(post: posts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
