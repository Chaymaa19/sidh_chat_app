import 'package:flutter/material.dart';
import 'package:sidh_chat_app/pages/chat_page.dart';
import 'package:sidh_chat_app/utils/constants.dart';
import 'package:sidh_chat_app/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const LoginPage());
  }

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final SecureStorage _secureStorage = SecureStorage();
  final _formKey = GlobalKey<FormState>();

  Future<void> _logIn() async {
    final validForm = _formKey.currentState!.validate();
    if (!validForm) {
      return;
    }
    final email = _emailController.text;
    final password = _passwordController.text;

    final requestBody = {
      "grant_type": "password",
      "username": email,
      "password": password,
    };

    // Sign up new user
    final response = await http.post(
      Uri.parse(apiHost + "auth/login"),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: utf8.encode(Uri(queryParameters: requestBody).query),
    );

    if (response.statusCode == 200) {
      // Login successful, handle the response
      final responseData = json.decode(response.body);
      final accessToken = responseData['access_token'];

      // Store the access token and token type
      _secureStorage.saveAccessToken(accessToken);

      // Redirect to the chats
      Navigator.of(context)
          .pushAndRemoveUntil(ChatPage.route(), (route) => false);
    } else {
      // Login failed, handle the error
      var error = json.decode(response.body);
      context.showErrorSnackBar(
          message: "Error trying to log in: " + error["detail"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
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
                'assets/login.svg',
                width: double.infinity,
                height: 250,
              ),
      
              formSpacer,
              TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                  }),
              formSpacer,
              TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                  }),
              formSpacer,
              ElevatedButton(
                onPressed: _logIn,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
                ),
                child: const Text('Login',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
