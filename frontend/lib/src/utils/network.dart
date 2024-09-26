import 'dart:convert';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:Rybocheck/src/utils/jwt.dart';

const pingPongDuration = 3;

// TODO: for entire file: rewrite request functions to extract common parts

// TODO: change status from String to enum
class ServerResponse<T> {
  final String status;
  final T? responseBody;
  final String? error;

  const ServerResponse(this.status, this.responseBody, this.error);

  static String errorFromBody(Map<String, dynamic> jsonBody) {
    return switch (jsonBody) {
      {'status': String _, 'error': String error} => error,
      _ => throw const FormatException('Value is not an error.')
    };
  }

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

Future<ServerResponse<JwtPair>> getValidTokens() async {
  final String apiUrl = dotenv.env['API_URL']!;
  const storage = FlutterSecureStorage();
  final accessTokenString = await storage.read(key: 'accessToken');
  final refreshTokenString = await storage.read(key: 'refreshToken');
  if (accessTokenString == null || refreshTokenString == null) {
    return const ServerResponse('error', null, 'invalidAuth');
  }
  final accessToken = Jwt.fromString(accessTokenString);
  final refreshToken = Jwt.fromString(refreshTokenString);
  final currentSeconds = DateTime.now().millisecondsSinceEpoch / 1000;
  if (accessToken.body.exp! >= currentSeconds + pingPongDuration) {
    return ServerResponse('success', JwtPair(accessToken: accessToken, refreshToken: refreshToken), null);
  }
  final newTokens = await http.post(Uri.parse('http://$apiUrl/refresh'),
      body: jsonEncode({'refreshToken': refreshToken}),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${accessToken.string}',
        HttpHeaders.contentTypeHeader: "application/json"
      });
  if (newTokens.statusCode != 200) {
    return ServerResponse('error', null, ServerResponse.errorFromBody(jsonDecode(newTokens.body)));
  }
  return ServerResponse('success', JwtPair.fromJson(jsonDecode(newTokens.body)), null);
}

Future<ServerResponse<T>> getRequestNoAuth<T>(String path, T Function(Map<String, dynamic>) responseConstructor) async {
  final String apiUrl = dotenv.env['API_URL']!;
  try {
    final response = await http.get(Uri.parse('http://$apiUrl/$path'));
    return ServerResponse.fromJson(jsonDecode(response.body), responseConstructor);
  } on SocketException {
    return const ServerResponse('error', null, 'socketException');
  } catch (err) {
    rethrow;
  }
}

Future<ServerResponse<T>> getRequest<T>(String path, T Function(Map<String, dynamic>) responseConstructor) async {
  final String apiUrl = dotenv.env['API_URL']!;
  try {
    final validTokens = await getValidTokens();
    if (validTokens.status == 'error') return validTokens as ServerResponse<T>;
    final response = await http.get(
      Uri.parse('http://$apiUrl/$path'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer ${validTokens.responseBody!.accessToken.string}',
      },
    );
    return ServerResponse.fromJson(jsonDecode(response.body), responseConstructor);
  } on SocketException {
    return const ServerResponse('error', null, 'socketException');
  } catch (err) {
    rethrow;
  }
}

Future<ServerResponse<T>> postRequestNoAuth<T>(
    String path, Object body, T Function(Map<String, dynamic>) responseConstructor) async {
  final String apiUrl = dotenv.env['API_URL']!;
  try {
    final response = await http.post(Uri.parse('http://$apiUrl/$path'),
        body: jsonEncode(body), headers: {HttpHeaders.contentTypeHeader: "application/json"});
    return ServerResponse.fromJson(jsonDecode(response.body), responseConstructor);
  } on SocketException {
    return const ServerResponse('error', null, 'socketException');
  } catch (err) {
    rethrow;
  }
}

Future<ServerResponse<T>> postRequest<T>(
    String path, Object body, T Function(Map<String, dynamic>) responseConstructor) async {
  final String apiUrl = dotenv.env['API_URL']!;
  try {
    final validTokens = await getValidTokens();
    if (validTokens.status == 'error') return validTokens as ServerResponse<T>;
    final response = await http.post(Uri.parse('http://$apiUrl/$path'), body: jsonEncode(body), headers: {
      HttpHeaders.authorizationHeader: 'Bearer ${validTokens.responseBody!.accessToken.string}',
      HttpHeaders.contentTypeHeader: "application/json"
    });
    return ServerResponse.fromJson(jsonDecode(response.body), responseConstructor);
  } on SocketException {
    return const ServerResponse('error', null, 'socketException');
  } catch (err) {
    rethrow;
  }
}

Future<ServerResponse<JwtPair>> login(String username, String password) async {
  final hashedPassword = hashPassword(username, password);

  return await postRequestNoAuth<JwtPair>(
      "login", {'username': username, 'password': hashedPassword}, JwtPair.fromJson);
}

Future<ServerResponse<JwtPair>> register(String username, String password, [String? email, String? phoneNumber]) async {
  final hashedPassword = hashPassword(username, password);

  return await postRequestNoAuth<JwtPair>("register",
      {'username': username, 'password': hashedPassword, 'email': email, 'phoneNumber': phoneNumber}, JwtPair.fromJson);
}

String localizeErrorResponse(String key, BuildContext context) {
  switch (key) {
    case "argon2Error":
      return AppLocalizations.of(context)!.argon2Error;
    case "sqlxError":
      return AppLocalizations.of(context)!.sqlxError;
    case "wrongCredentials":
      return AppLocalizations.of(context)!.wrongCredentials;
    case "badRequest":
      return AppLocalizations.of(context)!.badRequest;
    case "invalidAuth":
      return AppLocalizations.of(context)!.invalidAuth;
    case "userExists":
      return AppLocalizations.of(context)!.userExists;
    case "unauthenticated":
      return AppLocalizations.of(context)!.unauthenticated;
    case "unauthorized":
      return AppLocalizations.of(context)!.unauthorized;
    case "socketException":
      return AppLocalizations.of(context)!.socketException;
    default:
      return AppLocalizations.of(context)!.unknownError;
  }
}
