import 'package:wedding2u_app/data/firestore_service.dart';

class GuestListController {
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> addGuest({
    required String clientId,
    required String guestName,
    required String guestPhone,
    required String rsvpStatus,
  }) async {
    try {
      await _firestoreService.addGuest(
        clientId,
        guestName,
        guestPhone,
        rsvpStatus,
      );
    } catch (e) {
      throw Exception("Error adding guest: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchGuests(String clientId) async {
    try {
      return await _firestoreService.fetchGuests(clientId);
    } catch (e) {
      throw Exception("Error fetching guests: $e");
    }
  }

  Future<void> updateGuest({
    required String clientId,
    required String guestId,
    required String guestName,
    required String guestPhone,
    required String rsvpStatus,
  }) async {
    try {
      await _firestoreService.updateGuest(
        clientId: clientId,
        guestId: guestId,
        guestName: guestName,
        guestPhone: guestPhone,
        rsvpStatus: rsvpStatus,
      );
    } catch (e) {
      throw Exception("Error updating guest: $e");
    }
  }

  Future<void> deleteGuest({
    required String clientId,
    required String guestId,
  }) async {
    try {
      await _firestoreService.deleteGuest(clientId: clientId, guestId: guestId);
    } catch (e) {
      throw Exception("Error deleting guest: $e");
    }
  }

  Future<String?> fetchInvitationCode(String clientId) async {
    try {
      final weddingPlan = await _firestoreService.getWeddingPlan(clientId);
      return weddingPlan['invitation_code'] as String?;
    } catch (e) {
      throw Exception("Error fetching invitation code: $e");
    }
  }

  Future<bool> validateGuestAndCode({
    required String invitationCode,
    required String phoneNumber,
  }) async {
    return await _firestoreService.validateGuestAndCode(
      invitationCode: invitationCode,
      phoneNumber: phoneNumber,
    );
  }

  Future<void> updateGuestRsvpStatus({
    required String weddingPlanId,
    required String guestPhone,
    required String rsvpStatus,
  }) async {
    await _firestoreService.updateGuestRsvpStatus(
      weddingPlanId: weddingPlanId,
      guestPhone: guestPhone,
      rsvpStatus: rsvpStatus,
    );
  }

  Future<List<Map<String, String>>> fetchGuestsByInvitationCode(
      String invitationCode) async {
    try {
      // Get the wedding plan details from the invitation code
      final weddingPlan =
          await _firestoreService.getWeddingPlanDetails(invitationCode);

      if (weddingPlan.isNotEmpty) {
        final weddingPlanId = weddingPlan['client_id'];

        // Fetch guests from the wedding plan
        final guests = await _firestoreService.fetchGuests(weddingPlanId);
        return guests
            .map((guest) {
              return {
                "id": guest['id']?.toString() ?? '',
                "name": guest['guest_name']?.toString() ?? '',
                "phone": guest['guest_phone']?.toString() ?? '',
                "status": guest['rsvp_status']?.toString() ?? 'Pending',
              };
            })
            .toList()
            .cast<Map<String, String>>();
      } else {
        throw Exception(
            "Wedding plan not found for the given invitation code.");
      }
    } catch (e) {
      throw Exception("Error fetching guests: $e");
    }
  }

  Future<List<Map<String, String>>> fetchTentativeByInvitationCode(
    String invitationCode) async {
  try {
    // Get the wedding plan details from the invitation code
    final weddingPlan =
        await _firestoreService.getWeddingPlanDetails(invitationCode);

    if (weddingPlan.isNotEmpty) {
      final weddingPlanId = weddingPlan['client_id'];

      // Fetch tentative events from the wedding plan
      final tentativeEvents =
          await _firestoreService.fetchTentative(weddingPlanId);

      return tentativeEvents
          .map((event) {
            return {
              "id": event['id']?.toString() ?? '',
              "event_name": event['event_name']?.toString() ?? '',
              "start_time": event['start_time']?.toString() ?? '',
              "description": event['description']?.toString() ?? '',
            };
          })
          .toList()
          .cast<Map<String, String>>();
    } else {
      throw Exception(
          "Wedding plan not found for the given invitation code.");
    }
  } catch (e) {
    throw Exception("Error fetching tentative: $e");
  }
}

Future<Map<String, dynamic>> getWeddingPlanDetailsByInvitationCode(String invitationCode) async {
  return await _firestoreService.getWeddingPlanDetails(invitationCode);
}

Future<Map<String, dynamic>> getGuestDetails({
  required String invitationCode,
  required String phoneNumber,
}) async {
  try {
    // Fetch wedding plan details by invitation code
    final weddingPlan = await _firestoreService.getWeddingPlanDetails(invitationCode);
    if (weddingPlan.isNotEmpty) {
      final weddingPlanId = weddingPlan['client_id'];

      // Fetch guest details
      final guest = await _firestoreService.fetchGuestByPhone(
        weddingPlanId: weddingPlanId,
        guestPhone: phoneNumber,
      );

      if (guest != null) {
        return guest;
      } else {
        throw Exception("Guest not found.");
      }
    } else {
      throw Exception("Wedding plan not found.");
    }
  } catch (e) {
    throw Exception("Error fetching guest details: $e");
  }
}



}
