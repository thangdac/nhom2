class Post {
  Post({
    required this.id,
    required this.name,
    required this.data,
    required this.image,
    required this.description,
    required this.user,
  });

  final int? id;
  final String? name;
  final DateTime? data;
  final String? image;
  final String? description;
  final User? user;

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      name: json["name"],
      data: DateTime.tryParse(json["data"] ?? ""),
      image: json["image"],
      description: json["description"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "data": data?.toIso8601String(),
    "image": image,
    "description": description,
    "user": user?.toJson(),
  };
}

class User {
  User({
    required this.name,
    required this.profileImage,
  });

  final String name;
  final String profileImage;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"] ?? 'Unknown',
      profileImage: json["profileImage"] ?? 'assets/default_profile.png', // Default image if not available
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "profileImage": profileImage,
  };
}
