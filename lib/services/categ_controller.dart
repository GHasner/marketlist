import 'package:marketlist/models/categ.dart';

class CategController {
  final List<Categ>? savedCategories;

  const CategController({required this.savedCategories});

  bool categIsRegistered(String title) {
    if (savedCategories!.isEmpty || savedCategories == null) return false;
    for (int i = 0; i < savedCategories!.length; i++) {
      if (savedCategories![i].title == title) return true;
    }
    return false;
  }

  // Get is implemented implicitly through FutureBuilder

  // Insert is implemented directly through list.Add(Categ newCateg);

  void updateCateg(Categ categOld, String title, String description, String imgPath) {
    Categ categNew = Categ(title: title, description: description, imgPath: imgPath);
    int index = savedCategories!.indexOf(categOld);
    savedCategories![index] = categNew;
  }

  // Delete is implemented directly through list.Remove(Categ oldCateg);
}