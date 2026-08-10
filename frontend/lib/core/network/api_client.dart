import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

/// Thin wrapper around http so the rest of the app never touches raw HTTP.
class ApiClient {
  final String baseUrl;
  ApiClient({this.baseUrl = AppConstants.apiBaseUrl});

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, dynamic>> get(String path) async {
    final response = await http.get(_uri(path));
    return _decode(response);
  }

  Future<Map<String, dynamic>> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      _uri(path),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<void> delete(String path) async {
    final response = await http.delete(_uri(path));
    if (response.statusCode >= 400) {
      throw ApiException('Request failed (${response.statusCode})');
    }
  }

  Map<String, dynamic> _decode(http.Response response) {
    if (response.statusCode >= 400) {
      String message = 'Request failed (${response.statusCode})';
      try {
        final body = jsonDecode(response.body);
        if (body is Map && body['error'] != null) message = body['error'];
      } catch (_) {}
      throw ApiException(message);
    }
    if (response.body.isEmpty) return {};
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}
