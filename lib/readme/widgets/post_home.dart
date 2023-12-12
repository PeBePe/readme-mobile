import 'package:flutter/material.dart';
import 'package:readme_mobile/readme/models/home-response.dart';
import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  final formatter = DateFormat('h:mm a · d MMM yyyy');
  return formatter.format(dateTime);
}

class PostHome extends StatelessWidget {
  final List<Post> posts;
  const PostHome(this.posts, {super.key});

  @override
  Widget build(ctx) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: posts.length,
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => const SizedBox(
        height: 15,
      ),
      itemBuilder: (_, index) => Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.2),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Row(
            children: [
              Image.asset(
                'assets/images/profile.png',
                width: 40,
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Row(
                    children: [
                      Text(posts[index].user.name),
                      SizedBox(
                        width: 5,
                      ),
                      Text("@${posts[index].user.username}"),
                    ],
                  ),
                  // Text(posts[index].user.biodata),
                ],
              )
            ],
          ),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posts[index].content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Tampilkan lebih banyak",
                    style: TextStyle(
                      color: Color.fromARGB(
                          255, 0, 99, 93), // Atur warna sesuai kebutuhan
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(formatDateTime(posts[index].createdAt)),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: Column(
              children: [
                Image.network(
                  posts[index].book.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5),
                Text(
                    "${posts[index].book.title} (${posts[index].book.publicationDate.year})",
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
