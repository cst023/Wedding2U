import 'package:flutter/material.dart';


class ManageServiceRequest extends StatefulWidget {
  @override
  _ManageServiceRequestState createState() => _ManageServiceRequestState();
}

class _ManageServiceRequestState extends State<ManageServiceRequest>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 2);
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Manage service requests',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey.shade600,
          labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          unselectedLabelStyle: TextStyle(fontSize: 12),
          tabs: [
            Tab(
              child: Text(
                'Pending approval',
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                'Accepted',
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                'Declined',
                textAlign: TextAlign.center,
              ),
            ),
            Tab(
              child: Text(
                'Completed',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('No pending approvals')), // Pending approval tab
          Center(child: Text('No accepted service requests')), // Accepted tab
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'No declined service requests',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            ),
          ), // Declined tab
          Center(child: Text('No completed service requests')), // Completed tab
        ],
      ),
    );
  }
}
