import 'dart:convert';
import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class JwtHeader {
  final String tokenType;
  final String api;

  JwtHeader({required this.tokenType, required this.api});

  factory JwtHeader.fromJson(Map<String, dynamic> header) {
    return switch (header) {
      {
        'tokenType': String tokenType,
        'api': String api,
      } =>
        JwtHeader(
          tokenType: tokenType,
          api: api,
        ),
      _ => throw const FormatException('Failed to parse tokens.'),
    };
  }
}

class JwtBody {
  final int sub;
  final int iat;
  final int? exp;
  final String permissionLevel;

  JwtBody({
    required this.sub,
    required this.iat,
    this.exp,
    required this.permissionLevel,
  });

  factory JwtBody.fromJson(Map<String, dynamic> body) {
    return switch (body) {
      {
        'sub': int sub,
        'iat': int iat,
        'exp': int exp,
        'permissionLevel': String permissionLevel,
      } =>
        JwtBody(
          sub: sub,
          iat: iat,
          exp: exp,
          permissionLevel: permissionLevel,
        ),
      {
        'sub': int sub,
        'iat': int iat,
        'permissionLevel': String permissionLevel,
      } =>
        JwtBody(
          sub: sub,
          iat: iat,
          permissionLevel: permissionLevel,
        ),
      _ => throw const FormatException('Failed to parse tokens.'),
    };
  }
}

class Jwt {
  final JwtHeader header;
  final JwtBody body;
  final String signature;
  final String string;

  const Jwt({
    required this.header,
    required this.body,
    required this.signature,
    required this.string,
  });

  static (String, String, String) decode(String encodedJwt) {
    List<String> parts = encodedJwt.split(".");

    if (parts.length != 3) {
      print("${encodedJwt}, ${parts}");
      print("jwt len: ${parts.length}");
      throw const FormatException('Invalid JWT. Occured in Jwt.decode');
    }

    var [encodedHeader, encodedBody, signature] = parts;

    String decodedHeader = utf8.decode(base64.decode(encodedHeader));
    String decodedBody = utf8.decode(base64.decode(encodedBody));

    return (decodedHeader, decodedBody, signature);
  }

  factory Jwt.fromString(String encodedJwt) {
    var (decodedHeader, decodedBody, decodedSignature) = Jwt.decode(encodedJwt);

    return Jwt(
        header: JwtHeader.fromJson(jsonDecode(decodedHeader)),
        body: JwtBody.fromJson(jsonDecode(decodedBody)),
        signature: decodedSignature,
        string: encodedJwt);
  }

  @override
  String toString() {
    return string;
  }
}

class JwtPair {
  final Jwt accessToken;
  final Jwt refreshToken;

  const JwtPair({
    required this.accessToken,
    required this.refreshToken,
  });

  factory JwtPair.fromJson(Map<String, dynamic> pairJson) {
    return switch (pairJson) {
      {
        'accessToken': String accessToken,
        'refreshToken': String refreshToken,
      } =>
        JwtPair(
          accessToken: Jwt.fromString(accessToken),
          refreshToken: Jwt.fromString(refreshToken),
        ),
      _ => throw const FormatException('Failed to parse tokens.'),
    };
  }

  factory JwtPair.fromString(String accessTokenString, String refreshTokenString) {
    return JwtPair(
      accessToken: Jwt.fromString(accessTokenString),
      refreshToken: Jwt.fromString(refreshTokenString),
    );
  }
}

const type = Argon2Parameters.ARGON2_id;
const version = Argon2Parameters.ARGON2_VERSION_10;
const iterations = 3;
const memoryConsumedPowerOf2 = 14;
const hashLength = 32;

class JwtPairModel extends ChangeNotifier {
  JwtPair? _tokens;

  JwtPairModel() {
    _setFromStorage();
  }

  JwtPair? get tokens => _tokens;

  // TODO: include loader of some sort while waiting for storage.read or Roles.unauthenticated
  Future<void> _setFromStorage() async {
    const storage = FlutterSecureStorage();
    String? accessTokenString = await storage.read(key: 'accessToken');
    String? refreshTokenString = await storage.read(key: 'refreshToken');
    if (accessTokenString == null || refreshTokenString == null) return;
    _tokens = JwtPair.fromString(accessTokenString, refreshTokenString);
    notifyListeners();
  }

  void setTokens(JwtPair? tokens) async {
    const storage = FlutterSecureStorage();
    if (tokens != null) {
      await storage.write(key: 'accessToken', value: tokens.accessToken.string);
      await storage.write(key: 'refreshToken', value: tokens.refreshToken.string);
    } else {
      await storage.write(key: 'accessToken', value: null);
      await storage.write(key: 'refreshToken', value: null);
    }
    _tokens = tokens;
    notifyListeners();
  }
}

String hashPassword(String username, String password) {
  final salt = (username + dotenv.env['CLIENT_PEPPER']!).toBytesLatin1();

  final parameters = Argon2Parameters(
    type,
    salt,
    version: version,
    iterations: iterations,
    memoryPowerOf2: memoryConsumedPowerOf2,
  );

  final argon2 = Argon2BytesGenerator();

  argon2.init(parameters);

  final passwordBytes = parameters.converter.convert(password);

  final result = Uint8List(hashLength);
  argon2.generateBytes(passwordBytes, result, 0, result.length);

  final resultHex = result.toHexString();

  return resultHex;
}
