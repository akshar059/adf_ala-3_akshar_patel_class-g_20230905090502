import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class CategoryService {
  static const key = "categories";

  static Future<List<Map<String, dynamic>>> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);

    if (data == null) {
      return [
        {"name": "Food", "icon": "🍔", "color": Colors.orange.value},
        {"name": "Travel", "icon": "🚗", "color": Colors.blue.value},
        {"name": "Shopping", "icon": "🛍️", "color": Colors.purple.value},
        {"name": "Bills", "icon": "💡", "color": Colors.red.value},
      ];
    }

    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> addCategory(
      String name, String icon, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = await getCategories();

    categories.add({
      "name": name,
      "icon": icon,
      "color": color.value,
    });

    await prefs.setString(key, jsonEncode(categories));
  }

  static Future<void> deleteCategory(String name) async {
    final prefs = await SharedPreferences.getInstance();
    final categories = await getCategories();

    categories.removeWhere((e) => e["name"] == name);

    await prefs.setString(key, jsonEncode(categories));
  }
}
