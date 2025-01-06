import 'package:wedding2u_app/data/firestore_service.dart';

class VenueBookingController {
  final FirestoreService _firestoreService = FirestoreService();

  Future<Map<String, dynamic>?> fetchVenueDetails(String venueId) async {
    try {
      return await _firestoreService.fetchVenueById(venueId);
    } catch (e) {
      throw Exception('Error fetching venue details: $e');
    }
  }

  Future<void> createBooking({
    required String bookingDate,
    required String clientId,
    required String venueId,
    required String venueName,
    required DateTime requestDate,
    required String status,
  }) async {
    try {
      await _firestoreService.addBooking(
        bookingDate: bookingDate,
        clientId: clientId,
        venueId: venueId,
        venueName: venueName,
        requestDate: requestDate,
        status: status,
      );
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Fetch all bookings for a specific client
  Future<List<Map<String, dynamic>>> getClientBookings(String clientId) async {
    try {
      return await _firestoreService.getClientBookings(clientId);
    } catch (e) {
      throw Exception('Error fetching client bookings: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllBookingsWithClientNames() async {
    try {
      // Fetch all bookings
      List<Map<String, dynamic>> bookings =
          await _firestoreService.fetchAllBookings();

      // Resolve client names for each booking
      List<Map<String, dynamic>> bookingsWithClientNames = [];

      for (var booking in bookings) {
        String clientId = booking['client_id'];
        String? clientName = await _firestoreService.fetchClientNameById(clientId);

        bookingsWithClientNames.add({
          'id': booking['id'],
          'clientName': clientName ?? 'Unknown Client',
          'venueName': booking['venue_name'],
          'bookingDate': booking['booking_date'],
          'requestDate': booking['request_date'],
          'status': booking['status'],
          'venueId': booking['venue_id'],
        });
      }

      return bookingsWithClientNames;
    } catch (e) {
      throw Exception('Error fetching bookings with client names: $e');
    }
  }

   Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestoreService.deleteBooking(bookingId);
    } catch (e) {
      throw Exception('Error deleting booking: $e');
    }
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      await _firestoreService.updateBookingStatus(bookingId, newStatus);
    } catch (e) {
      throw Exception('Error updating booking status: $e');
    }
  }


}
