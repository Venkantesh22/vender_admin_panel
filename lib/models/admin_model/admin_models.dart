import 'dart:convert';

import 'package:samay_admin_plan/models/timestamped_model/date_time_model.dart';

AdminModel adminModelFromJson(String str) =>
    AdminModel.fromJson(json.decode(str));

String adminModelToJson(AdminModel data) => json.encode(data.toJson());

class AdminModel {
  AdminModel(
    this.id,
    this.name,
    this.email,
    this.number,
    this.password,
    this.timeDateModel, {
    this.image = "",
  });

  String id;
  String name;
  String email;
  int number;
  String password;
  String? image;
  TimeDateModel timeDateModel;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        json["id"],
        json["name"],
        json["email"],
        json["number"] != null ? int.parse(json["number"].toString()) : 0,
        json["password"],
        TimeDateModel.fromJson(json["timeDateModel"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "number": number,
        "password": password,
        "timeDateModel": timeDateModel.toJson(),
        "image": image,
      };

  AdminModel copyWith({
    String? id,
    String? name,
    String? email,
    int? number,
    String? password,
    String? image,
    TimeDateModel? timeDateModel,
  }) =>
      AdminModel(
        id ?? this.id,
        name ?? this.name,
        email ?? this.email,
        number ?? this.number,
        password ?? this.password,
        timeDateModel ?? this.timeDateModel,
        image: image ?? this.image,
      );
}
