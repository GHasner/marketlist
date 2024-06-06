import 'package:marketlist/models/item.dart';

class ItemController {
  final List<Item>? savedItems;
  static List<Item>? filteredItems;
  static List<Item>? shopCart;

  const ItemController({required this.savedItems});

  void filterByCateg(String categTitle) {
    filteredItems = savedItems!.where((item) => item.categ == categTitle).toList();
  }
  
  void removeFilter() {
    filteredItems = savedItems;
  }

  void getMarketList() {
    shopCart = savedItems!.where((item) => item.quant > 0).toList();
  }

  // Get is implemented implicitly through FutureBuilder

  // Insert is implemented directly through list.Add(Item newItem);

  void updateItem(Item itemOld, Item itemNew) {
    int index = savedItems!.indexOf(itemOld);
    savedItems![index] = itemNew;
  }

  // Insert is implemented directly through list.Remove(Item oldItem);
}