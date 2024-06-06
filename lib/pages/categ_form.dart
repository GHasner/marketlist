import 'package:flutter/material.dart';
import 'package:marketlist/services/categ_controller.dart';
import 'package:marketlist/services/categ_shared_preferences.dart';

class CategFormScreen extends StatefulWidget {
  const CategFormScreen({super.key});

  @override
  State<CategFormScreen> createState() => _CategFormScreenState();
}

class _CategFormScreenState extends State<CategFormScreen> {
  late CategController categController;

  Future<void> getSavedCategories() async {
    categController = CategController(savedCategories: await CategPreferencesService.get());
  }

  @override
  void initState() {
    super.initState();

    getSavedCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}