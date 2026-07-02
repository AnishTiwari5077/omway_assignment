import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../core/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get token => _token;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await _apiService.login(username, password);
      _token = token;
      _isAuthenticated = true;
      // Set the token in ApiClient for subsequent requests
      ApiClient().setToken(token);
      return true;
    } catch (e) {
      _error = e.toString();
      _isAuthenticated = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _token = null;
    _isAuthenticated = false;
    ApiClient().clearToken();
    notifyListeners();
  }
}
