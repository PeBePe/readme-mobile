// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:readme_mobile/books/models/book_detail_response.dart';
import 'package:readme_mobile/books/models/review_response.dart';
import 'package:readme_mobile/books/screens/review_edit.dart';
import 'package:readme_mobile/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:readme_mobile/wishlist/screens/addWishlist.dart';
import 'package:readme_mobile/wishlist/screens/wishlist.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookDetail extends StatefulWidget {
  final String title;
  final int id;

  const BookDetail(this.title, this.id, {super.key});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  String? loggedInUsername; // Simpan username
  _BookDetailState();

  Future<ReviewResponse> fetchBookReview() async {
    var url = Uri.parse('$baseUrl/books/review/${widget.id}');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    var reviewResponse = ReviewResponse.fromJson(data);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loggedInUsername = prefs.getString("loggedInUsername");
    this.loggedInUsername = loggedInUsername; // Set username yang lagi login

    return reviewResponse;
  }

  Future<BookDetailResponse> fetchBookDetail() async {
    var url = Uri.parse('$baseUrl/books/${widget.id}');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    var bookDetailResponse = BookDetailResponse.fromJson(data);

    return bookDetailResponse;
  }

  @override
  Widget build(ctx) {
    final request = ctx.watch<CookieRequest>();
    TextEditingController reviewController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 247, 244),
      appBar: AppBar(
        title: Text(
          widget.title,
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: fetchBookDetail(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              Book book = snapshot.data.book;
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            child: Image.network(
                              book.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 350,
                            child: Material(
                              borderRadius: BorderRadius.circular(100.0),
                              elevation: 2.0,
                              color: const Color.fromARGB(255, 0, 99, 93),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100.0),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddWishlistPage(book.id)),
                                  );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Tambahkan ke Wishlist",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 350,
                            child: Material(
                              borderRadius: BorderRadius.circular(100.0),
                              elevation: 2.0,
                              color: const Color.fromARGB(255, 0, 63, 99),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100.0),
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Beli Buku Ini",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 350,
                            child: Material(
                              borderRadius: BorderRadius.circular(100.0),
                              elevation: 2.0,
                              color: const Color.fromARGB(255, 99, 30, 0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(100.0),
                                onTap: () {},
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    "Buat Postingan",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        const SizedBox(width: 10),
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
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(book.author, style: const TextStyle(fontSize: 18)),
                    const Divider(
                      height: 20,
                      thickness: 4,
                      endIndent: 0,
                      color: Color.fromARGB(255, 229, 231, 235),
                    ),
                    Text(book.description,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 30),
                    const Text(
                      "Detail",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 4,
                      endIndent: 0,
                      color: Color.fromARGB(255, 229, 231, 235),
                    ),
                    Row(
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(style: TextStyle(fontSize: 16), "ISBN"),
                            SizedBox(height: 5),
                            Text(style: TextStyle(fontSize: 16), "Penulis"),
                            SizedBox(height: 5),
                            Text(style: TextStyle(fontSize: 16), "Penerbit"),
                            SizedBox(height: 5),
                            Text(
                                style: TextStyle(fontSize: 16),
                                "Tanggal Terbit"),
                            SizedBox(height: 5),
                            Text(
                                style: TextStyle(fontSize: 16),
                                "Jumlah Halaman"),
                            SizedBox(height: 5),
                            Text(style: TextStyle(fontSize: 16), "Bahasa"),
                          ],
                        ),
                        const SizedBox(width: 60),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                style: const TextStyle(fontSize: 16),
                                book.isbn),
                            const SizedBox(height: 5),
                            Text(
                                style: const TextStyle(fontSize: 16),
                                book.author),
                            const SizedBox(height: 5),
                            Text(
                                style: const TextStyle(fontSize: 16),
                                book.publisher),
                            const SizedBox(height: 5),
                            Text(
                              DateFormat('dd MMMM yyyy')
                                  .format(book.publicationDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                                style: const TextStyle(fontSize: 16),
                                book.pageCount.toString()),
                            const SizedBox(height: 5),
                            Text(
                                style: const TextStyle(fontSize: 16),
                                book.lang == "en" ? "Inggris" : "Indonesia"),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      "Review",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 4,
                      endIndent: 0,
                      color: Color.fromARGB(255, 229, 231, 235),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(255, 229, 231, 235),
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/images/profile.png'),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "Berikan review",
                                    style: TextStyle(fontSize: 16),
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: reviewController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  hintText: 'Tulis review Anda di sini...',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: TextButton(
                                  onPressed: () async {
                                    String review = reviewController.text;
                                    final response = await request.post(
                                        "$baseUrl/books/add-review/${widget.id}",
                                        {"content": review});

                                    var status = response is Map ? false : true;
                                    if (!status) {
                                      // Handle error message
                                      String errorMessage = response['message'];
                                      // Tampilkan pesan kesalahan
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Error"),
                                            content: Text(errorMessage),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("OK"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    setState(() {});
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white),
                                  child: const Text("Kirim"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: fetchBookReview(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (!snapshot.hasData) {
                              return const Text("Terjadi kesalahan");
                            } else {
                              return Column(
                                children: [
                                  ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.reviews.length,
                                    itemBuilder: (context, index) {
                                      Review review =
                                          snapshot.data!.reviews[index];
                                      return Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 229, 231, 235),
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                    'assets/images/profile.png'),
                                                const SizedBox(width: 10),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${review.user.name} @${review.user.username}",
                                                      style: const TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                    if (review.user.biodata
                                                        .isNotEmpty)
                                                      Text(review.user.biodata),
                                                  ],
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Text(
                                              review.content,
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  review.createdAt,
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey),
                                                ),
                                                if (loggedInUsername ==
                                                    review.user.username)
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        iconSize: 30,
                                                        onPressed: () async {
                                                          await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ReviewEdit(
                                                                      review,
                                                                      book), // Gantilah EditPage dengan nama halaman edit Anda
                                                            ),
                                                          );
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                            Icons.edit,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    99,
                                                                    93)),
                                                      ),
                                                      IconButton(
                                                        iconSize: 30,
                                                        onPressed: () async {
                                                          var url = Uri.parse(
                                                              '$baseUrl/books/delete-review/${review.id}');
                                                          final response =
                                                              await http.delete(
                                                                  url,
                                                                  headers: request
                                                                      .headers);
                                                          var data = jsonDecode(
                                                              utf8.decode(response
                                                                  .bodyBytes));
                                                          bool status =
                                                              data['status'];
                                                          if (!status) {
                                                            String
                                                                errorMessage =
                                                                data['message'];
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: const Text(
                                                                      "Error"),
                                                                  content: Text(
                                                                      errorMessage),
                                                                  actions: <Widget>[
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: const Text(
                                                                          "OK"),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                          }
                                                          setState(() {});
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    248,
                                                                    113,
                                                                    113)),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                  )
                                ],
                              );
                            }
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
