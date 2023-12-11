import 'package:flutter/material.dart';
import 'package:readme_mobile/readme/models/home-response.dart';
import 'package:readme_mobile/readme/widgets/book_home.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:readme_mobile/readme/widgets/post_home.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<HomeResponse> fetchHome() async {
    var url = Uri.parse('http://localhost:8000/api/home');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    var homeResponse = HomeResponse.fromJson(data);

    return homeResponse;
  }

  @override
  Widget build(context) {
    return FutureBuilder(
      future: fetchHome(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (!snapshot.hasData) {
            return const Column(
              children: [
                Text(
                  "Terjadi kesalahan saat mengambil data",
                  style: TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                ),
                SizedBox(height: 8),
              ],
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo-small.png',
                      width: 50,
                    ),
                    const SizedBox(width: 8),
                    const Text("ReadMe"),
                  ],
                ),
                backgroundColor: const Color.fromARGB(255, 250, 239, 223),
                centerTitle: true,
                scrolledUnderElevation: 0,
                // actions: [
                //   Padding(padding: EdgeInsets.only(right: 20), child: Text("1000"))
                // ],
              ),
              backgroundColor: const Color.fromARGB(255, 249, 247, 244),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "BUKU TERBARU",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text("Temukan banyak buku menarik disini"),
                          BookHome(snapshot.data.newestBooks),
                        ],
                      ),
                      const Divider(
                        height: 20,
                        thickness: 4,
                        endIndent: 0,
                        color: Color.fromARGB(255, 229, 231, 235),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CARI BUKU BERDASARKAN TAG',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            children: List.generate(
                              snapshot.data.categories.length,
                              (index) => Padding(
                                padding: const EdgeInsets.only(
                                    right: 8.0, bottom: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle button press
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: const Color.fromARGB(
                                        255, 231, 231, 231),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                  ),
                                  child: Text(
                                    snapshot.data.categories[index],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      const Divider(
                        height: 20,
                        thickness: 4,
                        endIndent: 0,
                        color: Color.fromARGB(255, 229, 231, 235),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "QUOTES TERATAS",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border:
                                  Border.all(color: Colors.grey, width: 0.2),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            padding: const EdgeInsets.all(40),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Text(
                                  "\"${snapshot.data.bestQuote.quote}\"",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromARGB(255, 159, 144, 106),
                                  ),
                                ),
                                Text(
                                  "-${snapshot.data.bestQuote.author}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Color.fromARGB(255, 159, 144, 106),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      const Divider(
                        height: 20,
                        thickness: 4,
                        endIndent: 0,
                        color: Color.fromARGB(255, 229, 231, 235),
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "POST",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          PostHome(snapshot.data.posts),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              drawer: const LeftDrawer(),
            );
          }
        }
      },
    );
  }
}
