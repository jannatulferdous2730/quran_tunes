import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran_tunes/services/shared_pref_service.dart';

class AuthService extends GetxController {
  final _auth = FirebaseAuth.instance;
  SharedPreferencesService sharedPreferencesService = SharedPreferencesService();

  RxString photoUrl = "".obs; // Observable string to store the photo URL
  RxString userName = "".obs; // Observable string to store the user's name
  RxString userEmail = "".obs; // Observable string to store the user's email

  Future<void> loadCurrentUser() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      // Load user's photo URL
      if (currentUser.photoURL != null) {
        photoUrl.value = currentUser.photoURL!;
      }

      // Load user's name
      if (currentUser.displayName != null) {
        userName.value = currentUser.displayName!;
      } else {
        userName.value = "Guest"; // Default if name is not available
      }

      // Load user's email
      if (currentUser.email != null) {
        userEmail.value = currentUser.email!;
      } else {
        userEmail.value = "No Email"; // Default if email is not available
      }
    } else {
      // If no user is signed in
      photoUrl.value = "";
      userName.value = "Guest";
      userEmail.value = "No Email";
    }
  }


  Future<UserCredential?> signInWithGoogle() async {
  try {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Trigger account selection
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    // Sign in with Firebase
    final userCredential = await _auth.signInWithCredential(credential);

    // Update photoUrl from the Firebase User profile
    final user = userCredential.user;
    String uid = user!.uid;
    await sharedPreferencesService.saveString(uid);
    photoUrl.value = user.photoURL ?? ""; // Fetch from FirebaseAuth user

    print("Updated Photo URL: ${photoUrl.value}");
    return userCredential;
  } catch (e) {
    print("Error during sign-in: $e");
    Get.snackbar("Error", "Something went wrong");
  }
  return null;
}


  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      String uid = cred.user!.uid;
      await sharedPreferencesService.saveString(uid);
      return cred.user;
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Something went wrong",
        backgroundColor: Colors.red,
      );
    }
    return null;
  }

  register(String email, String password) async {
    final user = await createUserWithEmailAndPassword(email, password);
    if (user != null) {
      Get.snackbar("Success", "Account created successfully");
    }
  }

  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
      String uid = cred.user!.uid;

      // Save the user's UID to shared preferences
      await sharedPreferencesService.saveString(uid);
      print("Registered user: ${await sharedPreferencesService.getString("uid")}");

      return cred.user;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuth errors
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found for this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password.";
          break;
        case 'invalid-email':
          errorMessage = "The email address is not valid.";
          break;
        default:
          errorMessage = "An unknown error occurred.";
      }

      // Show a Snackbar with the specific error
      Get.snackbar("Login Error", errorMessage);
    } catch (e) {
      // Handle other exceptions
      print(e);
      Get.snackbar("Error", "Something went wrong");
    }
    return null;
  }


  signin(String email, String password) async {
    final user = await loginUserWithEmailAndPassword(email, password);
    if (user != null) {
      Get.snackbar("Success", "Logged in successfully");
    }
  }

  Future<void> signout() async {
    try {
      await GoogleSignIn().signOut(); // Sign out from Google account
      // await GoogleSignIn().disconnect();
      await _auth.signOut(); // Sign out from Firebase
      await sharedPreferencesService.clear();
      photoUrl.value = "";
      userName.value = "";
      userEmail.value = "";
      Get.snackbar("Success", "Logged out successfully");
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Something went wrong");
    }
  }

}