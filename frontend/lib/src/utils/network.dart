import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Rybocheck/src/utils/encryption.dart';

typedef ServerResponse<T> = ({T? responseBody, String status, String? error});

typedef AuthResponse = ({JwtTokenPair? tokens, String status, String? error});

Future<T> postRequest<T>(String path, Object body) async {
  final String apiUrl = dotenv.env['API_URL']!;

  final response = await http.post(Uri.parse('https://$apiUrl/$path'), body: body);

  return jsonDecode(response.body) as T;
}

Future<AuthResponse> login(String username, String password) async {
  final hashedPassword = hashPassword(username, password);

  final result =
      await postRequest<ServerResponse<JwtTokenPair>>("login", {username: username, hashedPassword: hashedPassword});

  print(result);

  if (result.status == "success") {
    return (tokens: result.responseBody!, status: result.status, error: null);
  } else {
    return (error: result.error!, status: result.status, tokens: null);
  }
}

Future<AuthResponse> register(String username, String password, [String? email, String? phoneNumber]) async {
  final hashedPassword = hashPassword(username, password);

  final result = await postRequest<ServerResponse<JwtTokenPair>>(
      "register", {username: username, hashedPassword: hashedPassword, email: email, phoneNumber: phoneNumber});

  if (result.status == "success") {
    return (tokens: result.responseBody!, status: result.status, error: null);
  } else {
    return (error: result.error!, status: result.status, tokens: null);
  }
}
