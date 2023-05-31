import 'package:flutter/material.dart';
import 'package:sidh_chat_app/models/models.dart';
import 'package:sidh_chat_app/pages/chat_bubble.dart';
import 'package:sidh_chat_app/utils/secure_storage.dart';
import 'package:sidh_chat_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:sidh_chat_app/pages/login_page.dart';

class ConversationPage extends StatefulWidget {
  final String friendUsername;

  ConversationPage({required this.friendUsername});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final SecureStorage _secureStorage = SecureStorage();
  List<Message> chatMessages = [];
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _retrieveConversation();
    _connectWebsocket();
  }

  void _retrieveConversation() async {
    var token = await _secureStorage.getAccessToken();

    final response = await http.get(
      Uri.parse(
          apiHost + "messages/?receiver_username=${widget.friendUsername}"),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List;
      final messages = jsonList
          .map((json) => Message(
                id: json['id'],
                senderUsername: json['sender_user']['username'],
                receiverUsername: json['receiver_user']['username'],
                content: json['content'],
              ))
          .toList();
      setState(() {
        chatMessages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    } else {
      setState(() {
        _isLoading = false;
      });
      context.showErrorSnackBar(
          message: 'Failed to load chat. Error: ${response.body}');
    }
  }

  void _connectWebsocket() async {
    var token = await _secureStorage.getAccessToken();
    home_channel = IOWebSocketChannel.connect(socketUri + "/$token");

    home_channel.stream.listen(
      (data) {
        // Handle incoming WebSocket data
        final receivedData = data;

        // Process and display the received data in the chat UI
        if (receivedData == "TOKEN ERROR") {
          if (mounted) {
            Navigator.of(context)
                .pushAndRemoveUntil(LoginPage.route(), (route) => false);
            home_channel.sink.close();
          } else {
            return;
          }
        } else {
          // Create a new Message object from the received data
          final jsonData = json.decode(receivedData);

          final newMessage = Message(
            id: jsonData["id"],
            senderUsername: jsonData["sender_user"]["username"],
            receiverUsername: jsonData["receiver_user"]["username"],
            content: jsonData["content"],
          );

          // Update the state to append the new message
          setState(() {
            chatMessages.add(newMessage);
            _scrollToBottom();
          });
        }
      },
      onError: (error) {
        // Handle WebSocket errors
        print('WebSocket Error: $error');
        // Attempt to reconnect after a delay
        Future.delayed(Duration(seconds: 5), _connectWebsocket);
      },
      onDone: () {
        // Handle WebSocket disconnection
        print('WebSocket Disconnected');
        return;
      },
    );
  }

  void _sendMessage() async {
    String message = _messageController.text;

    if (message.isNotEmpty) {
      var token = await _secureStorage.getAccessToken();
      final requestBody = {
        "receiver_username": widget.friendUsername,
        "message": message
      };

      home_channel.sink.add(json.encode(requestBody));
      _messageController.clear();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    home_channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.account_circle),
            const SizedBox(width: 10),
            Text(widget.friendUsername),
          ],
        ),
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child:
                        CircularProgressIndicator()) // Show a loading indicator
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: chatMessages.length,
                    itemBuilder: (context, index) {
                      Message message = chatMessages[index];
                      return ChatBubble(
                          message: message,
                          receiverUsername: widget.friendUsername);
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    controller: _messageController,
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: Icon(Icons.send),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
