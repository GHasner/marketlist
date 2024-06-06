import 'dart:convert';
import 'package:marketlist/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemPreferencesService {
  Future<void> save(List<Item> items) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString('items', encodedData);
  }

  Future<List<Item>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final String? items = prefs.getString('items');
    if (items != null) {
      final List<dynamic> decodedData = json.decode(items);
      return decodedData.map((json) => Item.fromJson(json)).toList();
    }
    return [];
  }
}
