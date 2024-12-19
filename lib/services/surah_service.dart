import 'dart:convert';
import 'package:flutter/services.dart';

class SurahService {
  Future<List<dynamic>> loadSurahData() async {
    final String jsonString = await rootBundle.loadString('assets/surahs.json');
    final List<dynamic> data = json.decode(jsonString);
    return data;
  }
}
