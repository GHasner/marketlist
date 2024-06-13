import 'package:flutter/material.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/pages/item_form.dart';
import 'package:marketlist/services/item_controller.dart';
import 'package:marketlist/services/item_shared_preferences.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

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

  Future<void> _searchForItems() async {
    await ItemController.getData();
    itemListIsEmpty = ItemController.savedItems == [];
    if (!itemListIsEmpty) {
      if (_selection != '') {
        ItemController.filterByCateg(_selection);
        if (ItemController.filteredItems == null ||
            ItemController.filteredItems!.isEmpty) {
          itemListIsEmpty = true;
        }
      } else {
        ItemController.removeFilter();
      }
    }
  }

  void _getStrings() {
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

    _searchForItems();
    _getStrings();
  }

  Widget _loadItems() {
    if (itemListIsEmpty) {
      return Text("Não há nenhum produto registado$autoRef.");
    }
    return ListView.builder(
      itemCount: ItemController.filteredItems!.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.asset(ItemController.filteredItems![index].imgPath!),
          title: Text(ItemController.filteredItems![index].title),
          subtitle: Text(ItemController.filteredItems![index].description!),
          trailing: Row(
            children: <Widget>[
              Text(ItemController.filteredItems![index].price.toString()),
              ElevatedButton(
                onPressed: () {
                  ItemController.updateQnt(
                      ItemController.filteredItems![index], 1);
                },
                child: const Icon(Icons.add),
              ),
            ],
          ),
          onLongPress: () => _selectedItemOptions(ItemController.filteredItems![index]),
        );
      },
    );
  }

  void _selectedItemOptions(Item item) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Row(
            children: <Widget>[
              ElevatedButton(
                onPressed: () => MaterialPageRoute(
                    builder: (context) => ItemFormScreen(item: item)),
                child: const Column(
                  children: <Widget>[Icon(Icons.delete), Text("Deletar")],
                ),
              ),
              ElevatedButton(
                onPressed: () => _confirmDelete(item),
                child: const Column(
                  children: <Widget>[Icon(Icons.delete), Text("Deletar")],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(Item item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Excluir Item",
            style: TextStyle(
              fontSize: 20,
              // color: ,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            "Tem certeza de que deseja excluir este item?",
            style: TextStyle(
              fontSize: 16,
              // color: ,
            ),
          ),
          actions: <Widget>[
            // Opcão: Cancelar
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.neutral),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                return;
              },
              child: const Text(
                "Cancelar",
                style: TextStyle(fontSize: 15),
              ),
            ),
            // Opção: Excluir
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(ThemeColors.cancel),
              ),
              onPressed: () {
                setState(() {
                  ItemController.delete(item);
                  _searchForItems();
                });
                Navigator.of(context).pop();
              },
              child: const Text(
                "Excluir",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_categ),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (String option) {
              switch (option) {
                case "newItem":
                  MaterialPageRoute(
                      builder: (context) => const ItemFormScreen(item: null));
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem(
                  value: "newItem",
                  child: Text("Novo Item"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(_categ),
          _loadItems(),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
