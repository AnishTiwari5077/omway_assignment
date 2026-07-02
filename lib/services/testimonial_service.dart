import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/testimonial.dart';

class TestimonialService {
  final ApiClient _client = ApiClient();

  Future<List<Testimonial>> getTestimonials() async {
    final response = await _client.get(AppConstants.testimonialsEndpoint);
    final data = response['data'] as List;
    return data.map((json) => Testimonial.fromJson(json)).toList();
  }

  Future<Testimonial> createTestimonial(Testimonial testimonial) async {
    final response = await _client.post(
      AppConstants.testimonialsEndpoint,
      testimonial.toJson(),
    );
    return Testimonial.fromJson(response['data']);
  }

  Future<Testimonial> updateTestimonial(
    String id,
    Testimonial testimonial,
  ) async {
    final response = await _client.put(
      '${AppConstants.testimonialsEndpoint}/$id',
      testimonial.toJson(),
    );
    return Testimonial.fromJson(response['data']);
  }

  Future<void> deleteTestimonial(String id) async {
    await _client.delete('${AppConstants.testimonialsEndpoint}/$id');
  }
}
