import 'package:flutter/material.dart';
import 'package:marketlist/models/item.dart';

class ItemFormScreen extends StatefulWidget {
  final Item? item;
  
  const ItemFormScreen({super.key, required this.item});

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  Item? get _item => widget.item;

// Se item == null ADD Else EDIT
// Ao criar um item a qantidade é definida como 0

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}