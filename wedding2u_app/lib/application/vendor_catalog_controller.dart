import 'package:wedding2u_app/data/firestore_service.dart';

class VendorController {
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<Map<String, dynamic>>> getVendorsByRole(String role) async {
    return await _firestoreService.fetchVendorsByRole(role);
  }
}