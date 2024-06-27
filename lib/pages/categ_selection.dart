import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/pages/categ_form.dart';
import 'package:marketlist/pages/item_list.dart';
import 'package:marketlist/pages/widgets/form_fields.dart';
import 'package:marketlist/services/categ_controller.dart';
import 'package:marketlist/services/categ_shared_preferences.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

class CategSelectScreen extends StatefulWidget {
  const CategSelectScreen({super.key});

  @override
  State<CategSelectScreen> createState() => _CategSelectScreenState();
}

class _CategSelectScreenState extends State<CategSelectScreen> {
  @override
  void initState() {
    super.initState();

    NavigationStateSharedPreferences.saveProductPageState('notSelected');
  }

  Widget _loadCategories() {
    if (CategController.savedCategories.isEmpty) {
      return const SizedBox(height: 20);
    }
    return FutureBuilder<List<Categ>?>(
      future: CategPreferencesService.get(),
      builder: (context, AsyncSnapshot<List<Categ>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
              'Ocorreu um erro ao carregar as categorias: ${snapshot.error}');
        } else if (snapshot.hasData) {
          _categoriesList(snapshot.data);
        }
        return const SizedBox(height: 20);
      },
    );
  }

  Widget _categoriesList(List<Categ>? categList) {
    return ListView.builder(
      itemCount: categList!.length,
      itemBuilder: (context, index) {
        if (index + 1 < categList.length) {
          if ((index + 1) % 2 != 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onLongPress: () => _selectedCategOptions(categList[index]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ItemListScreen(categ: categList[index].title))),
                  child: Container(
                    width: 159,
                    height: 159,
                    color: ThemeColors.background,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            image: DecorationImage(
                              image: FileImage(File(categList[index].imgPath!)),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(categList[index].title),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPress: () => _selectedCategOptions(categList[index + 1]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ItemListScreen(categ: categList[index + 1].title))),
                  child: Container(
                    width: 159,
                    height: 159,
                    color: ThemeColors.background,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            image: DecorationImage(
                              image: FileImage(File(categList[index + 1].imgPath!)),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(categList[index + 1].title),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        }
        if (index == 0 || index % 2 == 0) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onLongPress: () => _selectedCategOptions(categList[index]),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ItemListScreen(categ: categList[index].title))),
                  child: Container(
                    width: 159,
                    height: 159,
                    color: ThemeColors.background,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 120,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            image: DecorationImage(
                              image: FileImage(File(categList[index].imgPath!)),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Text(categList[index].title),
                      ],
                    ),
                  ),
                ),
                _addButton(),
              ],
            );
        }
        return Container(
          width: 340,
          alignment: Alignment.centerLeft,
          child: _addButton(),
        );
      },
    );
  }

  void _selectedCategOptions(Categ categ) {
    CustomPopUps.editDeleteModal(
      context,
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategFormScreen(categ: categ))),
      CustomPopUps.dialog(
        context,
        "deleteCateg",
        "Cancelar",
        "Excluir",
        setState(() {
          CategController.delete(categ);
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 12),
          height: double.infinity,
          width: 340,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 48), // Padding
                _unselectedButton(),
                _loadCategories(),
                _addButton(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget _unselectedButton() {
    return SizedBox(
      height: 50,
      width: 340,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ItemListScreen(categ: '')));
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ThemeColors.background,
        ),
        child: Text(
          "Todos os Produtos",
          style: GoogleFonts.poppins(
            color: ThemeColors.secondary,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return SizedBox(
      height: 159,
      width: 159,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CategFormScreen(categ: null)));
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: ThemeColors.background,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.add,
              size: 80,
              color: ThemeColors.tertiaryDarkMedium,
            ),
            Text(
              "Nova Categoria",
              style: GoogleFonts.poppins(
                color: ThemeColors.tertiaryDarkMedium,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
