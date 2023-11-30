import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/screens/shop.dart';
import 'package:readme_mobile/readme/screens/menu.dart';

class MenuCard extends StatelessWidget {
  final MenuItem menuItem;

  const MenuCard(this.menuItem, {super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return Material(
      color: menuItem.color,
      child: InkWell(
        // Area responsive terhadap sentuhan
        onTap: () {
          // Memunculkan SnackBar ketika diklik
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
                content: Text("Kamu telah menekan tombol ${menuItem.name}!")));
          // Navigate ke route yang sesuai (tergantung jenis tombol)
          if (menuItem.name == "Shop") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ShopPage()),
            );
          }
        },
        child: Container(
          // Container untuk menyimpan Icon dan Text
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  menuItem.icon,
                  color: Colors.white,
                  size: 30.0,
                ),
                const Padding(padding: EdgeInsets.all(3)),
                Text(
                  menuItem.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
