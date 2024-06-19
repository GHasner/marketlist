// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class FormValidations {
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

  static Future<File?> pickImage(BuildContext context) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Nenhuma imagem selecionada.'),
          backgroundColor: Colors.red,
        ));
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao selecionar imagem: $e'),
        backgroundColor: Colors.red,
      ));
      return null;
    }
  }

  static Future<bool> compareFiles(
      BuildContext context, String file1Path, String file2Path) async {
    try {
      final file1 = File(file1Path);
      final file2 = File(file2Path);
      final dataFile1 = await file1.readAsBytes();
      final dataFile2 = await file2.readAsBytes();

      if (dataFile1.length != dataFile2.length) {
        return false; // Os arquivos tem tamanhos diferentes
      }

      for (int i = 0; i < dataFile1.length; i++) {
        if (dataFile1[i] != dataFile2[i]) {
          return false; // Os arquivos divergem
        }
      }
      return true;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) =>
            const AlertDialog(content: Text("Erro ao processar imagem.")),
      );
      return false;
    }
  }
}

class FormFields {
  static Widget label(String label) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(label),
    );
  }

  static Widget textField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
      ),
    );
  }

  static Widget imagePlaceholder(File? image) {
    if (image == null) {
      return Container(
        width: 300,
        height: 200,
        padding: const EdgeInsets.only(bottom: 10),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: Color.fromARGB(255, 55, 71, 79),
              size: 40,
            ),
            Text(
              "Clique para selecionar uma imagem",
              style: TextStyle(color: Color.fromARGB(255, 55, 71, 79)),
            )
          ],
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: 200,
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey),
          image: DecorationImage(
            image: FileImage(image),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  static Widget confirmButtons(
      BuildContext context, Future<bool> altered, void function) {
    return Row(
      children: <Widget>[
        ElevatedButton(
          onPressed: () async {
            if (!(await altered)) {
              PreviousPageRedirect.redirectProductPage(context);
            } else {
              CustomPopUps.dialog(
                context,
                "cancelForm",
                "Continuar",
                "Confirmar",
                PreviousPageRedirect.redirectProductPage(context),
              );
            }
          },
          child: const Text("Cancelar"),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            if(await altered) {
              function;
            }
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}

class CustomPopUps {
  static void editDeleteModal(
      BuildContext context, void redirectEdit, void deleteDialog) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Row(
          children: <Widget>[
            ElevatedButton(
              onPressed: () => redirectEdit,
              child: const Column(
                children: <Widget>[Icon(Icons.edit), Text("Editar")],
              ),
            ),
            ElevatedButton(
              onPressed: () => deleteDialog,
              child: const Column(
                children: <Widget>[Icon(Icons.delete), Text("Deletar")],
              ),
            ),
          ],
        );
      },
    );
  }

  static void dialog(BuildContext context, String action, String cancel,
      String confirm, void function) {
    String title = "";
    Widget? dialogTitle;
    String content = "";
    switch (action) {
      case 'deleteCateg':
        title = "Excluir Categoria";
        content = "Tem certeza de que deseja excluir esta categoria?";
        break;
      case 'deleteItem':
        title = "Excluir Item";
        content = "Tem certeza de que deseja excluir este item?";
        break;
      case 'cancelForm':
        content =
            "Todas as suas alterações serão perdidas, tem certeza de que deseja voltar sem salvar?";
        break;
    }
    if (title != "") {
      dialogTitle = Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          // color: ,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: dialogTitle,
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 16,
              // color: ,
            ),
          ),
          actions: <Widget>[
            // Opcão: Cancelar ação
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.neutral),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
              child: Text(
                cancel,
                style: const TextStyle(fontSize: 15),
              ),
            ),
            // Opção: Confirmar ação
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.cancel),
              ),
              onPressed: () {
                function;
                Navigator.of(context).pop();
              },
              child: Text(
                confirm,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }
}
