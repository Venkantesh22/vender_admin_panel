import 'dart:convert';

import 'package:samay_admin_plan/models/timestamped_model/date_time_model.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.image,
    required this.email,
    required this.password,
    required this.timeDateModel,
  });

  String id;
  String name;
  String phone;
  String image;
  String email;
  String password;
  TimeDateModel timeDateModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        phone: json["phone" ?? "0"],
        image: json["image"],
        email: json["email"],
        password: json["password"],
        timeDateModel: TimeDateModel.fromJson(json["timeDateModel"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "image": image,
        "email": email,
        "password": password,
        "timeDateModel": timeDateModel.toJson(),
      };

  UserModel copyWith({
    String? name,
    String? phone,
    String? image,
    String? email,
    String? password,
    TimeDateModel? timeDateModel,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      email: email ?? this.email,
      password: password ?? this.password,
      timeDateModel: timeDateModel ?? this.timeDateModel,
    );
  }
}
