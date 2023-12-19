import 'package:flutter/material.dart';
import 'package:readme_mobile/books/models/book_detail_response.dart';
import 'package:readme_mobile/books/models/review_response.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:readme_mobile/constants/constants.dart';

class ReviewEdit extends StatefulWidget {
  final Review review;
  final Book book;
  const ReviewEdit(this.review, this.book, {super.key});

  @override
  State<ReviewEdit> createState() => _ReviewEditState();
}

class _ReviewEditState extends State<ReviewEdit> {
  TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController(text: widget.review.content);
  }

  @override
  Widget build(ctx) {
    final request = ctx.watch<CookieRequest>();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 247, 244),
      appBar: AppBar(
        title: Text(
          widget.book.title,
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(20),
          child: Column(
            children: [
              const Text(
                "Edit Review",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Image.network(widget.book.imageUrl),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.book.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "By ${widget.book.author}",
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(DateFormat('d MMMM y')
                            .format(widget.book.publicationDate)),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: const Color.fromARGB(255, 229, 231, 235),
                    width: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(children: [
                  Row(
                    children: [
                      Image.asset('assets/images/profile.png'),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        children: [
                          Text(
                              "${widget.review.user.name} @${widget.review.user.username}"),
                          if (widget.review.user.biodata.isNotEmpty)
                            Text(widget.review.user.biodata)
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                            "$baseUrl/books/edit/${widget.review.id}",
                            {"content": review});

                        var status = response['status'];
                        if (!status) {
                          // Handle error message
                          String errorMessage = response['message'];
                          // Tampilkan pesan kesalahan
                          // ignore: use_build_context_synchronously
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
                        } else {
                          // ignore: use_build_context_synchronously
                          Navigator.of(ctx).pop();
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white),
                      child: const Text("Simpan"),
                    ),
                  )
                ]),
              )
            ],
          )),
    );
  }
}
