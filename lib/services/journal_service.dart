import 'dart:convert';

import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

import '../models/journal.dart';
import '../helpers/globals.dart';

class JournalService {
  // Consiga seu IP usando o comando "ipconfig" no Windows ou "ifconfig" no Linux.
  static const String url = "http://192.168.0.36:3001/";
  static const String resource = "journals/";

  http.Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
  );

  String getURL() {
    return "$url$resource";
  }

  Uri getUri() {
    return Uri.parse(getURL());
  }

  Future<bool> register(Journal journal) async {
    String journalJSON = json.encode(journal.toMap());

    http.Response response = await client.post(
      getUri(),
      headers: {'Content-type': 'application/json',
      'Authorization': "Bearer $accessToken"},
      body: journalJSON,
    );

    if (response.statusCode == 201) {
      return true;
    }

    return false;
  }

  Future<bool> edit(Journal journal) async {
    String journalJSON = json.encode(journal.toMap());
    String id = journal.id;
    http.Response response = await client.patch(
      Uri.parse("$url$resource$id"),
      headers: {'Content-type': 'application/json',
      'Authorization': "Bearer $accessToken"},
      body: journalJSON,
    );

    if (response.statusCode < 300) {
      return true;
    }

    return false;
  }

  Future<bool> delete(Journal journal) async {
    //String journalJSON = json.encode(journal.toMap());
    String id = journal.id;
    http.Response response = await client.delete(
      Uri.parse("$url$resource$id"),
      headers: {'Content-type': 'application/json',
      'Authorization': "Bearer $accessToken"},
      //body: journalJSON,
    );

    if (response.statusCode < 300) {
      return true;
    }

    return false;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(getUri(),
    headers: {'Content-type': 'application/json',
      'Authorization': "Bearer $accessToken"});

    if (response.statusCode != 200) {
      //TODO: Criar uma exceção personalizada
      throw Exception();
    }

    List<Journal> result = [];

    List<dynamic> jsonList = json.decode(response.body);
    // for (var jsonMap in jsonList) {
    //   result.add(Journal.fromMap(jsonMap));
    // }
    result = jsonList.map((e) => Journal.fromMap(e)).toList();

    return result;
  }

}
