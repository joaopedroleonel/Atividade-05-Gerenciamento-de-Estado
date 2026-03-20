import 'dart:convert';
import 'package:http/http.dart' as http;
import '../errors/failures.dart';

class HttpClient {
  final http.Client _client;

  HttpClient({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw ServerFailure(
          'Erro no servidor: ${response.statusCode}',
        );
      }
    } on ServerFailure {
      rethrow;
    } catch (e) {
      throw NetworkFailure('Falha na conexão: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
