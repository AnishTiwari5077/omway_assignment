class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String message;
  final bool isRead;
  final String? createdAt;

  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.message,
    required this.isRead,
    this.createdAt,
  });

  factory ContactMessage.fromJson(Map<String, dynamic> json) {
    return ContactMessage(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      message: json['message'] as String,
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'message': message,
    };
  }

  ContactMessage copyWith({bool? isRead}) {
    return ContactMessage(
      id: id,
      name: name,
      email: email,
      phone: phone,
      message: message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}
