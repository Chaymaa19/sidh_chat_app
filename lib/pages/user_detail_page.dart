import 'package:flutter/material.dart';
import 'package:sidh_chat_app/pages/welcome_page.dart';
import 'package:sidh_chat_app/utils/constants.dart';
import 'package:sidh_chat_app/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => const UserDetailsPage());
  }

  @override
  State<StatefulWidget> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final SecureStorage _secureStorage = SecureStorage();
  Map<String, dynamic>? user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentUserDetails();
  }

  void _getCurrentUserDetails() async {
    var token = await _secureStorage.getAccessToken();
    final response = await http.get(
      Uri.parse(apiHost),
      headers: {'Authorization': 'Bearer $token'},
    );
      
    setState(() {
        user = json.decode(response.body);
        _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(title: const Text("Account Details")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(children: [
                const SizedBox(
                  height: 20,
                ),
                const Icon(
                  Icons.account_circle,
                  size: 150,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Username",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  user!["username"],
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  user!["email"],
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(15)),
                  ),
                  onPressed: () {
                    Navigator.push(context, WelcomePage.route());
                  },
                  child: const Text('Logout',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                ),
              ]),
            ),
    );
  }
}
