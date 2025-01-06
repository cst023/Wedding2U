import 'package:cloud_firestore/cloud_firestore.dart';

class MainPageSearchController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> search(String query) async {
    final List<Map<String, dynamic>> results = [];

    if (query.isEmpty) {
      return results;
    }

    final queryLowercase = query.toLowerCase(); // Convert query to lowercase

    try {
      // Fetch venues from Firestore
      QuerySnapshot venueSnapshot = await _firestore.collection('venues').get();
      results.addAll(
        venueSnapshot.docs
            .where((doc) =>
                (doc['name'] as String).toLowerCase().contains(queryLowercase))
            .map((doc) => {
                  'id': doc.id,
                  'name': doc['name'],
                  'type': 'Venue',
                })
            .toList(),
      );

      // Fetch vendors from Firestore
      QuerySnapshot vendorSnapshot =
          await _firestore.collection('vendors').get();
      results.addAll(
        vendorSnapshot.docs
            .where((doc) =>
                (doc['name'] as String).toLowerCase().contains(queryLowercase))
            .map((doc) => {
                  'id': doc.id,
                  'name': doc['name'],
                  'type': 'Vendor',
                })
            .toList(),
      );

      return results;
    } catch (e) {
      print('Error performing search: $e');
      return [];
    }
  }
}
