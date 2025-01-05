import 'package:flutter/material.dart';


class ManageServiceCompleted extends StatefulWidget {
  const ManageServiceCompleted({super.key});

  @override
  _ManageServiceCompletedState createState() =>
      _ManageServiceCompletedState();
}

class _ManageServiceCompletedState extends State<ManageServiceCompleted>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 3);
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        title: const Text(
          'Manage service requests',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          indicatorWeight: 2.5,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
          const Center(child: Text('No pending service requests')),
          const Center(child: Text('No accepted service requests')),
          const Center(child: Text('No declined service requests')),
          _completedTab(),
        ],
      ),
    );
  }

  // Completed Tab Layout
  Widget _completedTab() {
    return Center(
      child: Text(
        'No completed service requests',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }
}
