import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../helpers/globals.dart';
import '../models/login_response.dart';
import '../models/user.dart';

class UserService {
  // Consiga seu IP usando o comando "ipconfig" no Windows ou "ifconfig" no Linux.
  static const String resource = "users/";
  
  http.Client client = http.Client();
  final secureStorage = const FlutterSecureStorage();

  String getURL() {
    return "$url$resource";
  }

  Uri getUri() {
    return Uri.parse(getURL());
  }

  Future<bool> register(User user) async {
    String userJson = json.encode(user.toMap());

    http.Response response = await client.post(
      getUri(),
      headers: {'Content-type': 'application/json'},
      body: userJson,
    );

    if (response.statusCode == 201) {
      return true;     
    }

    return false;
  }

  Future<void> login(User user1) async {
    String userJson = json.encode(user1.toMap());
    http.Response response = await http.Client().post(
      Uri.parse("${url}login"),
      headers: {'Content-type': 'application/json'},
      body: userJson,
    );

    if (response.statusCode < 300) {
      dynamic resp = json.decode(response.body);
      accessToken = LoginResponse.fromMap(resp).accessToken;
      user = user1;
      await secureStorage.write(key: 'accessToken', value: accessToken);
      await secureStorage.write(key: 'user', value: json.encode(user!.toMap()));
    } else {
      throw "Login inválido!";
    }
  }

  Future<void> logout() async {
    accessToken = null;
    user = null;
    await secureStorage.write(key: 'accessToken', value: null);
    await secureStorage.write(key: 'user', value: null);
  }

  readCachedToken() async {
    accessToken = await secureStorage.read(key: 'accessToken');
    String? userJson = await secureStorage.read(key: 'user');
    user = userJson==null?null:User.fromMap(json.decode(userJson));
  }
}
