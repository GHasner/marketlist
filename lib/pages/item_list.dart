import 'package:flutter/material.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/pages/item_form.dart';
import 'package:marketlist/services/form_controller.dart';
import 'package:marketlist/services/item_controller.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';

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
    NavigationStateSharedPreferences.saveProductPageState(_selection);
    _searchForItems();
    _getStrings();
    
    super.initState();
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
          onLongPress: () =>
              _selectedItemOptions(ItemController.filteredItems![index]),
        );
      },
    );
  }

  void _selectedItemOptions(Item item) {
    CustomPopUps.editDeleteModal(
      context,
      MaterialPageRoute(builder: (context) => ItemFormScreen(item: item)),
      CustomPopUps.dialog(
        context,
        "deleteItem",
        "Cancelar",
        "Excluir",
        setState(() {
          ItemController.delete(item);
          _searchForItems();
        }),
      ),
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
