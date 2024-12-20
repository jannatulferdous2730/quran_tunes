import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_tunes/ui/screens/player_page.dart';
import 'package:quran_tunes/ui/screens/sign_in_page.dart';

import '../../controllers/favorite_controller.dart';
import '../../services/auth_service.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final FavoriteController favoriteController = Get.find<FavoriteController>();

    var size = Get.size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CupertinoColors.activeGreen,
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signout();
              Get.to(() => const SignInPage()); // Redirect to Sign In page after logout
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Profile Header
          Container(
            height: size.height * .35,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: CupertinoColors.activeGreen,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // User Photo
                Container(
                  height: 90,
                  width: 90,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: authService.photoUrl.isNotEmpty
                      ? ClipOval(
                    child: Image.network(
                      authService.photoUrl.value,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(
                    CupertinoIcons.person_alt_circle,
                    size: 90,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 15),
                // User Email
                Text(
                  authService.userEmail.value,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 10),
                // User Name
                Text(
                  authService.userName.value,
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Favorites List Header
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Favorite Surahs",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Favorites ListView
          Expanded(
            child: Obx(() {
              final favorites = favoriteController.favorites;

              if (favorites.isEmpty) {
                return const Center(
                  child: Text(
                    "No favorite Surahs yet!",
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final favorite = favorites[index];
                  return ListTile(
                    leading: const CircleAvatar(
                      child: Icon(CupertinoIcons.play_arrow_solid),
                    ),
                    title: Text(
                      favorite['surahName'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Reciter: ${favorite['qariName']}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: CupertinoColors.inactiveGray),
                      onPressed: () {
                        favoriteController.toggleFavorite(
                          favorite['surahName'],
                          favorite['qariName'],
                          favorite['audioPath'],
                          true,
                          favorite['id'],
                        );
                      },
                    ),
                    onTap: () {
                      // Navigate to PlayerPage when a Surah is tapped
                      Get.to(() => PlayerPage(
                        surahName: favorite['surahName'],
                        qariName: favorite['qariName'],
                        audioPath: favorite['audioPath'],
                        duration: 'Unknown', // You can enhance this with duration data
                        qariImagePath: '', // Add this if required
                      ));
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
