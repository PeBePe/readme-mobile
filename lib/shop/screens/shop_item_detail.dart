import 'package:flutter/material.dart';
import 'package:readme_mobile/shop/models/shop_item.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:readme_mobile/shop/screens/shopping_cart.dart';
import 'package:readme_mobile/constants/constants.dart';

class ShopItemDetailPage extends StatefulWidget {
  final ShopItemElement shopItem;
  final bool openedFromCart;

  const ShopItemDetailPage(
      {required this.shopItem, required this.openedFromCart, Key? key})
      : super(key: key);

  @override
  State<ShopItemDetailPage> createState() => _ShopItemDetailPageState();
}

class _ShopItemDetailPageState extends State<ShopItemDetailPage> {
  bool _showFullDescription = false;
  int _amountToAdd = 1;
  ValueNotifier<int> loyaltyPoints = ValueNotifier<int>(0);
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController(text: '1');

  Future<ShopItemElement> fetchItem(request) async {
    var data = await request.get("$baseUrl/shop/${widget.shopItem.id}");

    return ShopItemElement.fromJson(data["shop_item"]);
  }

  Future<int> fetchProfile(request) async {
    var data = await request.get('$baseUrl/profile');
    if (data['status']) {
      loyaltyPoints.value = data['user']['loyalty_point'];
      return loyaltyPoints.value;
    } else {
      throw Exception('Failed to load profile');
    }
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FutureBuilder(
              future: fetchProfile(request),
              builder: (context, AsyncSnapshot snapshot) {
                return Row(
                  children: <Widget>[
                    const Icon(
                      Icons.stars,
                      color: Color(0xfffbbd61),
                      size: 28,
                    ),
                    const SizedBox(width: 2),
                    ValueListenableBuilder<int>(
                      valueListenable: loyaltyPoints,
                      builder: (context, value, child) {
                        return Text(
                          '$value',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '${snapshot.data.amount} Available',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.stars,
                                  color: Color(0xfffbbd61),
                                  size: 28,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  snapshot.data.price.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Form(
                          key: _formKey,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Amount',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _amountToAdd = int.parse(value);
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: TextButton(
                                  onPressed: widget.shopItem.amount > 0
                                      ? () async {
                                          final intValue = int.tryParse(
                                              _amountController.text);
                                          if (intValue == null ||
                                              intValue < 1) {
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Please enter a valid amount'),
                                              ));
                                          } else {
                                            final response = await request.post(
                                              "$baseUrl/shop/add-to-cart/${widget.shopItem.id}",
                                              {
                                                "amount":
                                                    _amountToAdd.toString()
                                              },
                                            );
                                            String message =
                                                response['message'];

                                            if (!context.mounted) return;
                                            ScaffoldMessenger.of(context)
                                              ..hideCurrentSnackBar()
                                              ..showSnackBar(SnackBar(
                                                content: Text(message),
                                              ));
                                            if (response['status']) {
                                              if (widget.openedFromCart) {
                                                Navigator.pop(context);
                                              }
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ShoppingCartPage(
                                                            loyaltyPoints)),
                                              );
                                            }
                                          }
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
                                  child: const Icon(
                                    Icons.add_shopping_cart,
                                    color: Colors.white,
                                    size: 26.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                    ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("ISBN",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7))),
                            ),
                            Expanded(
                              child: Text(snapshot.data.book.isbn),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Penulis",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7))),
                            ),
                            Expanded(
                              child: Text(snapshot.data.book.author),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Penerbit",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7))),
                            ),
                            Expanded(
                              child: Text(snapshot.data.book.publisher),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Tanggal Terbit",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7))),
                            ),
                            Expanded(
                              child: Text(
                                "${snapshot.data.book.publicationDate.year}-${snapshot.data.book.publicationDate.month}-${snapshot.data.book.publicationDate.day}",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Jumlah Halaman",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7))),
                            ),
                            Expanded(
                              child:
                                  Text(snapshot.data.book.pageCount.toString()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text("Bahasa",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.7))),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data.book.lang.toString() == 'Lang.EN'
                                    ? 'Inggris'
                                    : snapshot.data.book.lang.toString() ==
                                            'Lang.ID'
                                        ? 'Indonesia'
                                        : 'Bahasa Lain',
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
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
