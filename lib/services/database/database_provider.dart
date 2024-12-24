import 'package:discorso/models/user.dart';
import 'package:discorso/services/auth/auth_service.dart';
import 'package:discorso/services/database/database_service.dart';
import 'package:flutter/foundation.dart';

class DatabaseProvider extends ChangeNotifier{
  final _auth = AuthService();
  final _db = DatabaseService();


  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid); 
}