import 'package:flutter/material.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/services/item_controller.dart';

class MarketListScreen extends StatefulWidget {
  const MarketListScreen({super.key});

  @override
  State<MarketListScreen> createState() => _MarketListScreenState();
}

class _MarketListScreenState extends State<MarketListScreen> {
  late List<Item>? _shopCart;

  @override
  void initState() {
    super.initState();
    ItemController.refreshMarketList();
    _shopCart = ItemController.shopCart;
  }

  Widget _marketList() {
    if(_shopCart == null || _shopCart!.isEmpty) {
      return const Text("Sua lista de compras está vazia.");
    } else {
      return ListView.builder(
        itemCount: _shopCart!.length,        
        itemBuilder: (context, index) {
          
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _marketList(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
