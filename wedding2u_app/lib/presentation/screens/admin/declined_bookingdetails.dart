import 'package:flutter/material.dart';

class DeclinedBookingDetailsScreen extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    // Temporary data declaration
    String imagePath = 'assets/images'; // Replace with your actual image path
    String name = 'Mohd Fairul';
    String date = 'Booked for 19th October  2024';

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _buildBookingDetails(context, imagePath, name, date),
    );
  }

  Widget _buildBookingDetails(BuildContext context, String imagePath, String name, String date) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    date,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300], // Grey background for Declined
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Declined',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Package Baitulmal, Kuching',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text('4.2'),
                  Icon(Icons.star, color: Colors.amber),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Experience a celebration of simplified luxury at Baitulmal Hall, Kuching as its grand room can hold-up till 500 to 1000 guests.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Text(
            'This package includes:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          _buildPackageItem(
              'Facilities included, such as, in-door surau, private room, and VIP changing room'),
          _buildPackageItem('Dome-style serving, Malay food'),
          _buildPackageItem(
              'Wedding ceremony styling, such as, modern standard arch/backdrop, red-carpet, car decoration, and more'),
          _buildPackageItem(
              'Table number and venue layout will be provided'),
          _buildPackageItem(
              'Complimentary parking lot for family and friends'),
          _buildPackageItem(
              'Wedding Ceremony planning and coordination by the personal Wedding Planner'),
          SizedBox(height: 8),
          Text(
            '*The suggested itinerary can be amended in accordance with client preference',
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Cancel'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Contact'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[100],
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackageItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0, right: 4),
            child: Icon(Icons.circle, size: 8, color: Colors.grey),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
