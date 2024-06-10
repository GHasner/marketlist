import 'package:marketlist/models/item.dart';
import 'package:marketlist/services/item_shared_preferences.dart';

class ItemController {
  static List<Item>? savedItems;
  static List<Item>? filteredItems;
  static List<Item>? shopCart;

  const ItemController();

  static Future<void> getData() async {
    savedItems = await ItemPreferencesService.get();
  }

  static Future<void> setData() async {
    await ItemPreferencesService.save(savedItems!);
  }

  static void filterByCateg(String categTitle) {
    filteredItems = savedItems!.where((item) => item.categ == categTitle).toList();
  }
  
  static void removeFilter() {
    filteredItems = savedItems;
  }

  static void refreshMarketList() {
    shopCart = savedItems!.where((item) => item.quant > 0).toList();
  }

  // Get is implemented implicitly through FutureBuilder or accessing one of the static lists directly

  static void insert(Item item) {
    savedItems!.add(item);
    setData();
  }

  static void update(Item itemOld, Item itemNew) {
    int index = savedItems!.indexOf(itemOld);
    savedItems![index] = itemNew;
    setData();
  }

  static void updateQnt(Item item, int alt) {
    int newQnt = item.quant + alt;
    Item updatedItem = Item(categ: item.categ, title: item.title, price: item.price, quant: newQnt);
    update(item, updatedItem);
  }

  static void delete(Item item) {
    savedItems!.remove(item);
    setData();
  }
}