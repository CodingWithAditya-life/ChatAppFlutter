
import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? name;
  String? email;
  String? photo_url;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.photo_url
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    photo_url: json["photo_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "photo_url": photo_url
  };
}
