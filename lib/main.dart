import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:readme_mobile/readme/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String? loggedInUsername = prefs.getString('loggedInUsername');

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    loggedInUsername: loggedInUsername,
  ));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? loggedInUsername;

  const MyApp(
      {Key? key, required this.isLoggedIn, required this.loggedInUsername})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) {
        CookieRequest request = CookieRequest();
        return request;
      },
      child: MaterialApp(
          title: 'PBP A03',
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
              fontFamily: 'Lato'),
          home: const LoginPage()),
    );
  }
}
