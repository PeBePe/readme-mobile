import 'package:flutter/material.dart';
import 'package:readme_mobile/readme/screens/login.dart';
import 'package:readme_mobile/readme/screens/profile.dart';
import 'package:readme_mobile/readme/screens/menu.dart';
import 'package:readme_mobile/shop/screens/shop.dart';
import 'package:readme_mobile/quotes/screens/quotes.dart';
import 'package:readme_mobile/books/screens/list_books.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:readme_mobile/constants/constants.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
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
                  "Buka wawasan barumu melalui buku di sini.",
                  style: TextStyle(
                    color: Color(0xFF1E1915),
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
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
                  builder: (context) => const MyHomePage(),
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
                  builder: (context) => const ListBooks(),
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
                  builder: (context) => const ProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              var response = await request.get('$baseUrl/auth/logout');
              if (response['status']) {
                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              } else {
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout failed')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
