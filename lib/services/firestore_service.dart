import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add a Song to Firestore
  Future<void> addSong(Map<String, dynamic> songData) async {
    try {
      await _db.collection('songs').add(songData);
      print("Song added successfully!");
    } catch (e) {
      print("Error adding song: $e");
    }
  }

  // Fetch All Songs
  Stream<List<Map<String, dynamic>>> getSongs() {
    return _db.collection('songs').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Add User Data
  Future<void> addUser(String userId, Map<String, dynamic> userData) async {
    try {
      await _db.collection('users').doc(userId).set(userData);
      print("User added successfully!");
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  // Fetch User Data
  Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      var doc = await _db.collection('users').doc(userId).get();
      return doc.data();
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }
}
