import 'package:wedding2u_app/data/firestore_service.dart';

class UserProfileController {
  final FirestoreService _firestoreService = FirestoreService();

  Future<Map<String, dynamic>> getUserData(String uid) async {
    try {
      return await _firestoreService.getUserData(uid);
    } catch (e) {
      throw Exception('Error retrieving user data: $e');
    }
  }

    // Update user data in Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> updatedData) async {
    try {
      await _firestoreService.updateUserData(uid, updatedData);
    } catch (e) {
      throw Exception('Error updating user data: $e');
    }
  }
}
