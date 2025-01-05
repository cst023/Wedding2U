import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
 @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Chat',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
              children: [
                // Incoming Message
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/profile_image_men.jpg'),
                      radius: 20,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Robbie',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'May I see some of your photographs',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '16.04',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                // Outgoing Message
                Align(
                  alignment: Alignment.centerRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Hello, these are examples of my photographs I\'ve taken. '
                          'I hope it\'ll be enough for you to endorse me as your photographer during your wedding.',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '16.04',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 10),

                      // Image Grid
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          _buildImage('assets/vendor_images/wedding1.jpg'),
                          _buildImage('assets/vendor_images/wedding2.jpg'),
                          _buildImage('assets/vendor_images/wedding3.jpg'),
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: AssetImage('assets/images/profile_image_men.jpg'),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 4,
                                  backgroundColor: Colors.green,
                                ),
                              ),
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

          // Updated Bottom Chat Input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: [
                // Text Field with Emoji and Photo Icons
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        // Emoji Icon
                        IconButton(
                          icon: Icon(Icons.emoji_emotions_outlined,
                              color: Colors.black45),
                          onPressed: () {},
                        ),

                        // Add Photo Icon
                        IconButton(
                          icon:
                              Icon(Icons.photo_outlined, color: Colors.black45),
                          onPressed: () {
                            // Handle photo upload logic here
                          },
                        ),

                        // Text Field
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Write a message...',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 10),

                // Microphone Icon
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.mic, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build images
  Widget _buildImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imagePath,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
      ),
    );
  }
}
