import 'package:marketlist/models/categ.dart';
import 'package:marketlist/services/categ_shared_preferences.dart';
import 'package:marketlist/services/form_controller.dart';

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

  static String? searchAlike(String? title, Categ? edited) {
    // Verifica se a lista está vazia
    if (savedCategories != null && savedCategories!.length > 1) {
      // Senão estiver vazia busca por títulos semelhantes (correspondentes ao tirar espaços brancos e maiúsculas)
      String titleSimplified = FormValidations.titlePartialValidation(title);
      // Faz a primeira validação do Form para ver se o título é válido
      if (FormValidations.invalidTitlePartials.contains(titleSimplified)) {
        // Senão for retorna o tipo de invalidez
        return titleSimplified;
      }

      int index = savedCategories!.indexWhere(
          (x) => x.title.replaceAll(" ", "").toLowerCase() == titleSimplified);
      if (index != -1) {
        // Se achar uma correspondência retornaria o index em String
        if (edited != null) {
          // Mas se Categ? edited != null, a correspondência pode ser igual à categoria editada, retornando 'editOverride'
          if (edited.title.replaceAll(" ", "").toLowerCase() ==
              titleSimplified) {
            return "editOverride";
          }
        }
        return savedCategories![index].toString();
      }
      return "notRegistered";
    }
    // Se a lista estiver vazia retorna null
    return null;
  }
}
