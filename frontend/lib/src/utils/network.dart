import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Rybocheck/src/utils/jwt.dart';

// TODO: change status from String to enum
class ServerResponse<T> {
  final String status;
  final T? responseBody;
  final String? error;

  const ServerResponse(this.status, this.responseBody, this.error);

  factory ServerResponse.fromJson(Map<String, dynamic> jsonBody, T Function(Map<String, dynamic>) responseConstructor) {
    return switch (jsonBody) {
      {'status': String status, 'body': Map<String, dynamic> body} =>
        ServerResponse(status, responseConstructor(body), null),
      {'status': String status, 'error': String error} => ServerResponse(status, null, error),
      _ => throw const FormatException('Failed to parse response body.'),
    };
  }
}

typedef AuthResponse = ({JwtPair? tokens, String status, String? error});

Future<ServerResponse<T>> getRequest<T>(String path, T Function(Map<String, dynamic>) responseConstructor) async {
  final String apiUrl = dotenv.env['API_URL']!;
  try {
    final response = await http.get(Uri.parse('http://$apiUrl/$path'));
    return ServerResponse.fromJson(jsonDecode(response.body), responseConstructor);
  } catch (err) {
    rethrow;
  }
}

Future<ServerResponse<T>> postRequest<T>(
    String path, Object body, T Function(Map<String, dynamic>) responseConstructor) async {
  final String apiUrl = dotenv.env['API_URL']!;
  try {
    final response = await http
        .post(Uri.parse('http://$apiUrl/$path'), body: jsonEncode(body), headers: {'Content-Type': "application/json"});
    return ServerResponse.fromJson(jsonDecode(response.body), responseConstructor);
  } catch (err) {
    rethrow;
  }
}

Future<ServerResponse<JwtPair>> login(String username, String password) async {
  final hashedPassword = hashPassword(username, password);

  return await postRequest<JwtPair>("login", {'username': username, 'password': hashedPassword}, JwtPair.fromJson);
}

Future<ServerResponse<JwtPair>> register(String username, String password, [String? email, String? phoneNumber]) async {
  final hashedPassword = hashPassword(username, password);

  return await postRequest<JwtPair>("register",
      {'username': username, 'password': hashedPassword, 'email': email, 'phoneNumber': phoneNumber}, JwtPair.fromJson);
}
