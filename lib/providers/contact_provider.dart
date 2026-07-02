import 'package:flutter/foundation.dart';
import '../models/contact_message.dart';
import '../services/contact_service.dart';

class ContactProvider extends ChangeNotifier {
  final ContactService _service = ContactService();

  List<ContactMessage> _contacts = [];
  Map<String, dynamic> _stats = {};
  bool _isLoading = false;
  String? _error;

  List<ContactMessage> get contacts => _contacts;
  Map<String, dynamic> get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount =>
      _contacts.where((c) => !c.isRead).length;

  Future<void> loadContacts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _contacts = await _service.getContacts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStats() async {
    try {
      _stats = await _service.getStats();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> submitContact(ContactMessage contact) async {
    try {
      await _service.submitContact(contact);
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> markAsRead(String id) async {
    try {
      final updated = await _service.markAsRead(id);
      final idx = _contacts.indexWhere((c) => c.id == id);
      if (idx != -1) {
        _contacts[idx] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteContact(String id) async {
    try {
      await _service.deleteContact(id);
      _contacts.removeWhere((c) => c.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
