class User {
  final int? id;
  final String username;
  final String password;
  final String? email;
  final DateTime? createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    this.email,
    this.createdAt,
  });

  // Convert User to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Create User from Map (database row)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      email: map['email'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  // Create a copy of User with optional new values
  User copyWith({
    int? id,
    String? username,
    String? password,
    String? email,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, username: $username, email: $email, createdAt: $createdAt}';
  }
}