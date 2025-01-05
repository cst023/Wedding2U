// forgot_password_logic.dart
import 'package:wedding2u_app/data/firebase_auth_service.dart';

class ForgotPasswordLogic {
  final FirebaseAuthService _firebaseAuthService;

  ForgotPasswordLogic(this._firebaseAuthService);

  Future<void> resetPassword(String email) async {
    if (email.isEmpty) {
      throw Exception("Email cannot be empty.");
    }

    try {
      await _firebaseAuthService.sendPasswordResetEmail(email);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
