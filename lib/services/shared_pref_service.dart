import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {

  saveString(String s) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("uid", s);
  }

  Future<String> getString(String s) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(s)!;
  }

  Future<bool> contains(String s) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.containsKey(s);
  }

  clear() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

}