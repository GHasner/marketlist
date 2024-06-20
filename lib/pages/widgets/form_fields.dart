// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

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