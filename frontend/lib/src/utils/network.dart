import 'package:http/http.dart' as http;
import 'package:fargon2/fargon2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<http.Response> login(String username, String password) async {
  final hashedPassword = await const Fargon2(mode: Fargon2Mode.argon2id).hash(
    passphrase: 'mypassphrase',
    salt: username + dotenv.env['CLIENT_PEPPER']!,
    hashLength: 16,
    iterations: 3,
    parallelism: 1,
    memoryKibibytes: 12288,
  );

  final String apiUrl = dotenv.env['CLIENT_PEPPER']!;

  return http.get(Uri.parse('https://$apiUrl/login'));
}

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
}
