// ignore_for_file: use_build_context_synchronously
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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

  static String formatPrice (double price) {
    String decimals = price.toString().split('.').last;
    String integerPart = price.toString().split('.').first;
    String temp = "";
    int countThousand = 1;
    for (int i = integerPart.length - 1; i >= 0; i--) {
      if (countThousand == 3 && (i - 1) != 0) {
        temp += ".";
        countThousand = 0;
      }
      temp += integerPart[i];
      countThousand++;
    }
    String formatedPrice = "R\$ ";
    for (int i = temp.length - 1; i >= 0; i--) {
      formatedPrice += integerPart[i];
    }
    formatedPrice = '$formatedPrice,$decimals';
    return formatedPrice;
  }

  static double convertPriceToDouble (String price) {
    String unformatedPrice = price;
    unformatedPrice = unformatedPrice.replaceAll("R\$", "");
    unformatedPrice = unformatedPrice.replaceAll(" ", "");
    unformatedPrice = unformatedPrice.replaceAll(",", ".");
    double value = double.parse(unformatedPrice);
    return value;
  }
}

class CurrencyInputFormatter extends TextInputFormatter {

    @override
      TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {

        if(newValue.selection.baseOffset == 0){
            return newValue;
        }

        double value = double.parse(newValue.text);

        final formatter = NumberFormat.simpleCurrency(locale: "pt_Br");

        String newText = formatter.format(value/100);

        return newValue.copyWith(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length));
    }
}