import '../core/api_client.dart';

class ApiService {
  final ApiClient _client = ApiClient();

  Future<String> login(String username, String password) async {
    final response = await _client.post(
      '/auth/login',
      {'username': username, 'password': password},
    );
    if (response['success'] == true) {
      return response['token'] as String;
    }
    throw ApiException('Login failed');
  }
}
