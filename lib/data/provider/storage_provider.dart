import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageProvider extends ChangeNotifier {
  static late SharedPreferences instance;
  static Future<SharedPreferences> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    instance = prefs;
    await prefs.reload();
    return prefs;
  }
}