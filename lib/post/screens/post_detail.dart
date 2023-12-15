// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/constants/constants.dart';
import 'package:readme_mobile/post/models/post.dart';
import 'package:intl/intl.dart';
import 'package:readme_mobile/post/screens/edit_post.dart';

class PostDetail extends StatefulWidget {
  final int postId;

  const PostDetail({Key? key, required this.postId}) : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  late Future<PostItem> postItem;

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

  Future<void> deletePost(int postId, CookieRequest request) async {
    var url = Uri.parse('$baseUrl/post/delete/$postId');

    try {
      final response = await http.delete(url, headers: request.headers);
      var responseData = jsonDecode(response.body);

      if (responseData['status'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post deleted successfully')),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete post')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        elevation: 1,
      ),
      body: FutureBuilder<PostItem>(
        future: postItem,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Post not found'));
          } else if (!snapshot.data!.status) {
            return Center(child: Text(snapshot.data!.message));
          } else {
            final post = snapshot.data!.post;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/profile.png'), // Replace with actual image network URL if available
                              ),
                              title: Text(
                                post.user.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text('@${post.user.name}'),
                            ),
                            SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                post.book.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              post.content,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () {
                                // Navigate to the EditPostPage
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditPostPage(
                                      //bookId: post.book.id,
                                      postId: widget.postId,
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit),
                              label: Text('Edit Post'),
                              style: ElevatedButton.styleFrom(
                                primary: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final confirmDelete = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: const Text('Are you sure you want to delete this post?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () => Navigator.of(context).pop(false),
                                        ),
                                        TextButton(
                                          child: const Text('Delete'),
                                          onPressed: () => Navigator.of(context).pop(true),
                                        ),
                                      ],
                                    );}
                                ) ?? false; 

                                if (confirmDelete) {
                                  await deletePost(widget.postId, context.read<CookieRequest>());
                                }
                              },
                              icon: Icon(Icons.delete),
                              label: Text('Delete Post'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.redAccent,
                              ),
                            ),

                            SizedBox(height: 16),
                            Divider(),
                            Row(
                              children: [
                                Icon(Icons.thumb_up, color: Theme.of(context).colorScheme.secondary),
                                const SizedBox(width: 8),
                                Text('${post.likesCount} Likes'),
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Posted at: ${formatDateTime(post.createdAt)}',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('h:mm a · d MMM yyyy');
  return formatter.format(dateTime);
}