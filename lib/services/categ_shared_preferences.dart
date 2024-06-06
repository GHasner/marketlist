import 'dart:convert';
import 'package:marketlist/models/categ.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategPreferencesService {
  Future<void> save(List<Categ> categs) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        json.encode(categs.map((categ) => categ.toJson()).toList());
    await prefs.setString('categs', encodedData);
  }

  Future<List<Categ>> get() async {
    final prefs = await SharedPreferences.getInstance();
    final String? categs = prefs.getString('categs');
    if (categs != null) {
      final List<dynamic> decodedData = json.decode(categs);
      return decodedData.map((json) => Categ.fromJson(json)).toList();
    }
    return [];
  }
}