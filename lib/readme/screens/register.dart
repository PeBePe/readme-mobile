import 'package:readme_mobile/readme/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:readme_mobile/constants/constants.dart';

void main() {
  runApp(const RegisterApp());
}

class RegisterApp extends StatelessWidget {
  const RegisterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthdateController = TextEditingController();
  final FocusNode _passwordConfirmationFocusNode = FocusNode();
  DateTime? _birthdate;

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
          style: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1915),
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  focusNode: _passwordConfirmationFocusNode,
                  controller: _passwordConfirmationController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  controller: _birthdateController,
                  decoration: const InputDecoration(
                    labelText: 'Birthdate',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(
                        new FocusNode()); // to prevent opening of the onscreen keyboard
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _birthdate = pickedDate;
                        _birthdateController.text = _birthdateController.text =
                            "${_birthdate!.year}-${_birthdate!.month.toString().padLeft(2, '0')}-${_birthdate!.day.toString().padLeft(2, '0')}"; // format it as you want
                      });
                    }
                  },
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: () async {
                    // Validate all the fields
                    if (!_formKey.currentState!.validate()) {
                      // If any field is not valid, return early
                      return;
                    }
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    String passwordConfirmation =
                        _passwordConfirmationController.text;
                    String name = _nameController.text;
                    String email = _emailController.text;
                    String birthdate = _birthdateController.text;

                    if (password != passwordConfirmation) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Error'),
                          content: const Text('The passwords do not match.'),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                                _passwordConfirmationController.clear();
                                FocusScope.of(context).requestFocus(
                                    _passwordConfirmationFocusNode);
                              },
                            ),
                          ],
                        ),
                      );
                      return;
                    }
                    final response = await request.post(
                      "$baseUrl/auth/register",
                      {
                        'name': name,
                        'username': username,
                        'email': email,
                        'password1': password,
                        'password2': passwordConfirmation,
                        'birthdate': birthdate,
                      },
                    );

                    if (response['status']) {
                      String message = response['message'];

                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                      );
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(content: Text(message)));
                    } else {
                      // ignore: use_build_context_synchronously
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Register Failed'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children:
                                response['errors'].entries.map<Widget>((entry) {
                              return Text(
                                  '${entry.key}: ${entry.value.join(', ')}');
                            }).toList(),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                      // Clear the fields that are in response['errors']
                      if (response['errors'].containsKey('username')) {
                        _usernameController.clear();
                      }
                      if (response['errors'].containsKey('password')) {
                        _passwordController.clear();
                      }
                      if (response['errors']
                          .containsKey('passwordConfirmation')) {
                        _passwordConfirmationController.clear();
                      }
                      if (response['errors'].containsKey('name')) {
                        _nameController.clear();
                      }
                      if (response['errors'].containsKey('email')) {
                        _emailController.clear();
                      }
                      if (response['errors'].containsKey('birthdate')) {
                        _birthdateController.clear();
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1915),
                    foregroundColor: const Color(0xFFFAEFDF),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Register'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Color(0xFF1E1915)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
