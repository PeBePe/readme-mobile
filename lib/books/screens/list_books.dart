import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:readme_mobile/books/models/book_response.dart';
import 'package:readme_mobile/books/screens/book_detail.dart';
import 'package:readme_mobile/constants/constants.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;

class ListBooks extends StatefulWidget {
  const ListBooks({super.key});

  @override
  State<ListBooks> createState() => _ListBooksState();
}

class _ListBooksState extends State<ListBooks> {
  String selectedSearchCriteria = 'judul'; // Default search criteria
  String selectedCategory = 'Semua Kategori'; // Default search criteria
  String query = '';

  Future<BookResponse> fetchBooks() async {
    var url = Uri.parse('$baseUrl/books');
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 247, 244),
      appBar: AppBar(
        title: const Text(
          'Books',
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
          child: Column(
        children: [
          header(),
          const SizedBox(height: 20),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookDetail(book.title, book.id),
                                        ),
                                      );
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

  Widget header() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(
              'assets/images/list_books_header.jpg'), // Replace with your image asset path
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.5), // Adjust opacity as needed
            BlendMode.darken,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Temukan banyak buku menarik disini!",
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          query = value;
                        });
                      },
                      style: const TextStyle(
                          color: Colors.black), // Set text color
                      decoration: const InputDecoration(
                        filled: true, // Add this line
                        fillColor: Colors.white, // Set the background color
                        hintText: "Cari buku...",
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none, // Remove border
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100),
                              topLeft: Radius.circular(100)),
                        ),
                        contentPadding: EdgeInsets.symmetric(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0), // Adjust spacing as needed
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(100),
                          topRight: Radius.circular(100),
                        ),
                      ),
                      backgroundColor: const Color.fromARGB(255, 133, 77, 14),
                      padding: const EdgeInsets.symmetric(
                          vertical: 22.5, horizontal: 25),
                    ),
                    child: const Text(
                      'Cari',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white, // Set the background color
                    ),
                    child: DropdownButton<String>(
                      value: selectedSearchCriteria,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedSearchCriteria = newValue;
                          });
                        }
                      },
                      items: <String>['judul', 'penulis', 'penerbit']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: const BoxDecoration(
                      color: Colors.white, // Set the background color
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedCategory = newValue;
                          });
                        }
                      },
                      items: <String>['Semua Kategori', 'Kategori 1']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
