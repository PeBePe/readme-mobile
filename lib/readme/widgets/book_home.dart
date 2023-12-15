import 'package:flutter/material.dart';
import 'package:readme_mobile/readme/models/home-response.dart';

class BookHome extends StatelessWidget {
  final List<NewestBook> books;
  const BookHome(this.books, {super.key});

  @override
  Widget build(ctx) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemExtent: MediaQuery.of(ctx).size.width * 0.32,
        itemBuilder: (_, index) => GestureDetector(
            onTap: () {},
            child: Container(
              width: MediaQuery.of(ctx).size.width * 0.32,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(books[index].imageUrl),
                  fit: BoxFit.cover,
                  repeat: ImageRepeat.noRepeat,
                ),
              ),
            )),
      ),
    );
  }
}
