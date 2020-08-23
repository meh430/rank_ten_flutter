import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rank_ten/api/rank_exceptions.dart';

class RankApi {
  final _baseUrl = 'http://192.168.0.22:5000';

  Future<bool> validateImage(String imageUrl) async {
    var isValid = false;
    try {
      final res = await http.get(imageUrl, headers: {'Accept': 'image/*'});
      print(res.headers);
      print(res.statusCode);

      isValid = res.statusCode == 200 &&
          res.headers['content-type'].contains("image");
      print("Image is valid: $isValid");
    } on SocketException {
      throw DefaultError('No network connection');
    }

    return isValid;
  }

  Future<dynamic> get(
      {@required String endpoint, String bearerToken = ""}) async {
    var jsonResponse;

    try {
      final res = await http.get(_baseUrl + endpoint,
          headers: _getHeaders(bearerToken: bearerToken));
      jsonResponse = _parseResponse(res);
    } on SocketException {
      throw DefaultError('No network connection');
    }

    return jsonResponse;
  }

  Future<dynamic> post(
      {@required String endpoint,
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
      throw DefaultError('No network connection');
    }

    return jsonResponse;
  }

  Future<dynamic> put(
      {@required String endpoint,
      Map<String, dynamic> data,
      String bearerToken = ""}) async {
    if (data == null) {
      data = Map<String, String>();
    }
    var jsonResponse;

    try {
      final res = await http.put(_baseUrl + endpoint,
          body: json.encode(data),
          headers: _getHeaders(bearerToken: bearerToken));
      jsonResponse = _parseResponse(res);
    } on SocketException {
      throw DefaultError('No network connection');
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
        if (res.body.toString().contains("page")) {
          throw InvalidPageError(res.body.toString());
        } else {
          throw SchemaValidationError(res.body.toString());
        }

        break;
      case 401:
        throw AuthenticationError(res.body.toString());
      case 403:
        throw UnauthorizedError(res.body.toString());
      default:
        throw DefaultError(res.body.toString());
    }
  }
}
