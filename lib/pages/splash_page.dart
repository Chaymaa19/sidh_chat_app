import 'package:flutter/material.dart';
import 'package:sidh_chat_app/pages/chat_page.dart';
import 'package:sidh_chat_app/pages/login_page.dart';
import 'package:sidh_chat_app/pages/register_page.dart';
import 'package:http/http.dart' as http;
import 'package:sidh_chat_app/pages/welcome_page.dart';
import 'package:sidh_chat_app/utils/constants.dart';
import 'package:sidh_chat_app/utils/secure_storage.dart';
import 'dart:convert';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SecureStorage _secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    // await for the widget to mount
    await Future.delayed(Duration.zero);

    // Ask backend if user is logged in or not
    var token = await _secureStorage.getAccessToken();
    if (token == null) {
      Navigator.of(context)
          .pushAndRemoveUntil(WelcomePage.route(), (route) => false);
    } else {
      final response = await http.get(
        Uri.parse(apiHost),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        // If token is valid, redirect to chat
        Navigator.of(context)
            .pushAndRemoveUntil(ChatPage.route(), (route) => false);
      } else {
        // If token is invalid redirect to Login
        Navigator.of(context)
            .pushAndRemoveUntil(WelcomePage.route(), (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
