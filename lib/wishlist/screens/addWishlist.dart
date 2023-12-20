import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:readme_mobile/books/screens/list_books.dart';
import 'package:readme_mobile/wishlist/models/wishlistFields.dart';
import 'package:readme_mobile/wishlist/screens/wishlist.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:readme_mobile/constants/constants.dart';

import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddWishlistPage extends StatefulWidget {
  final id;
  const AddWishlistPage(this.id, {Key? key}) : super(key: key);

  @override
  State<AddWishlistPage> createState() => _AddWishlistPageState();
}

class _AddWishlistPageState extends State<AddWishlistPage> {
  final _formKey = GlobalKey<FormState>();
  String _note = "";
  var color1 = Color.fromARGB(208, 242, 172, 59);
  var color2 = Color.fromARGB(255, 255, 205, 119);
  var color3 = Color.fromARGB(255, 255, 240, 215);

  void _submitWishlist(request, context) async {
    // var url = Uri.parse('$baseUrl/wishlist');
    var response =
        await request.post('$baseUrl/wishlist/add/${widget.id}', {'note': _note}
            // headers: {"Content-Type": "application/json"},
            );
    print(response);
    if (response['status']) {
      print(response);
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     title: const Text('Berhasil menambahkan wishlist'),
      //     content: Text(response['message']),
      //     actions: [
      //       TextButton(
      //         child: const Text('OK'),
      //         onPressed: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //     ],
      //   ),
      // );
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GestureDetector(
              // onTap: () {
              //   // Navigate to ListBooks when tapping outside the content
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const ListBooks(),
              //     ),
              //   );
              // },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Berhasil! Note: $_note'),
                    // TODO: Display other values if needed
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  }),
            ],
          );
        },
      );
      Navigator.pop(context);
      // var data = jsonDecode(utf8.decode(response.bodyBytes));
      // var wishlist = Wishlist.fromJson(data);

      // print(wishlist); // Add this line to print the wishlist
      // return wishlist;
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal menambahkan wishlist'),
          content: Text(response['message']),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(24.0),
          margin: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
              colors: [color1, color2, color3],
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Note",
                    labelText: "Note",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _note = value;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Note cannot be empty!";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       content: GestureDetector(
                      //         // onTap: () {
                      //         //   // Navigate to ListBooks when tapping outside the content
                      //         //   Navigator.push(
                      //         //     context,
                      //         //     MaterialPageRoute(
                      //         //       builder: (context) => const ListBooks(),
                      //         //     ),
                      //         //   );
                      //         // },
                      //         child: SingleChildScrollView(
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.start,
                      //             children: [
                      //               Text('Berhasil! Note: $_note'),
                      //               // TODO: Display other values if needed
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       actions: [
                      //         TextButton(
                      //             child: const Text('OK'),
                      //             onPressed: () {
                      //               _submitWishlist(request, context);
                      //               // Navigator.pop(context);
                      //             }),
                      //       ],
                      //     );
                      //   },
                      // );
                      _submitWishlist(request, context);
                      _formKey.currentState!.reset();
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
