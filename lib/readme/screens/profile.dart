import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:readme_mobile/constants/constants.dart';
import 'package:readme_mobile/readme/models/profile_response.dart';
import 'package:readme_mobile/readme/widgets/left_drawer.dart';
import 'package:readme_mobile/wishlist/screens/wishlist.dart';
import 'package:readme_mobile/shop/screens/bookshelf.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<ProfileResponse> fetchProfile(CookieRequest request) async {
    var response = await request.get('$baseUrl/profile');
    var profileResponse = ProfileResponse.fromJson(response);
    return profileResponse;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFFFAEFDF),
        foregroundColor: const Color(0xFF1E1915),
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
              alignment: Alignment.topCenter,
              child: FutureBuilder<ProfileResponse>(
                future: fetchProfile(request),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    var profileData = snapshot.data!.user;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Image.asset(
                            'assets/images/profile-big.png',
                            width: double.infinity,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 45,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const WishlistPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 99, 93),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Lihat Wishlist",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 250,
                          height: 45,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BookshelfPage()),
                              );
                            },
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 0, 63, 99),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text(
                              "Lihat Buku yang Dibeli",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  profileData.name,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "@${profileData.username}",
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              endIndent: 0,
                              color: Color.fromARGB(255, 229, 231, 235),
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 350),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Lahir",
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "Bergabung",
                                        style: TextStyle(fontSize: 16),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        DateFormat('dd MMMM yyyy')
                                            .format(profileData.birthdate),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        DateFormat('dd MMMM yyyy')
                                            .format(profileData.createdAt),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Quotes yang dibuat",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              endIndent: 0,
                              color: Color.fromARGB(255, 229, 231, 235),
                            ),
                            profileData.quote != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey, width: 0.2),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20)),
                                    ),
                                    padding: const EdgeInsets.all(40),
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Text(
                                          "\"${profileData.quote}\"",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontStyle: FontStyle.italic,
                                            color: Color.fromARGB(
                                                255, 159, 144, 106),
                                          ),
                                        ),
                                        Text(
                                          "-${profileData.name}",
                                          style: const TextStyle(
                                            fontStyle: FontStyle.italic,
                                            color: Color.fromARGB(
                                                255, 159, 144, 106),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const Text("User belum membuat quote"),
                            const SizedBox(height: 20),
                            const Text(
                              "Quotes yang dikutip",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              endIndent: 0,
                              color: Color.fromARGB(255, 229, 231, 235),
                            ),
                            profileData.citedQuotes.isNotEmpty
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: profileData.citedQuotes.length,
                                    itemBuilder: (context, index) {
                                      var quote =
                                          profileData.citedQuotes[index];
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey, width: 0.2),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        padding: const EdgeInsets.all(40),
                                        width: double.infinity,
                                        child: Column(
                                          children: [
                                            Text(
                                              "\"${quote.quote}\"",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontStyle: FontStyle.italic,
                                                color: Color.fromARGB(
                                                    255, 159, 144, 106),
                                              ),
                                            ),
                                            Text(
                                              "-${quote.user.name}",
                                              style: const TextStyle(
                                                fontStyle: FontStyle.italic,
                                                color: Color.fromARGB(
                                                    255, 159, 144, 106),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : const Text(
                                    "User belum mengutip quote siapapun"),
                            const SizedBox(height: 20),
                            const Text(
                              "Review terbaru",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            const Divider(
                              height: 20,
                              thickness: 4,
                              endIndent: 0,
                              color: Color.fromARGB(255, 229, 231, 235),
                            ),
                            profileData.reviews.isNotEmpty
                                ? ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: profileData.reviews.length,
                                    itemBuilder: (context, index) {
                                      var review = profileData.reviews[index];
                                      return Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color.fromARGB(
                                                    255, 229, 231, 235),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                              color: Colors.white,
                                            ),
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Image.network(
                                                        review.book.imageUrl,
                                                        width: 80),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            review.book.title,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                            ),
                                                          ),
                                                          Text(
                                                            "By ${review.book.author}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                                    'dd MMMM yyyy')
                                                                .format(review
                                                                    .book
                                                                    .publicationDate),
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        16),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  review.content,
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                                const SizedBox(height: 10),
                                                Text(
                                                  "Terakhir diupdate ${DateFormat('dd MMMM yyyy HH:mm').format(review.updatedAt)}",
                                                )
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                        ],
                                      );
                                    },
                                  )
                                : const Text(
                                    "User belum memberikan review apapun")
                          ],
                        )
                      ],
                    );
                  }
                },
              )),
        ),
      ),
    );
  }
}
