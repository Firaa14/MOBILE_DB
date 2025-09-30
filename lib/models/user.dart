class AppUser {
  final int id;
  final String email;
  final String passwordHash;
  final String salt;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.email,
    required this.passwordHash,
    required this.salt,
    required this.createdAt,
  });

  factory AppUser.fromMap(Map<String, Object?> m) => AppUser(
    id: m['id'] as int,
    email: m['email'] as String,
    passwordHash: m['password_hash'] as String,
    salt: m['salt'] as String,
    createdAt: DateTime.parse(m['created_at'] as String),
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'email': email,
    'password_hash': passwordHash,
    'salt': salt,
    'created_at': createdAt.toIso8601String(),
  };
}
