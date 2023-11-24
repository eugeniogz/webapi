import 'dart:convert';

import 'package:memo_webapi/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/intercepted_client.dart';

import '../models/journal.dart';
import '../helpers/globals.dart';

class JournalService {
  
  static const String resource = "journals";

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
      headers: {
        'Content-type': 'application/json',
        'Authorization': "Bearer $accessToken"
      },
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
      Uri.parse("$url$resource/$id"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': "Bearer $accessToken",
        'accept': '*/*'
      },
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
      Uri.parse("$url$resource/$id"),
      headers: {
        'Content-type': 'application/json',
        'Authorization': "Bearer $accessToken"
      },
      //body: journalJSON,
    );

    if (response.statusCode < 300) {
      return true;
    }

    return false;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(getUri(), headers: {
      'Content-type': 'application/json',
      'Authorization': "Bearer $accessToken"
    });

    if (response.statusCode != 200) {
      throw Exception("Erro ${response.statusCode}");
    }

    List<dynamic> jsonList = json.decode(response.body);

    List<Journal> listJournal = [];
    for (var jsonMap in jsonList) {
      listJournal.add(Journal.fromMap(jsonMap));
    }

    listJournal.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return listJournal;
  }

  Future<Journal?> get(String id) async {
    http.Response response = await client.get(Uri.parse("${getURL()}/$id"),
        headers: {
          'Content-type': 'application/json',
          'Authorization': "Bearer $accessToken"
        });

    if (response.statusCode != 200 && response.statusCode != 404) {
      throw Exception("Erro ${response.statusCode}");
    }
    if (response.statusCode == 404) return null;
    
    dynamic jsonRet = json.decode(response.body);

    return Journal.fromMap(jsonRet);
  }
}
