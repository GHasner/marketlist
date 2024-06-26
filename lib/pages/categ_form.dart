// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/pages/categ_selection.dart';
import 'package:marketlist/pages/widgets/form_fields.dart';
import 'package:marketlist/services/categ_controller.dart';
import 'package:marketlist/services/emulator_API.dart';
import 'package:marketlist/services/file_controller.dart';
import 'package:marketlist/services/item_controller.dart';

class CategFormScreen extends StatefulWidget {
  final Categ? categ;

  const CategFormScreen({super.key, this.categ});

  @override
  State<CategFormScreen> createState() => _CategFormScreenState();
}

class _CategFormScreenState extends State<CategFormScreen> {
  Categ? get _categ => widget.categ;
  late bool _newCateg;
  String _refTitle = "Nova Categoria";

  String _imgPath = "";
  File? _image;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();

  void _initForm(bool isNew) {
    if (!isNew) {
      _refTitle = _categ!.title;
      _title.text = _categ!.title;
      _description.text = _categ!.description!;
      _imgPath += _categ!.imgPath!;
      _image = File(_imgPath);
    }
  }

  @override
  void initState() {
    super.initState();
    // Se categ == null ADD Else EDIT
    _newCateg = _categ == null;
    _initForm(_newCateg);
  }

  Widget _form() {
    return SingleChildScrollView(
      child: Center(
        child: SizedBox(
          height: 680,
          width: 340,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 20), // Padding
                  FormFields.textField(_title, 'Título', Icons.label_outline),
                  const SizedBox(height: 14), // Padding
                  FormFields.textField(
                      _description, 'Descrição (Opcional)', Icons.short_text),
                  const SizedBox(height: 14), // Padding
                  GestureDetector(
                    child: FormFields.imagePlaceholder(_image),
                    onTap: () {
                      setState(() async {
                        _image = await EmulatorAPI.pickImage(context);
                      });
                    },
                  ),
                ],
              ),
              FormFields.confirmButtons(
                context,
                _checkForAlterations(),
                _save(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _refTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _form(),
    );
  }

  Future<bool> _checkForAlterations() async {
    if (_categ == null) {
      if (_title.text != "") return true;
      if (_description.text != "") return true;
      if (_image != null) return true;
      return false;
    } else {
      if (_title.text != _categ!.title) return true;
      if (_description.text != _categ!.description) return true;
      if (_image != null) {
        Future<bool> sameImg =
            FileController.compareFiles(context, _categ!.imgPath!, _image!);
        if (await sameImg) return true;
      }
      return false;
    }
  }

  void _save() async {
    if (_image == null) {
      // ERRO: Selecione uma imagem
      return;
    }
    String? titleValidation = CategController.searchAlike(_title.text, _categ);
    switch (titleValidation) {
      case 'titleEmpty': // ERRO: Título Inválido
        return;
      case 'tooLong': // ERRO: Título Inválido
        return;
      case 'invalidChars': // ERRO: Título Inválido
        return;
      case 'titleInvalid': // ERRO: Título Inválido
        return;
    }

    // Salva imagem
    Future<bool> sameImg =
        FileController.compareFiles(context, _categ!.imgPath!, _image!);
    if (await sameImg) {
      if (_categ != null) {
        if (_categ!.title.replaceAll(" ", "").toLowerCase() !=
            _title.text.replaceAll(" ", "").toLowerCase()) {
          _imgPath = _title.text.replaceAll(" ", "").toLowerCase() +
              _image!.path.split('.').last;
          FileController.rename(_categ!.imgPath!, _imgPath);
        } else {
          _imgPath = _categ!.imgPath!;
        }
      }
    } else {
      _imgPath = _title.text.replaceAll(" ", "").toLowerCase() +
          _image!.path.split('.').last;
      if (_categ != null) {
        FileController.delete(_categ!.imgPath!);
      }
      FileController.save(_image!, _imgPath);
    }

    // Salva alterações
    if (_categ != null) {
      // Caso seja EDIT remove a instancial salva
      CategController.delete(_categ!);
      // Fazer alterações para itens da categoria editada
      ItemController.updateCateg(_categ!.title, _title.text);
    }
    // Adiciona nova categoria
    Categ newCateg = Categ(
        title: _title.text, description: _description.text, imgPath: _imgPath);
    CategController.insert(newCateg);

    switch (titleValidation) {
      case 'editOverride': // PASS: Resulta em update de _categ
        break;
      case 'notRegistered': // PASS: Título não registrado
        break;
      case null: // PASS: Nenhum registro, lista vazia
        break;
      default: // titleValidation = versão simplificada do site
        break;
    }

    // Após salvar categoria redireciona para página anterior
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CategSelectScreen()),
    );
  }
}
