import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:rank_ten/api/rank_exceptions.dart';

class RankApi {
  final _baseUrl = 'http://192.168.0.22:5000';

  Future<dynamic> get({String endpoint, String bearerToken = ""}) async {
    var jsonResponse;

    try {
      final res = await http.get(_baseUrl + endpoint,
          headers: _getHeaders(bearerToken: bearerToken));
      jsonResponse = _parseResponse(res);
    } on SocketException {
      return DefaultError('No network connection');
    }

    return jsonResponse;
  }

  Future<dynamic> post(
      {String endpoint,
      Map<String, dynamic> data,
      String bearerToken = ""}) async {
    if (data == null) {
      data = Map<String, String>();
    }
    var jsonResponse;

    try {
      final res = await http.post(_baseUrl + endpoint,
          body: json.encode(data),
          headers: _getHeaders(bearerToken: bearerToken));
      jsonResponse = _parseResponse(res);
    } on SocketException {
      return DefaultError('No network connection');
    }

    return jsonResponse;
  }

  Map<String, dynamic> _getHeaders({String bearerToken}) {
    return bearerToken == ""
        ? <String, String>{
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          }
        : <String, String>{
            'Authorization': 'Bearer $bearerToken',
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          };
  }

  dynamic _parseResponse(http.Response res) {
    switch (res.statusCode) {
      case 200:
        return json.decode(res.body.toString());
      case 400:
        return SchemaValidationError(res.body.toString());
      case 401:
        return AuthenticationError(res.body.toString());
      case 403:
        return UnauthorizedError(res.body.toString());
      default:
        return DefaultError(res.body.toString());
    }
  }
}
