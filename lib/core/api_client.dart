import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  void setToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  void clearToken() {
    _headers.remove('Authorization');
  }


  // ─── GET ──────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final response = await http.get(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // ─── POST ─────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final response = await http.post(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // ─── PUT ──────────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final response = await http.put(
        uri,
        headers: _headers,
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // ─── DELETE ───────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final response = await http.delete(uri, headers: _headers);
      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  // ─── Response Handler ─────────────────────────────────────────────────────────
  Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw ApiException(
        body['message'] ?? 'Request failed with status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException($statusCode): $message';
}
