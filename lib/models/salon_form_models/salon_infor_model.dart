import 'package:flutter/material.dart';
import 'package:samay_admin_plan/models/timestamped_model/date_time_model.dart';

class SalonModel {
  SalonModel({
    required this.id,
    required this.adminId,
    required this.name,
    required this.email,
    required this.number,
    required this.whatApp,
    required this.salonType,
    required this.description,
    this.openTime,
    this.closeTime,
    required this.address,
    required this.city,
    required this.state,
    required this.pinCode,
    this.instagram,
    this.facebook,
    this.googleMap,
    this.linked,
    this.image,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.isDefaultCategoryCreate = false,
    required this.timeDateModel,
  });

  String id;
  String adminId;
  String name;
  String email;
  int number;
  int whatApp;
  String salonType;
  String description;
  TimeOfDay? openTime; // Changed to TimeOfDay
  TimeOfDay? closeTime; // Changed to TimeOfDay
  String address;
  String city;
  String state;
  String pinCode;
  String? instagram;
  String? facebook;
  String? googleMap;
  String? linked;
  String? image;
  String? monday;
  String? tuesday;
  String? wednesday;
  String? thursday;
  String? friday;
  String? saturday;
  String? sunday;
  bool isDefaultCategoryCreate;
  TimeDateModel timeDateModel;

  factory SalonModel.fromJson(Map<String, dynamic> json, String? id) {
    return SalonModel(
        id: json["id"],
        adminId: json["adminId"],
        name: json["name"],
        email: json["email"],
        number:
            json["number"] != null ? int.parse(json["number"].toString()) : 0,
        whatApp:
            json["whatApp"] != null ? int.parse(json["whatApp"].toString()) : 0,
        salonType: json["salonType"],
        description: json["description"],
        openTime:
            json["openTime"] != null ? _parseTimeOfDay(json["openTime"]) : null,
        closeTime: json["closeTime"] != null
            ? _parseTimeOfDay(json["closeTime"])
            : null,
        address: json["address"],
        city: json['city'],
        state: json['state'],
        pinCode: json['pinCode'],
        instagram: json["instagram"],
        facebook: json["facebook"],
        googleMap: json["googleMap"],
        linked: json["linked"],
        image: json["image"],
        monday: json['monday'],
        tuesday: json['tuesday'],
        wednesday: json['wednesday'],
        thursday: json['thursday'],
        friday: json['friday'],
        saturday: json['saturday'],
        sunday: json['sunday'],
        isDefaultCategoryCreate: json['isDefaultCategoryCreate'] ?? false,
        timeDateModel: TimeDateModel.fromJson(json["timeDateModel"]));
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "adminId": adminId,
        "name": name,
        "email": email,
        "number": number,
        "whatApp": whatApp,
        "salonType": salonType,
        "description": description,
        "openTime": openTime != null ? _formatTimeOfDay(openTime!) : null,
        "closeTime": closeTime != null ? _formatTimeOfDay(closeTime!) : null,
        "address": address,
        'city': city,
        'state': state,
        'pinCode': pinCode,
        "instagram": instagram,
        "facebook": facebook,
        "googleMap": googleMap,
        "linked": linked,
        "image": image,
        'monday': monday,
        'tuesday': tuesday,
        'wednesday': wednesday,
        'thursday': thursday,
        'friday': friday,
        'saturday': saturday,
        'sunday': sunday,
        'isDefaultCategoryCreate': isDefaultCategoryCreate,
        'timeDateModel': timeDateModel.toJson(),
      };

  SalonModel copyWith({
    String? name,
    String? email,
    int? number,
    int? whatApp,
    String? salonType,
    String? description,
    TimeOfDay? openTime, // Updated to TimeOfDay
    TimeOfDay? closeTime, // Updated to TimeOfDay
    String? address,
    String? city,
    String? state,
    String? pinCode,
    String? instagram,
    String? facebook,
    String? googleMap,
    String? linked,
    String? image,
    String? monday,
    String? tuesday,
    String? wednesday,
    String? thursday,
    String? friday,
    String? saturday,
    String? sunday,
    bool? isDefaultCategoryCreate,
  }) {
    return SalonModel(
      id: id,
      adminId: adminId,
      name: name ?? this.name,
      email: email ?? this.email,
      number: number ?? this.number,
      whatApp: whatApp ?? this.whatApp,
      salonType: salonType ?? this.salonType,
      description: description ?? this.description,
      openTime: openTime ?? this.openTime,
      closeTime: closeTime ?? this.closeTime,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      pinCode: pinCode ?? this.pinCode,
      instagram: instagram ?? this.instagram,
      facebook: facebook ?? this.facebook,
      googleMap: googleMap ?? this.googleMap,
      linked: linked ?? this.linked,
      image: image ?? this.image,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
      isDefaultCategoryCreate:
          isDefaultCategoryCreate ?? this.isDefaultCategoryCreate,
      timeDateModel: timeDateModel,
    );
  }

  // Helper method to parse TimeOfDay from a time string
  static TimeOfDay _parseTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hour = int.parse(parts[0].trim());
    final minute = int.parse(parts[1].split(' ')[0].trim());
    final period = parts[1].split(' ')[1].trim().toUpperCase();

    return TimeOfDay(
      hour: period == 'PM' && hour != 12
          ? hour + 12
          : period == 'AM' && hour == 12
              ? 0
              : hour,
      minute: minute,
    );
  }

  // Helper method to format TimeOfDay as a time string
  static String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hourOfPeriod;
    final minute = timeOfDay.minute.toString().padLeft(2, '0');
    final period = timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }
}
