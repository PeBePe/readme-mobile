import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:readme_mobile/wishlist/models/wishlistFields.dart';
import 'package:readme_mobile/books/screens/book_detail.dart';
import 'package:readme_mobile/readme/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/readme/screens/register.dart';
import 'package:readme_mobile/wishlist/screens/editWishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readme_mobile/constants/constants.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  Future<Wishlist> fetchWishlists() async {
    var url = Uri.parse('$baseUrl/wishlist');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      var wishlist = Wishlist.fromJson(data);
      print(wishlist); // Add this line to print the wishlist
      return wishlist;
    } else {
      print("Failed to load wishlists. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      return Wishlist(
          status: false, message: "Failed to load wishlists", wishlists: []);
    }
  }

  void _deleteWishlist(request, id) async {
    var url = Uri.parse('$baseUrl/wishlist/remove/${id}/');
    var response = await http.delete(url, headers: request.headers
        // headers: {"Content-Type": "application/json"},
        );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    print(data);

    if (data['status']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil menghapus wishlist'),
          content: Text(data['message']),
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
      // var data = jsonDecode(utf8.decode(response.bodyBytes));
      // var wishlist = Wishlist.fromJson(data);

      // print(wishlist); // Add this line to print the wishlist
      // return wishlist;
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Gagal menghapus wishlist'),
          content: Text(data['message']),
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 247, 244),
      appBar: AppBar(
        title: const Text(
          'Wishlist',
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(height: 20),
          FutureBuilder(
            future: fetchWishlists(),
            builder: (context, AsyncSnapshot<Wishlist> snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return const Text("Belum ada buku di wishlist kamu, nih ;(");
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snapshot.data?.wishlists?.length ?? 0,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (_, index) {
                    WishlistElement wishlistElement =
                        snapshot.data!.wishlists![index];
                    Book book = wishlistElement.book;
                    print(wishlistElement);

                    // Your existing code...
                    return UnconstrainedBox(
                      child: Container(
                        padding: const EdgeInsetsDirectional.all(20),
                        constraints: const BoxConstraints(
                            maxWidth: 350), // Take full width of its parent
                        width: double.infinity,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              book.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else if (loadingProgress.expectedTotalBytes !=
                                    null) {
                                  return CircularProgressIndicator(
                                    value: loadingProgress
                                            .cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1),
                                  );
                                } else {
                                  return child;
                                }
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Text('Error loading image');
                              },
                            ),
                            const SizedBox(height: 10),
                            Text(
                              book.title,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 231, 231, 231),
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              wishlistElement.note,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0,
                                            2), // changes the shadow position
                                      ),
                                    ],
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100)),
                                  ),
                                  // child: IconButton(
                                  //   icon: const Icon(
                                  //     Icons.bookmark_add_outlined,
                                  //     color: Color.fromARGB(255, 133, 77, 14),
                                  //   ),
                                  //   onPressed: () {
                                  //     // Add your bookmark button logic here
                                  //   },
                                  // ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          elevation: 2.0,
                                          color: const Color.fromARGB(
                                              255, 133, 77, 14),
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(100.0),
                                            onTap: () {
                                              _deleteWishlist(
                                                  request, wishlistElement.id);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 2),
                                              child: Text(
                                                "Hapus",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                            width:
                                                10), // Add some spacing between buttons if needed
                                      ],
                                    ),
                                    Material(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      elevation: 2.0,
                                      color: const Color.fromARGB(
                                          255, 133, 77, 14),
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(100.0),
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EditWishlistPage(
                                                wishlistElement.id,
                                                wishlistElement.note,
                                              ),
                                            ),
                                          );
                                          setState(() {});
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          child: Text(
                                            "Edit",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                                // Material(
                                //   borderRadius: BorderRadius.circular(100.0),
                                //   elevation: 2.0,
                                //   color: const Color.fromARGB(255, 133, 77, 14),
                                //   child: InkWell(
                                //     borderRadius: BorderRadius.circular(100.0),
                                //     onTap: () {
                                //       _deleteWishlist(
                                //           request, wishlistElement.id);
                                //     },
                                //     child: const Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           horizontal: 10, vertical: 2),
                                //       child: Text(
                                //         "Hapus",
                                //         style: TextStyle(color: Colors.white),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                // Material(
                                //   borderRadius: BorderRadius.circular(100.0),
                                //   elevation: 2.0,
                                //   color: const Color.fromARGB(255, 133, 77, 14),
                                //   child: InkWell(
                                //     borderRadius: BorderRadius.circular(100.0),
                                //     onTap: () async {
                                //       await Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //             builder: (context) =>
                                //                 EditWishlistPage(
                                //                     wishlistElement.id,
                                //                     wishlistElement.note)),
                                //       );
                                //       setState(() {});
                                //     },
                                //     child: const Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           horizontal: 10, vertical: 2),
                                //       child: Text(
                                //         "Edit",
                                //         style: TextStyle(color: Colors.white),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            )
                            // Add more widgets as needed
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          )
        ],
      )),
    );
  }
}
