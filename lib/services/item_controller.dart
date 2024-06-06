import 'package:marketlist/models/item.dart';

class ItemController {
  final List<Item>? savedItems;
  static List<Item>? filteredItems;

  const ItemController({required this.savedItems});

  void filterByCateg(String categTitle) {
    filteredItems = savedItems!.where((item) => item.categ == categTitle).toList();
  }
  
  void removeFilter() {
    filteredItems = savedItems;
  }

  void updateItem(Item itemOld, Item itemNew) {
    int index = savedItems!.indexOf(itemOld);
    savedItems![index] = itemNew;
  }
}