// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/constants/constants.dart';
import 'package:readme_mobile/post/models/post.dart';
import 'package:intl/intl.dart';
import 'package:readme_mobile/post/screens/edit_post.dart';
import 'package:readme_mobile/readme/screens/menu.dart';

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

  Future<bool> deletePost(int postId, CookieRequest request) async {
    var url = Uri.parse('$baseUrl/post/delete/$postId');
    try {
      final response = await http.delete(url, headers: request.headers);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['status'] == true) {
        return true;
      } else {
        print('Failed to delete post: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception caught while deleting post: $e');
      return false;
    }
  }

  Future<int> toggleLike(int postId, CookieRequest request) async {
    String url = "$baseUrl/post/post/like/$postId/";
    try {
      final response = await http.put(Uri.parse(url), headers: request.headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['likes_count'];
      } else {
        print("Error: ${response.body}");
        return -1;
      }
    } catch (e) {
      print("Exception caught: $e");
      return -1;
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
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyHomePage()),
            );
          },
        ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/profile.png'),
                                ),
                                Text(
                                  post.user.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '@${post.user.username}',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                IconButton(
                                  icon: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(Icons.edit, size: 20, color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPostPage(postId: widget.postId),
                                      ),
                                    );
                                  },
                                  tooltip: 'Edit Post',
                                ),
                                IconButton(
                                  icon: CircleAvatar(
                                    backgroundColor: Colors.grey.shade200,
                                    child: Icon(Icons.delete, size: 20, color: Colors.red),
                                  ),
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
                                        );
                                      },
                                    ) ?? false;
                                    if (confirmDelete) {
                                      bool deletionSuccess = await deletePost(widget.postId, context.read<CookieRequest>());
                                      if (deletionSuccess) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(builder: (context) => MyHomePage()),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  post.book.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              post.content,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            Divider(),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    int updatedLikes = await toggleLike(widget.postId, context.read<CookieRequest>());
                                    if (updatedLikes != -1) {
                                      setState(() {
                                        postItem = fetchPostById(widget.postId);
                                      });
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.thumb_up, color: Theme.of(context).colorScheme.secondary),
                                      const SizedBox(width: 8),
                                      FutureBuilder<PostItem>(
                                        future: postItem,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text('${snapshot.data!.post.likesCount} Likes');
                                          } else {
                                            return Text('Loading...');
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
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