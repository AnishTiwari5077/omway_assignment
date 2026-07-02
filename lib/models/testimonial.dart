class Testimonial {
  final String id;
  final String authorName;
  final String role;
  final String content;
  final double rating;
  final String? avatarUrl;
  final String? createdAt;

  const Testimonial({
    required this.id,
    required this.authorName,
    required this.role,
    required this.content,
    required this.rating,
    this.avatarUrl,
    this.createdAt,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'] as String,
      authorName: json['authorName'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      rating: (json['rating'] as num).toDouble(),
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorName': authorName,
      'role': role,
      'content': content,
      'rating': rating,
      'avatarUrl': avatarUrl ?? '',
    };
  }

  Testimonial copyWith({
    String? id,
    String? authorName,
    String? role,
    String? content,
    double? rating,
    String? avatarUrl,
  }) {
    return Testimonial(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      role: role ?? this.role,
      content: content ?? this.content,
      rating: rating ?? this.rating,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt,
    );
  }
}
