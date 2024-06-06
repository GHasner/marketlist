import 'package:flutter/material.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/services/item_shared_preferences.dart';

// Se categ = "" exibe todas os produtos

class ItemListScreen extends StatefulWidget {
  final String categ;

  const ItemListScreen({super.key, required this.categ});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  String get _selection => widget.categ;
  late String _categ;
  late String autoRef;
  late bool itemListIsEmpty;

  Future<void> searchForItems() async {
    itemListIsEmpty = await ItemPreferencesService.get() == [];
  }

  void getStrings() {
    if (_selection == "") {
      autoRef = "";
      _categ = "Todos os produtos";
    } else {
      autoRef = " nesta categoria";
      _categ = _selection;
    }
  }

  @override
  void initState() {
    super.initState();

    searchForItems();
    getStrings();
  }

  Widget loadItems() {
    if (itemListIsEmpty) return Text("Não há nenhum produto registado$autoRef.");
    return FutureBuilder<List<Item>?>(
      future: ItemPreferencesService.get(),
      builder: (context, AsyncSnapshot<List<Item>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Ocorreu um erro ao carregar os items: ${snapshot.error}');
        } else if (snapshot.hasData) {
          if(snapshot.data != null) {
            // TileList
          }
        }
        return Text("Não há nenhum produto registado$autoRef.");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Text(_categ),
          loadItems(),
          // create Categ TileList
        ],
      ),
    );
  }
}