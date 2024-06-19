import 'package:flutter/material.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/pages/categ_form.dart';
import 'package:marketlist/pages/item_list.dart';
import 'package:marketlist/services/categ_controller.dart';
import 'package:marketlist/services/categ_shared_preferences.dart';
import 'package:marketlist/services/form_controller.dart';
import 'package:marketlist/services/navigationState_shared_preferences.dart';

class CategSelectScreen extends StatefulWidget {
  const CategSelectScreen({super.key});

  @override
  State<CategSelectScreen> createState() => _CategSelectScreenState();
}

class _CategSelectScreenState extends State<CategSelectScreen> {
  late bool categListIsEmpty;

  Future<void> searchForCategories() async {
    categListIsEmpty = await CategPreferencesService.get() == [];
  }

  @override
  void initState() {
    NavigationStateSharedPreferences.saveProductPageState('notSelected');
    searchForCategories();

    super.initState();
  }

  Widget _loadCategories() {
    if (categListIsEmpty) return const SizedBox(height: 20);
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
        return ListTile(
          leading: Image.asset(categList[index].imgPath!),
          title: Text(categList[index].title),
          subtitle: Text(categList[index].description!),
          onLongPress: () => _selectedCategOptions(categList[index]),
          onTap: () => MaterialPageRoute(
              builder: (context) =>
                  ItemListScreen(categ: categList[index].title)),
        );
      },
    );
  }

  void _selectedCategOptions(Categ categ) {
    CustomPopUps.editDeleteModal(
      context,
      MaterialPageRoute(builder: (context) => CategFormScreen(categ: categ)),
      CustomPopUps.dialog(
        context,
        "deleteCateg",
        "Cancelar",
        "Excluir",
        setState(() {
          CategController.delete(categ);
          searchForCategories();
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              MaterialPageRoute(
                  builder: (context) => const ItemListScreen(categ: ''));
            },
            child: const Text("Todos os Produtos"),
          ),
          _loadCategories(),
          // create Categ TileList
          ElevatedButton(
            onPressed: () {
              MaterialPageRoute(
                  builder: (context) => const CategFormScreen(categ: null));
            },
            child: const Text("Nova Categoria"),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
