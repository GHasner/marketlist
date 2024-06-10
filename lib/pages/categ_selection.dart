import 'package:flutter/material.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/pages/item_list.dart';
import 'package:marketlist/services/categ_shared_preferences.dart';

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
    super.initState();

    searchForCategories();
  }

  Widget loadCategories() {
    if (categListIsEmpty) return const SizedBox(height: 20);
    return FutureBuilder<List<Categ>?>(
      future: CategPreferencesService.get(),
      builder: (context, AsyncSnapshot<List<Categ>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Ocorreu um erro ao carregar as categorias: ${snapshot.error}');
        } else if (snapshot.hasData) {
          ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.asset(snapshot.data![index].imgPath!),
                title: Text(snapshot.data![index].title),
                subtitle: Text(snapshot.data![index].description!),
                onTap: () => MaterialPageRoute(
                  builder: (context) => ItemListScreen(categ: snapshot.data![index].title)),
              );
            },
          );
        }
        return const SizedBox(height: 20);
      },
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
          loadCategories(),
          // create Categ TileList
          ElevatedButton(
            onPressed: () {},
            child: const Text("Nova Categoria"),
          ),
        ],
      ),
    );
  }
}