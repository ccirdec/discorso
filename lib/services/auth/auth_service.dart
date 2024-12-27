import 'package:discorso/services/database/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  User? getCurrentUser() => _auth.currentUser;
  String getCurrentUid() => _auth.currentUser!.uid;

  Future<UserCredential> loginEmailPassword(String email, password) async {
  try {
    final UserCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return UserCredential;
  } 
  on FirebaseAuthException catch (e) {
    throw Exception('Failed to log in: $e');
    }
  }

  Future<UserCredential> registerEmailPassword(String email, password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;
  } 
  on FirebaseAuthException catch (e) {
    throw Exception('Failed to Register: $e');
    }
  }

  Future<void> logout() async{
    await _auth.signOut();
  }

  Future<void> deleteAccount() async {
    User? user = getCurrentUser();

    if(user != null){
      await DatabaseService().deleteUserInfoFromFirebase(user.uid);
      await user.delete();
    }
  }

}