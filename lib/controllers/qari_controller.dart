import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class QariController extends GetxController {
  RxList<dynamic> qariData = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadSurahData();
  }

  // Load JSON metadata
  Future<void> loadSurahData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/surahs.json');
      final List<dynamic> data = json.decode(jsonString);
      qariData.value = data;
    } catch (e) {
      print("Error loading Surah data: $e");
    }
  }
}
