import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  // Fetch data from API here

  @override
  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text(
          'Wishlist',
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Under Construction',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
