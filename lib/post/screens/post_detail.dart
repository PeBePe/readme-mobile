// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readme_mobile/constants/constants.dart';
import 'package:readme_mobile/post/models/post.dart';
import 'package:intl/intl.dart';

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

  Future<void> deletePost(int postId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/post/delete/$postId'),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Navigator.of(context).pop(true); // Pop the current screen and indicate that the deletion was successful
    } else {
      final errorData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${errorData['message']}'),
        ),
      );
    }
  }

  Future<bool> confirmDelete() async {
    return (await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false), // pop false when cancel is pressed
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true), // pop true when delete is pressed
            ),
          ],
        );
      },
    )) ?? false; // If showDialog returns null, treat it as 'false'
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
                            ElevatedButton(
                              onPressed: () async {
                                if (await confirmDelete()) {
                                  await deletePost(widget.postId);
                                }
                              },
                              child: Text('Delete Post'),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // Change button color to indicate a destructive action
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