import 'package:flutter/material.dart';
import 'package:marketlist/models/categ.dart';
import 'package:marketlist/services/categ_controller.dart';

class CategFormScreen extends StatefulWidget {
  final Categ? categ;

  const CategFormScreen({super.key, this.categ});

  @override
  State<CategFormScreen> createState() => _CategFormScreenState();
}

class _CategFormScreenState extends State<CategFormScreen> {
  Categ? get _categ => widget.categ;

  // Se categ == null ADD Else EDIT 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
