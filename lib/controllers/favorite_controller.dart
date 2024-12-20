import 'package:get/get.dart';
import '../services/firestore_service.dart';

class FavoriteController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();

  RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs; // Reactive favorites list

  @override
  void onInit() {
    super.onInit();
    _loadFavorites(); // Load favorites when the controller is initialized
  }

  void _loadFavorites() {
    _firestoreService.getFavorites().listen((favoriteList) {
      favorites.assignAll(favoriteList); // Update the reactive list
    });
  }

  void toggleFavorite(String surahName, String qariName, String audioPath, bool isFavorite, String? favoriteId) {
    if (isFavorite && favoriteId != null) {
      _firestoreService.removeFavorite(favoriteId);
    } else {
      _firestoreService.addFavorite({
        'surahName': surahName,
        'qariName': qariName,
        'audioPath': audioPath,
      });
    }
  }
}
