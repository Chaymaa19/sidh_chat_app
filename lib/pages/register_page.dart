import 'package:flutter/material.dart';
import 'package:sidh_chat_app/pages/login_page.dart';
import 'package:sidh_chat_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.isRegistering}) : super(key: key);

  static Route<void> route({bool isRegistering = false}) {
    return MaterialPageRoute(
      builder: (context) => RegisterPage(isRegistering: isRegistering),
    );
  }

  final bool isRegistering;

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _signUp() async {
    final validForm = _formKey.currentState!.validate();
    if (!validForm) {
      return;
    }
    final email = _emailController.text;
    final password = _passwordController.text;
    final username = _usernameController.text;

    final requestBody = {
      "username": username,
      "email": email,
      "password": password
    };

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    // Sign up new user
    final response = await http.post(
      Uri.parse(apiHost + "auth/signup"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestBody),
    );
    // Redirect to login
    if (response.statusCode == 200) {
      Navigator.of(context).push(LoginPage.route());
    } else {
      var error = json.decode(response.body);
      context.showErrorSnackBar(
          message: "Error trying to sign up: " + error["detail"]);
    }

    setState(() {
        _isLoading = false;
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register'), centerTitle: true),
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 160, 127, 190), Colors.grey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: formPadding,
            children: [
              SvgPicture.asset(
                'assets/signup.svg',
                width: double.infinity,
                height: 250,
              ),
              formSpacer,
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              formSpacer,
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  } else if (value.length < 6) {
                    return '6 characters minimum';
                  }
                },
                keyboardType: TextInputType.visiblePassword,
              ),
              formSpacer,
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required';
                  }
                  final isValid =
                      RegExp(r'^[A-Za-z0-9_]{3,24}$').hasMatch(value);
                  if (!isValid) {
                    return '''Password needs to have length between 3-24 and 
                    be formed by letters, numbers and underscores.''';
                  }
                  return null;
                },
              ),
              formSpacer,
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator
                    : const Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
              ),
              formSpacer,
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(LoginPage.route());
                },
                child: const Text(
                  'I already have an account',
                  style: TextStyle(fontSize: 16.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
