import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/pages/categ_selection.dart';
import 'package:marketlist/pages/item_form.dart';
import 'package:marketlist/pages/widgets/form_fields.dart';
import 'package:marketlist/services/form_controller.dart';
import 'package:marketlist/services/item_controller.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

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
  late bool itemListIsEmpty = true;

  Stopwatch? _pressTimer;

  Future<void> _searchForItems() async {
    await ItemController.getData();
    itemListIsEmpty = ItemController.savedItems == [];
    if (!itemListIsEmpty) {
      if (_selection != "") {
        ItemController.filterByCateg(_selection);
        if (ItemController.filteredItems.isEmpty) {
          setState(() {
            itemListIsEmpty = true;
          });
        } else {
          setState(() {
            itemListIsEmpty = false;
          });
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
    NavigationStateSharedPreferences.saveProductPageState(_selection);
    _searchForItems();
    _getStrings();
  }

  Widget _loadItems() {
    if (itemListIsEmpty) {
      return Text(
        "Não há nenhum produto registado$autoRef.",
        textAlign: TextAlign.left,
        style: GoogleFonts.poppins(
          fontSize: 16,
        ),
      );
    }
    return SizedBox(
      width: 340,
      height: 540,
      child: ListView.builder(
        itemCount: ItemController.filteredItems.length,
        padding: const EdgeInsets.all(0),
        itemBuilder: (context, index) {
          if (index + 1 < ItemController.filteredItems.length) {
            if ((index + 1) % 2 != 0) {
              return Container(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: (details) {
                        _pressTimer = Stopwatch();
                        _pressTimer!.start();
                      },
                      onTapCancel: () {
                        _pressTimer = null;
                      },
                      onTapUp: (details) {
                        if (_pressTimer != null) {
                          _pressTimer!.stop();
                          if (_pressTimer!.elapsedMilliseconds > 600) {
                            // LongPress
                            _selectedItemOptions(
                                ItemController.filteredItems[index]);
                          } else {
                            // Tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemFormScreen(
                                        item:
                                            ItemController.filteredItems[index],
                                        categ: _categ,
                                      )),
                            );
                          }
                        }
                      },
                      child: Container(
                        width: 159,
                        height: 320,
                        color: ThemeColors.background,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 159,
                              height: 159,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ThemeColors.container,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 120,
                                width: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(ItemController
                                        .filteredItems[index].imgPath!)),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 13),
                              alignment: Alignment.topLeft,
                              height: 64,
                              width: 156,
                              child: Text(
                                ItemController.filteredItems[index].title,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.secondary,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 48,
                              width: 156,
                              child: Text(
                                FormValidations.formatPrice(
                                    ItemController.filteredItems[index].price),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.emphasis,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ItemController.updateQnt(
                                    ItemController.filteredItems[index], 1);
                              },
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(159, 40),
                                minimumSize: const Size(159, 40),
                                backgroundColor: ThemeColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide.none,
                                ),
                                padding: const EdgeInsets.only(left: 11),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: ThemeColors.background,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Text(
                                    "Adicionar",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeColors.background,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTapDown: (details) {
                        _pressTimer = Stopwatch();
                        _pressTimer!.start();
                      },
                      onTapCancel: () {
                        _pressTimer = null;
                      },
                      onTapUp: (details) {
                        if (_pressTimer != null) {
                          _pressTimer!.stop();
                          if (_pressTimer!.elapsedMilliseconds > 600) {
                            // LongPress
                            _selectedItemOptions(
                                ItemController.filteredItems[index + 1]);
                          } else {
                            // Tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemFormScreen(
                                        item: ItemController
                                            .filteredItems[index + 1],
                                        categ: _categ,
                                      )),
                            );
                          }
                        }
                      },
                      child: SizedBox(
                        width: 159,
                        height: 320,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 159,
                              height: 159,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ThemeColors.container,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 120,
                                width: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(ItemController
                                        .filteredItems[index + 1].imgPath!)),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 13),
                              alignment: Alignment.topLeft,
                              height: 64,
                              width: 156,
                              child: Text(
                                ItemController.filteredItems[index + 1].title,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.secondary,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 48,
                              width: 156,
                              child: Text(
                                FormValidations.formatPrice(ItemController
                                    .filteredItems[index + 1].price),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.emphasis,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ItemController.updateQnt(
                                    ItemController.filteredItems[index + 1], 1);
                              },
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(159, 40),
                                minimumSize: const Size(159, 40),
                                backgroundColor: ThemeColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide.none,
                                ),
                                padding: const EdgeInsets.only(left: 11),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: ThemeColors.background,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Text(
                                    "Adicionar",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeColors.background,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          }
          if (ItemController.filteredItems.isNotEmpty) {
            if (index == 0 || index % 2 == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTapDown: (details) {
                        _pressTimer = Stopwatch();
                        _pressTimer!.start();
                      },
                      onTapCancel: () {
                        _pressTimer = null;
                      },
                      onTapUp: (details) {
                        if (_pressTimer != null) {
                          _pressTimer!.stop();
                          if (_pressTimer!.elapsedMilliseconds > 600) {
                            // LongPress
                            _selectedItemOptions(
                                ItemController.filteredItems[index]);
                          } else {
                            // Tap
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ItemFormScreen(
                                        item:
                                            ItemController.filteredItems[index],
                                        categ: _categ,
                                      )),
                            );
                          }
                        }
                      },
                      child: SizedBox(
                        width: 159,
                        height: 320,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: 159,
                              height: 159,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: ThemeColors.container,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 120,
                                width: 150,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: FileImage(File(ItemController
                                        .filteredItems[index].imgPath!)),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 13),
                              alignment: Alignment.topLeft,
                              height: 64,
                              width: 156,
                              child: Text(
                                ItemController.filteredItems[index].title,
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.secondary,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 48,
                              width: 156,
                              child: Text(
                                FormValidations.formatPrice(
                                    ItemController.filteredItems[index].price),
                                textAlign: TextAlign.start,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: ThemeColors.emphasis,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ItemController.updateQnt(
                                    ItemController.filteredItems[index], 1);
                              },
                              style: ElevatedButton.styleFrom(
                                maximumSize: const Size(159, 40),
                                minimumSize: const Size(159, 40),
                                backgroundColor: ThemeColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide.none,
                                ),
                                padding: const EdgeInsets.only(left: 11),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                    child: Icon(
                                      Icons.shopping_cart,
                                      color: ThemeColors.background,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 24),
                                  Text(
                                    "Adicionar",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: ThemeColors.background,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  void _selectedItemOptions(Item item) {
    CustomPopUps.editDeleteModal(
      context,
      MaterialPageRoute(
          builder: (context) => ItemFormScreen(item: item, categ: _categ)),
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
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategSelectScreen())),
              child: const Icon(Icons.arrow_back),
            ),
            const SizedBox(width: 28), // Padding
            Text(
              _categ,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (String option) {
              switch (option) {
                case "newItem":
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemFormScreen(
                              item: null,
                              categ: _categ,
                            )),
                  );
                  break;
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "newItem",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Novo Item",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ThemeColors.primaryDark,
                        ),
                      ),
                      Icon(
                        Icons.add_circle_outline_rounded,
                        color: ThemeColors.primaryDark,
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: ThemeColors.background,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 12),
          height: double.infinity,
          width: 340,
          child: SingleChildScrollView(
            child: _loadItems(),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
