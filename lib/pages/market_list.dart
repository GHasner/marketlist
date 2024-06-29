import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketlist/models/item.dart';
import 'package:marketlist/pages/bottomNavigationBar.dart';
import 'package:marketlist/services/item_controller.dart';
import 'package:marketlist/src/shared/themes/colors.dart';

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
    if (_shopCart == null || _shopCart!.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 200),
        child: Text(
          "Sua lista de compras está vazia.",
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: _shopCart!.length,
        itemBuilder: (context, index) {
          return null;
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: Center(
        child: Container(
          padding: const EdgeInsets.only(top: 60),
          height: double.infinity,
          width: 340,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _marketList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
