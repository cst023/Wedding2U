import 'package:wedding2u_app/data/firestore_service.dart';

class VendorPortfolioController {
  final FirestoreService _firestoreService = FirestoreService();

  // Fetch vendor data and gallery images
  Future<Map<String, dynamic>> fetchVendorPortfolio(String vendorId) async {
    final vendorData = await _firestoreService.fetchVendorData(vendorId);
    final galleryImages = await _firestoreService.fetchGalleryImages(vendorId);

    return {
      'vendorData': vendorData,
      'galleryImages': galleryImages,
    };
  }
}
