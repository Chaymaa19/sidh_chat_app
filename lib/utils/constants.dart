import 'package:flutter/material.dart';

import 'package:web_socket_channel/web_socket_channel.dart';

late WebSocketChannel home_channel;

// Padding in forms
const formPadding = EdgeInsets.symmetric(vertical: 20, horizontal: 16);
// Space between form elements
const formSpacer = SizedBox(width: 16, height: 16);
// Hostname of the API
const apiHost = "https://agile-being-388117.ew.r.appspot.com/";
// Socket uri
const socketUri = "wss://agile-being-388117.ew.r.appspot.com/ws";


/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }
}
