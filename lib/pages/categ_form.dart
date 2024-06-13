// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/services/categ_controller.dart';
import 'package:marketlist/services/form_controller.dart';

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

  String _imgPath = Directory.current.path + "assets/images/saved/";
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
    return Column(
      children: <Widget>[
        FormFields.label('Título *'),
        FormFields.textField(_title),
        FormFields.label('Descrição'),
        FormFields.textField(_description),
        FormFields.label('Imagem *'),
        GestureDetector(
          child: FormFields.imagePlaceholder(_image),
          onTap: () async {
            _image = await FormValidations.pickImage(context);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_refTitle)),
      body: _form(),
    );
  }
}
