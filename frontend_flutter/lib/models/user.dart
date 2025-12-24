class AppUser {
  final int id;
  final String name;
  final String email;
  final String? avatar;
  final String? avatarUrl;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    this.avatarUrl,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      avatar: json['avatar']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
    );
  }
}
