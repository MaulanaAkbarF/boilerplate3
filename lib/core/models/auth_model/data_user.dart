import '../../services/http_services/http_connection.dart';

class UserAuth extends Model {
  bool isVerify;
  String accessToken;
  User user;

  UserAuth({
    required this.isVerify,
    required this.accessToken,
    required this.user,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) => UserAuth(
    isVerify: json["is_verify"],
    accessToken: json["access_token"],
    user: User.fromJson(json["user"]),
  );

  @override
  Map<String, dynamic> toJson() => {
    "is_verify": isVerify,
    "access_token": accessToken,
    "user": user,
  };
}

class User extends Model {
  int id;
  String name;
  String email;
  String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"] ?? 0,
    name: json["name"] ?? '',
    email: json["email"] ?? '',
    photoUrl: json["avatar_url"] ?? '',
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "avatar_url": photoUrl,
  };
}