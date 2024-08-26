import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class JwtTokenPair {
  final String accessToken;
  final String refreshToken;

  const JwtTokenPair({
    required this.accessToken,
    required this.refreshToken,
  });

  factory JwtTokenPair.fromJson(Map<String, dynamic> jwtJson) {
    return switch (jwtJson) {
      {
        'accessToken': String accessToken,
        'refreshToken': String refreshToken,
      } =>
        JwtTokenPair(
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      _ => throw const FormatException('Failed to parse tokens.'),
    };
  }
}

const type = Argon2Parameters.ARGON2_id;
const version = Argon2Parameters.ARGON2_VERSION_10;
const iterations = 3;
const memoryConsumedPowerOf2 = 14;
const hashLength = 32;

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
