import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:mfuborrow/screens/shared_screeens/login.dart';

Future<String> getToken(context) async {
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');
  if (token == null) {
    debugPrint('No token in local storage');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
    );
  }
  // token found
  return token!;
}
