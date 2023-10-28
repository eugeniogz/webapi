import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/login_response.dart';
import '../helpers/globals.dart';

class UserService {
  // Consiga seu IP usando o comando "ipconfig" no Windows ou "ifconfig" no Linux.
  static const String resource = "users/";
  
  http.Client client = http.Client();

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
    } else {
      throw "Login inválido!";
    }
  }

}
