import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quran_tunes/services/shared_pref_service.dart';
import 'package:quran_tunes/ui/screens/home.dart';

import 'get_started.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {


    redirect();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SvgPicture.asset('assets/vectors/spotify_logo.svg'),
      )
    );

  }
  Future<void> redirect() async {
    await Future.delayed(const Duration(seconds: 5));
    SharedPreferencesService sharedPreferencesService = SharedPreferencesService();
    print("contains user id: ${await sharedPreferencesService.contains("uid")}");
    if (await sharedPreferencesService.contains("uid")) {
      Get.to(()  => const Home());
    } else {
      Get.to(() => const GetStarted());
    }
  }

  
}