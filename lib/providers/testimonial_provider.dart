import 'package:flutter/foundation.dart';
import '../models/testimonial.dart';
import '../services/testimonial_service.dart';

class TestimonialProvider extends ChangeNotifier {
  final TestimonialService _service = TestimonialService();

  List<Testimonial> _testimonials = [];
  bool _isLoading = false;
  String? _error;

  List<Testimonial> get testimonials => _testimonials;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTestimonials() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _testimonials = await _service.getTestimonials();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createTestimonial(Testimonial testimonial) async {
    try {
      final newItem = await _service.createTestimonial(testimonial);
      _testimonials.add(newItem);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTestimonial(String id, Testimonial testimonial) async {
    try {
      final updated = await _service.updateTestimonial(id, testimonial);
      final idx = _testimonials.indexWhere((t) => t.id == id);
      if (idx != -1) {
        _testimonials[idx] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTestimonial(String id) async {
    try {
      await _service.deleteTestimonial(id);
      _testimonials.removeWhere((t) => t.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
