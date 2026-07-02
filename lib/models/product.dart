class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final bool isFeatured;
  final int stock;
  final String? createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.isFeatured,
    required this.stock,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'isFeatured': isFeatured,
      'stock': stock,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    String? imageUrl,
    bool? isFeatured,
    int? stock,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      stock: stock ?? this.stock,
      createdAt: createdAt,
    );
  }
}
