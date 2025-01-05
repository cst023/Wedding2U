import 'package:flutter/material.dart';


class ManageServiceAccepted extends StatefulWidget {
  @override
  _ManageServiceAcceptedState createState() =>
      _ManageServiceAcceptedState();
}

class _ManageServiceAcceptedState extends State<ManageServiceAccepted>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          'Manage service requests',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          indicatorWeight: 2.5,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
            height: 1.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12.5,
            height: 1.5,
          ),
          tabs: const [
            Tab(text: 'Pending approval'),
            Tab(text: 'Accepted'),
            Tab(text: 'Declined'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('No pending approvals')),
          _acceptedTab(),
          Center(child: Text('No declined service requests')),
          Center(child: Text('No completed service requests')),
        ],
      ),
    );
  }

  // Accepted Tab
  Widget _acceptedTab() {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Robbie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Request accepted',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Request Subject: I am looking for a photographer for my wedding.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 5),
                Text(
                  'Booking date: 22-12-2024',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Date of request: 5-12-2024',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
