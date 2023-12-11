import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/models/shop_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';

class ShopItemDetailPage extends StatefulWidget {
  final ShopItemElement shopItem;

  const ShopItemDetailPage({required this.shopItem, Key? key})
      : super(key: key);

  @override
  State<ShopItemDetailPage> createState() => _ShopItemDetailPageState();
}

class _ShopItemDetailPageState extends State<ShopItemDetailPage> {
  bool _showFullDescription = false;
  int _amountToAdd = 1;

  Future<ShopItemElement> fetchItem(request) async {
    var data = await request
        .get("http://10.0.2.2:8000/api/shop/${widget.shopItem.id}");

    return ShopItemElement.fromJson(data["shop_item"]);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text(
          'Book Detail',
        ),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: fetchItem(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 220,
                      width: 150,
                      child: Image.network(snapshot.data.book.imageUrl,
                          fit: BoxFit.fill),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _amountToAdd = int.parse(value);
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TextButton(
                          onPressed: widget.shopItem.amount > 0
                              ? () async {
                                  final response = await request.post(
                                    "http://10.0.2.2:8000/api/shop/add-to-cart/${widget.shopItem.id}",
                                    {"amount": _amountToAdd.toString()},
                                  );
                                  String message = response['message'];
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(SnackBar(
                                      content: Text(message),
                                    ));
                                }
                              : null, // disable the button when the shop item amount is 0
                          style: TextButton.styleFrom(
                            backgroundColor: widget.shopItem.amount > 0
                                ? const Color(0xfffbbd61)
                                : Colors.grey
                                    .shade600, // change the background color when the button is disabled
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            widget.shopItem.amount > 0
                                ? 'Add to Cart'
                                : 'Out of Stock', // change the text when the button is disabled
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${snapshot.data.book.title}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        snapshot.data.book.category,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                        color: Colors.grey), // This is the horizontal line
                    RichText(
                      text: TextSpan(
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(
                            text: _showFullDescription ||
                                    snapshot.data.book.description
                                            .split(" ")
                                            .length <=
                                        40
                                ? snapshot.data.book.description
                                : snapshot.data.book.description
                                        .split(" ")
                                        .take(40)
                                        .join(" ") +
                                    "... ",
                          ),
                          if (snapshot.data.book.description.split(" ").length >
                              40)
                            TextSpan(
                              text: _showFullDescription
                                  ? " Show less"
                                  : " Show more",
                              style: const TextStyle(color: Color(0xFF5A4100)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  setState(() {
                                    _showFullDescription =
                                        !_showFullDescription;
                                  });
                                },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.grey),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 6,
                      children: [
                        Text("ISBN",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7))),
                        Text(snapshot.data.book.isbn),
                        Text("Penulis",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7))),
                        Text(snapshot.data.book.author),
                        Text("Penerbit",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7))),
                        Text(snapshot.data.book.publisher),
                        Text("Tanggal Terbit",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7))),
                        Text(
                          "${snapshot.data.book.publicationDate.year}-${snapshot.data.book.publicationDate.month}-${snapshot.data.book.publicationDate.day}",
                        ),
                        Text("Jumlah Halaman",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7))),
                        Text(snapshot.data.book.pageCount.toString()),
                        Text("Bahasa",
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.7))),
                        Text(
                          snapshot.data.book.lang.toString() == 'Lang.EN'
                              ? 'Inggris'
                              : snapshot.data.book.lang.toString() == 'Lang.ID'
                                  ? 'Indonesia'
                                  : 'Bahasa Lain',
                        ),
                      ],
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
