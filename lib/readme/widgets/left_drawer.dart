import 'package:flutter/material.dart';
import 'package:readme_mobile/readme/screens/profile.dart';
import 'package:readme_mobile/readme/screens/menu.dart';
import 'package:readme_mobile/shop/screens/shop.dart';
import 'package:readme_mobile/quotes/screens/quotes.dart';
import 'package:readme_mobile/books/screens/books.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFAEFDF),
            ),
            child: Column(
              children: [
                Text(
                  'ReadMe',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1915),
                  ),
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  "Hallo Kelompok PBP A03 :D",
                  style: TextStyle(
                    color: Color(0xFF1E1915),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Shop'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ShopPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.format_quote_outlined),
            title: const Text('Quotes'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuotesPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.menu_book_outlined),
            title: const Text('Books'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BooksPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person_outlined),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
