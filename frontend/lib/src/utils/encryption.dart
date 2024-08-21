import 'dart:typed_data';

import 'package:argon2/argon2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef JwtTokenPair = ({String accessToken, String refreshToken});

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
