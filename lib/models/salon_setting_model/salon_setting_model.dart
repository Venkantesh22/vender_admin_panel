class SettingModel {
  String id;
  String salonId;
  String diffbtwTimetap; // changed from double to String
  bool isUpdate; // added variable with default value false
  int dayForBooking; // new variable

  SettingModel({
    required this.id,
    required this.salonId,
    required this.diffbtwTimetap,
    this.isUpdate = false, // default value is false
    required this.dayForBooking, // new variable added to constructor
  });

  // Factory constructor to create an instance from a JSON map
  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      id: json['id'],
      salonId: json['salonId'],
      diffbtwTimetap: json['diffbtwTimetap']
          .toString(), // changed from toDouble() to toString()
      isUpdate: json['isUpdate'] ??
          false, // default value is false if not present in JSON
      dayForBooking: json['dayForBooking'] ?? 0, // new variable from JSON
    );
  }

  // Method to convert an instance of SettingModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'salonId': salonId,
      'diffbtwTimetap': diffbtwTimetap,
      'isUpdate': isUpdate,
      'dayForBooking': dayForBooking, // new variable added to JSON
    };
  }

  // CopyWith method to clone the instance with optional new values
  SettingModel copyWith({
    String? diffbtwTimetap, // changed from double to String
    bool? isUpdate,
    int? dayForBooking, // new variable added to copyWith
  }) {
    return SettingModel(
      id: id,
      salonId: salonId,
      diffbtwTimetap: diffbtwTimetap ?? this.diffbtwTimetap,
      isUpdate: isUpdate ?? this.isUpdate,
      dayForBooking: dayForBooking ??
          this.dayForBooking, // new variable handled in copyWith
    );
  }
}
