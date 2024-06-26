// ignore_for_file: use_build_context_synchronously
import 'package:marketlist/models/item.dart';

class FormValidations {
  static bool execCallBack = false;
  static bool execPartialCallBack = false;
  
  static List<String> invalidTitlePartials = [
    'titleEmpty',
    'tooLong',
    'invalidChars',
    'titleInvalid',
    'editOverride',
    'notRegistered'
  ];

  static String titlePartialValidation(String? title) {
    if (title == null || title == "") {
      return "titleEmpty";
    }
    // Reserved titles for validations
    if (invalidTitlePartials.contains(title)) {
      return "titleInvalid";
    }
    // Check for special caracters
    String titlePartial = title.replaceAll(" ", "").toLowerCase();
    RegExp regexPortugues = RegExp(r'[A-Za-záàãéÉêíìÍÌóÓôõç]');
    if (titlePartial.replaceAll(regexPortugues, "") != "") {
      return "invalidChars";
    }
    // Check length
    if (title.length > 30) {
      return "tooLong";
    }
    // Return resumed form to continue validations
    return titlePartial;
  }

  static bool itemAltered(Item item, String title, String? description,
      double price, bool imgAltered) {
    if (imgAltered) return true;
    if (item.title == title) {
      bool descriptionVerif1 = item.description == description;
      bool descriptionVerif2 = (item.description == null && description == "");
      bool descriptionVerif3 = (item.description == "" && description == null);
      if (descriptionVerif1 || descriptionVerif2 || descriptionVerif3) {
        if (item.price.toStringAsFixed(2) == price.toStringAsFixed(2)) {
          return false;
        }
      }
    }
    return true;
  }
}