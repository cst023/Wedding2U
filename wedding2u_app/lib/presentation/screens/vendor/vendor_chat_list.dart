import 'package:flutter/material.dart';
import 'package:wedding2u_app/presentation/screens/vendor/vendor_chatview.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
 @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Chat',
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: Colors.grey.shade300,
              height: 1.0,
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundImage:
                  AssetImage('assets/images/profile_image_men.jpg'), // Profile image placeholder
            ),
            title: const Text(
              'Robbie',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'You: Photos',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            onTap: () {
              Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ChatScreen()),
                          );
            },
          ),
          Divider(height: 1, color: Colors.grey.shade300),
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                'H',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: const Text(
              'Haikal',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            subtitle: Text(
              'You: Thank you for reaching out. I offer..',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            onTap: () {},
          ),
          Divider(height: 1, color: Colors.grey.shade300),
        ],
      ),
    );
  }
}
