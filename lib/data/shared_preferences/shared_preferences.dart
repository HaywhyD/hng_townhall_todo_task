import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get prefs => _prefs;

  static Future<void> saveTodos(List<Map<String, dynamic>> todos) async {
    final jsonString = jsonEncode(todos);
    await _prefs.setString('todos', jsonString);
  }

  static Future<void> saveCategories(
      List<Map<String, dynamic>> categories) async {
    final jsonString = jsonEncode(categories);
    await _prefs.setString('categories', jsonString);
  }

  static Future<void> clearCategories() async {
    await _prefs.remove('categories');
  }

  static Future<void> clearTodos() async {
    await _prefs.remove('todos');
  }

  static List<Map<String, dynamic>> loadTodos() {
    final jsonString = _prefs.getString('todos');
    if (jsonString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(jsonString)
          .map((item) => Map<String, dynamic>.from(item)));
    }
    return [];
  }

  static List<Map<String, dynamic>> loadCategories() {
    final jsonString = _prefs.getString('categories');
    if (jsonString != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(jsonString)
          .map((item) => Map<String, dynamic>.from(item)));
    }
    return [];
  }

  // Load a list of notes
  static List<String> loadNotes() {
    final jsonString = _prefs.getString('notes');
    if (jsonString != null) {
      return List<String>.from(jsonDecode(jsonString));
    }
    return [];
  }
}
