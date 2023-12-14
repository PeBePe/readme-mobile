import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readme_mobile/books/models/book_response.dart';
import 'package:readme_mobile/books/widgets/list_books_header.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;

class ListBooks extends StatefulWidget {
  const ListBooks({super.key});

  @override
  State<ListBooks> createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooks> {
  Future<BookResponse> fetchBooks() async {
    var url = Uri.parse('https://readme.up.railway.app/api/books');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    var bookResponse = BookResponse.fromJson(data);

    return bookResponse;
  }

  @override
  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 247, 244),
      appBar: AppBar(
        title: const Text(
          'Books',
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ListBooksHeader(),
          FutureBuilder(
            future: fetchBooks(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return const Text("Terjadi kesalahan");
              } else {
                return ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: snapshot.data.books.length,
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemBuilder: (_, index) {
                    Book book = snapshot.data.books[index];
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
                            ),
                            const SizedBox(height: 10),
                            Text(
                              book.title,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "by ${book.author}",
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2), // Adjust padding as needed
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 231, 231, 231),
                                borderRadius: BorderRadius.circular(
                                    50.0), // Set the radius for rounded corners
                              ),
                              child: Text(
                                book.category,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              book.description,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${book.reviewCount} Review",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 133, 77, 14),
                              ),
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
                                  child: IconButton(
                                    icon: const Icon(
                                        Icons.bookmark_add_outlined,
                                        color:
                                            Color.fromARGB(255, 133, 77, 14)),
                                    onPressed: () {
                                      // Add your bookmark button logic here
                                    },
                                  ),
                                ),
                                Material(
                                  borderRadius: BorderRadius.circular(100.0),
                                  elevation: 2.0,
                                  color: const Color.fromARGB(255, 133, 77, 14),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(100.0),
                                    onTap: () {
                                      // Add your detail button logic here
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 2),
                                      child: Text(
                                        "Lihat Detail",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
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
