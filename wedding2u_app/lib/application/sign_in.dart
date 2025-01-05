import 'package:wedding2u_app/data/firebase_auth_service.dart';
import 'package:wedding2u_app/data/firestore_service.dart';

class SignInService {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

Future<String> signIn({required String email, required String password}) async {
  try{
    String uid =  await _authService.signInUser(email: email, password: password);
    return uid;
  } catch(e){
    rethrow;
  }
  
}

Future<String> fetchRole(String uid) async {
  try{
    String role = await _firestoreService.getUserRole(uid);
    return role;
  } catch(e){
    rethrow;
  }
}

Future<Map<String, dynamic>> fetchUserData(String uid) async {
  try {
    Map<String, dynamic> userData = await _firestoreService.getUserData(uid);
    return userData;
  } catch (e) {
    rethrow;
  }
}

}
