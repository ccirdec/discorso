import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:discorso/models/comments.dart';
import 'package:discorso/models/post.dart';
import 'package:discorso/models/user.dart';
import 'package:discorso/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // User Profile

  Future<void> saveUserInfoInFirebase(
      {required String name, required String email}) async {
    String uid = _auth.currentUser!.uid;

    String username = email.split('@')[0];

    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    final userMap = user.toMap();

    await _db.collection("Users").doc(uid).set(userMap);
  }

  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();

      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> updateUserBioInFirebase(String bio) async {
    String uid = AuthService().getCurrentUid();
    try {
      await _db.collection("Users").doc(uid).update({'bio': bio});
    } catch (e) {
      print(e);
    }
  }

  // Post Message
  Future<void> postMessageInFirebase(String message) async {
    try {
      String uid = _auth.currentUser!.uid;

      UserProfile? user = await getUserFromFirebase(uid);

      Post newPost = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );

      Map<String, dynamic> newPostMap = newPost.toMap();

      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection("Posts").doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Post>> getAllPostFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();
      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  // Likes
  Future<void> toggleLikeInFirebase(String postId) async {
    try {
      String uid = _auth.currentUser!.uid;

      DocumentReference postDoc = _db.collection("Posts").doc(postId);

      await _db.runTransaction(
        (transaction) async {
          DocumentSnapshot postSnapshot = await transaction.get(postDoc);

          List<String> likedBy =
              List<String>.from(postSnapshot['likedBy'] ?? []);

          int currentLikeCount = postSnapshot['likes'];

          if (!likedBy.contains(uid)) {
            likedBy.add(uid);

            currentLikeCount++;
          } else {
            likedBy.remove(uid);

            currentLikeCount--;
          }
          transaction.update(postDoc, {
            'likes': currentLikeCount,
            'likedBy': likedBy,
          });
        },
      );
    } catch (e) {}
  }
  // Comments

  Future<void> addCommentInFirebase(String postId, message) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      Comment newComment = Comment(
        id: '', 
        postId: postId, 
        uid: uid, 
        name: user!.name, 
        username: user.username, 
        message: message, 
        timestamp: Timestamp.now());

      Map<String, dynamic> newCommentMap = newComment.toMap();
      await _db.collection("Comments").add(newCommentMap);
    } catch(e){
      print(e);
    }
  }

  Future<void> deleteCommentInFirebase(String commentId) async {
    try {
      await _db.collection("Comments").doc(commentId).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<List<Comment>> getCommentsFromFirebase(String postId) async{
    try {
      QuerySnapshot snapshot = await _db.collection("Comments").where("postId", isEqualTo: postId).get();

      return snapshot.docs.map((doc) => Comment.fromDocument(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // Terkait Akun

  // Folloe

  // Search
}
