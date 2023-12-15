// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/constants/constants.dart';
import 'package:readme_mobile/post/models/post.dart';
import 'package:readme_mobile/post/screens/post_detail.dart';

class EditPostPage extends StatefulWidget {
  final int postId;

  EditPostPage({Key? key, required this.postId}) : super(key: key);

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late Future<PostItem> postItem;
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postItem = fetchPostById(widget.postId);
  }

  Future<PostItem> fetchPostById(int postId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/post/$postId'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return postItemFromJson(response.body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    CookieRequest request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<PostItem>(
        future: postItem,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              _contentController.text = snapshot.data!.post.content;
              return _buildForm(snapshot.data!, request);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildForm(PostItem postData, CookieRequest request) {
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
              child: Image.network(postData.post.book.imageUrl, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            postData.post.book.title,
            style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          TextField(
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
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            ),
          ),
          const SizedBox(height: 24.0),
          FloatingActionButton.extended(
            onPressed: () async {
              if (_contentController.text.isNotEmpty) {
                final response = await request.post(
                  '$baseUrl/post/edit/${widget.postId}',
                  {'content': _contentController.text},
                );
                if (response['status'] == true) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Post updated successfully')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetail(postId: widget.postId),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update post')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Content cannot be empty')),
                );
              }
            },
            icon: Icon(Icons.edit),
            label: Text('Edit Post'),
          ),
        ],
      ),
    );
  }
}
