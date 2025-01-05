import 'package:flutter/material.dart';

class ManageServicePending extends StatefulWidget {
  const ManageServicePending({super.key});

  @override
  State<ManageServicePending> createState() =>
      _ManageServicePendingState();
}

class _ManageServicePendingState extends State<ManageServicePending>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text(
          'Manage service requests',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.redAccent,
          indicatorWeight: 2.5,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13.5,
            height: 1.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12.5,
            height: 1.5,
          ),
          tabs: const [
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
          _pendingApprovalTab(),
          const Center(child: Text('No accepted service requests')),
          const Center(child: Text('No declined service requests')),
          const Center(child: Text('No completed service requests')),
        ],
      ),
    );
  }

  // Pending Approval Tab
  Widget _pendingApprovalTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Robbie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Request pending',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        SizedBox(width: 5),
                        Icon(
                          Icons.access_time,
                          color: Colors.grey,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Request Subject: I am looking for a photographer for my wedding.',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Booking date: 22-12-2024',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Date of request: 5-12-2024',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _actionButton('Decline', isPrimary: false),
                    const SizedBox(width: 10),
                    _actionButton('Accept', isPrimary: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Action Buttons (Decline/Accept)
  Widget _actionButton(String label, {bool isPrimary = false}) {
    return SizedBox(
      width: 100,
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.redAccent : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.redAccent,
          side: BorderSide(
            color: isPrimary ? Colors.transparent : Colors.redAccent,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label),
      ),
    );
  }
}
