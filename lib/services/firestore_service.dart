import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get userId => _auth.currentUser?.uid;

  Future<void> addFavorite(Map<String, dynamic> favoriteData) async {
    if (userId == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .add(favoriteData);
    } catch (e) {
      print("Error adding favorite: $e");
    }
  }

  Future<void> removeFavorite(String favoriteId) async {
    if (userId == null) return;
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(favoriteId)
          .delete();
    } catch (e) {
      print("Error removing favorite: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getFavorites() {
    if (userId == null) return const Stream.empty();
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList());
  }
}
