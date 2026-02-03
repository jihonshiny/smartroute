class UserProfile {
  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final List<String> favoritePlaceIds;
  final Map<String, dynamic> preferences;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const UserProfile({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    required this.favoritePlaceIds,
    required this.preferences,
    required this.createdAt,
    this.lastLoginAt,
  });

  String get displayName => name ?? email ?? 'User';
  String get initials {
    if (name == null || name!.isEmpty) return 'U';
    final parts = name!.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name![0].toUpperCase();
  }
}
