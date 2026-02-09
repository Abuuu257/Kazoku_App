import 'dart:io';

class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? profileImageUrl; // URL from backend
  final File? profileImageLocal; // Local file for temporary display

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.profileImageUrl,
    this.profileImageLocal,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      profileImageUrl: json['profile_image'],
      profileImageLocal: null,
    );
  }

  // CopyWith method to help update immutable user object
  User copyWith({
    String? name,
    String? username,
    String? email,
    String? profileImageUrl,
    File? profileImageLocal,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      profileImageLocal: profileImageLocal ?? this.profileImageLocal,
    );
  }

  // Get the full URL for the profile image
  String? get fullProfileImageUrl {
    if (profileImageUrl == null || profileImageUrl!.isEmpty) return null;
    // If it's already a full URL, return it
    if (profileImageUrl!.startsWith('http')) return profileImageUrl;
    // Otherwise, construct the full URL
    return 'https://kazokuweb-production.up.railway.app/storage/$profileImageUrl';
  }
}
