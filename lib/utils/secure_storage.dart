import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  // Create storage
  final storage = const FlutterSecureStorage();

  final String _keyAccessToken = 'access_token';


  Future saveAccessToken(String token) async {
    await storage.write(key: _keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: _keyAccessToken);
  }

}