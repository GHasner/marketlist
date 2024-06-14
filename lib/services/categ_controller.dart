import 'package:marketlist/models/categ.dart';
import 'package:marketlist/services/categ_shared_preferences.dart';

class CategController {
  static List<Categ>? savedCategories;

  const CategController();

  static Future<void> getData() async {
    savedCategories = await CategPreferencesService.get();
  }

  static Future<void> setData() async {
    await CategPreferencesService.save(savedCategories!);
  }

  static bool categIsRegistered(String title) {
    if (savedCategories!.isEmpty || savedCategories == null) return false;
    for (int i = 0; i < savedCategories!.length; i++) {
      if (savedCategories![i].title == title) return true;
    }
    return false;
  }

  // Get is implemented implicitly through FutureBuilder

  static void insert(Categ categ) {
    savedCategories!.add(categ);
    setData();
  }

  static void update(
      Categ categOld, String title, String description, String imgPath) {
    Categ categNew =
        Categ(title: title, description: description, imgPath: imgPath);
    int index = savedCategories!.indexOf(categOld);
    savedCategories![index] = categNew;
  }

  static void delete(Categ categ) {
    savedCategories!.remove(categ);
    setData();
  }

  static Categ? search(String title) {
    if (savedCategories != null) {
      int index = savedCategories!.indexWhere((x) => x.title == title);
      if (index != -1) {
        return savedCategories![index];
      }
    }
    return null;
  }
}
