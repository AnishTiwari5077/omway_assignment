import '../core/api_client.dart';
import '../core/constants.dart';
import '../models/product.dart';

class ProductService {
  final ApiClient _client = ApiClient();

  Future<List<Product>> getProducts() async {
    final response = await _client.get(AppConstants.productsEndpoint);
    final data = response['data'] as List;
    return data.map((json) => Product.fromJson(json)).toList();
  }

  Future<Product> getProduct(String id) async {
    final response = await _client.get('${AppConstants.productsEndpoint}/$id');
    return Product.fromJson(response['data']);
  }

  Future<Product> createProduct(Product product) async {
    final response = await _client.post(
      AppConstants.productsEndpoint,
      product.toJson(),
    );
    return Product.fromJson(response['data']);
  }

  Future<Product> updateProduct(String id, Product product) async {
    final response = await _client.put(
      '${AppConstants.productsEndpoint}/$id',
      product.toJson(),
    );
    return Product.fromJson(response['data']);
  }

  Future<void> deleteProduct(String id) async {
    await _client.delete('${AppConstants.productsEndpoint}/$id');
  }
}
