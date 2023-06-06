import 'package:flutter/material.dart';
import 'package:sidh_chat_app/pages/conversation_page.dart';
import 'package:sidh_chat_app/pages/user_detail_page.dart';
import 'package:sidh_chat_app/utils/secure_storage.dart';
import 'package:sidh_chat_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatPage(),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final SecureStorage _secureStorage = SecureStorage();
  final TextEditingController _usernameController = TextEditingController();
  List<String> friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    var token = await _secureStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(apiHost + "friends/"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      var friendsList = json.decode(response.body) as List<dynamic>;

      setState(() {
        friends =
            friendsList.map((friend) => friend['username'] as String).toList();
      });
    } else {
      context.showErrorSnackBar(
          message: 'Failed to load friends. Error: ${response.statusCode}');
    }
  }

  Future<void> _showAddFriendDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Friend'),
          content: TextField(
            controller: _usernameController,
            decoration: const InputDecoration(hintText: 'Enter username'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () async {
                String username = _usernameController.text;
                // Perform add friend logic with the entered username
                await _addFriend(username);
                _usernameController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addFriend(String username) async {
    var token = await _secureStorage.getAccessToken();

    final response = await http.post(
      Uri.parse(apiHost + "friends/?friend_username=$username"),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      await _loadFriends();
    } else {
      var error = json.decode(response.body);
      context.showErrorSnackBar(
          message: 'Failed to add friend. Error: ' + error["detail"]);
    }
  }

  void _navigateToChatPage(String friendUsername) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConversationPage(friendUsername: friendUsername),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: const Text("Chat"),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person),
                    onPressed: (){
                      Navigator.push(context, UserDetailsPage.route());
                    }),
                ],    
              ),
      backgroundColor: Colors.grey[300],
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          String friendUsername = friends[index];

          return Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
              leading: Container(
              height: 60,
              child: const Icon(Icons.account_circle, size: 50),
            ),
              title: Text(friendUsername, style: TextStyle(fontSize: 18.0),),
              onTap: () {
                _navigateToChatPage(friendUsername);
              },
            )
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFriendDialog();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
