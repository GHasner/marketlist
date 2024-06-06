import 'package:flutter/material.dart';
import 'package:marketlist/models/categ.dart';
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
          if(snapshot.data != null) {
            // TileList
          }
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
            onPressed: () {},
            child: const Text("Todos os Produtos"),
          ),
          loadCategories(),
          // create Categ TileList
        ],
      ),
    );
  }
}