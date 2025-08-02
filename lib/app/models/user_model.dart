class UserModel {
  final String id;
  final String username;
  final String? profileImage;
  final String? bio;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.username,
    this.profileImage,
    this.bio,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      profileImage: json['profile_image'],
      bio: json['bio'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_image': profileImage,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
    };
  }
}