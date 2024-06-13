// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FormValidations {
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
    final file1 = File(file1Path);
    final file2 = File(file2Path);

    try {
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
      return const SizedBox(
        width: 300,
        height: 200,
        child: Column(
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
}
