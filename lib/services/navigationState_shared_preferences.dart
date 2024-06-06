import 'package:shared_preferences/shared_preferences.dart';

class NavigationStateSharedPreferences {

  static Future<void> savePageState(String tabSelected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currentTab', tabSelected);
  }

  static Future<String?> getPageState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('currentTab');
  }

  // If ProductPageState is 'notSelected' a página é CategSelectionScreen, Else é ItemListScreen

  static Future<void> saveProductPageState(String categSelected) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('categSelected', categSelected);
  }

  static Future<String?> getProductPageState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('categSelected');
  }
}