import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/pages/widgets/form_fields.dart';
import 'package:marketlist/services/emulator_API.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;

  const ItemFormScreen({super.key, required this.item});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  Item? get _item => widget.item;

  late bool _newItem;
  String _refTitle = "Novo Item";

  String _imgPath = "${Directory.current.path}assets/images/saved/";
  File? _image;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _description = TextEditingController();

  void _initForm(bool isNew) {
    if (!isNew) {
      _refTitle = _item!.title;
      _title.text = _item!.title;
      _description.text = _item!.description!;
      _imgPath += _item!.imgPath!;
      _image = File(_imgPath);
    }
  }

  @override
  void initState() {
    super.initState();
    // Se item == null ADD Else EDIT
    _newItem = _item == null;
    _initForm(_newItem);
  }

  Widget _form() {
    return Column(
      children: <Widget>[
        FormFields.label('Título *'),
        FormFields.textField(_title),
        FormFields.label('Preço *'),
        _monetaryField(_price),
        FormFields.label('Descrição'),
        FormFields.textField(_description),
        FormFields.label('Imagem *'),
        GestureDetector(
          child: FormFields.imagePlaceholder(_image),
          onTap: () async {
            _image = await EmulatorAPI.pickImage(context);
          },
        ),
      ],
    );
  }

  Widget _monetaryField(TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: _price,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          prefix: Text('R\$'),
        ),
      ),
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
