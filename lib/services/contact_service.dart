import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/contact_message.dart';

class ContactService {
  final ApiClient _client = ApiClient();

  Future<List<ContactMessage>> getContacts() async {
    final response = await _client.get(AppConstants.contactsEndpoint);
    final data = response['data'] as List;
    return data.map((json) => ContactMessage.fromJson(json)).toList();
  }

  Future<ContactMessage> submitContact(ContactMessage contact) async {
    final response = await _client.post(
      AppConstants.contactsEndpoint,
      contact.toJson(),
    );
    return ContactMessage.fromJson(response['data']);
  }

  Future<ContactMessage> markAsRead(String id) async {
    final response = await _client.put(
      '${AppConstants.contactsEndpoint}/$id/read',
      {},
    );
    return ContactMessage.fromJson(response['data']);
  }

  Future<void> deleteContact(String id) async {
    await _client.delete('${AppConstants.contactsEndpoint}/$id');
  }

  Future<Map<String, dynamic>> getStats() async {
    final response = await _client.get(AppConstants.statsEndpoint);
    return response['data'] as Map<String, dynamic>;
  }
}
