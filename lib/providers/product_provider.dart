import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  List<Product> get featuredProducts =>
      _products.where((p) => p.isFeatured).toList();
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _service.getProducts();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createProduct(Product product) async {
    try {
      final newProduct = await _service.createProduct(product);
      _products.add(newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(String id, Product product) async {
    try {
      final updated = await _service.updateProduct(id, product);
      final idx = _products.indexWhere((p) => p.id == id);
      if (idx != -1) {
        _products[idx] = updated;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      await _service.deleteProduct(id);
      _products.removeWhere((p) => p.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
