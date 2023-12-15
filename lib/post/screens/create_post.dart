// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/books/models/books_model.dart';
import 'package:readme_mobile/post/screens/post_detail.dart';

class CreatePostPage extends StatefulWidget {
  final int bookId; // ID of the book you want to display

  CreatePostPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _CreatePostPage createState() => _CreatePostPage();
}

class _CreatePostPage extends State<CreatePostPage> {
  late Future<Books> bookItem;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bookItem = fetchBookData(widget.bookId);
  }

  Future<Books> fetchBookData(int bookId) async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/books'));

    if (response.statusCode == 200) {
      return booksFromJson(response.body); // This returns a Books object
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    CookieRequest request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<Books>(
        // Expecting a Books object now
        future: fetchBookData(widget.bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Extract the single book that matches the bookId
              final bookData = snapshot.data!.books.firstWhere(
                (book) => book.id == widget.bookId,
                orElse: () => throw Exception('Book not found'),
              );
              return _buildForm(
                  bookData, request); // Pass the single book to the _buildForm
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildForm(Book bookData, CookieRequest request) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(bookData.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            bookData.title,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          Material(
            elevation: 4.0,
            shadowColor: Colors.grey[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Content',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          FloatingActionButton.extended(
            onPressed: () async {
              final response2 = await request.post(
                'https://readme.up.railway.app/api/post/create/1',
                {
                  'content': "tes create flutter",
                },
              );
              print(response2);
              // if (_contentController.text.isNotEmpty) {

              //   if (response['status'] == true) {
              //     final int postId = response['post']['id'];
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text('Post created successfully')),
              //     );
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => PostDetail(postId: postId)),
              //     );
              //   } else {
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       SnackBar(content: Text(response['message'])),
              //     );
              //   }
              // } else {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('Content cannot be empty')),
              //   );
              // }
            },
            icon: Icon(Icons.add),
            label: Text('Create Post'),
          ),
        ],
      ),
    );
  }
}
