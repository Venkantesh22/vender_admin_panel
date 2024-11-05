// class TimeDateModel {
//   final String id;
//   final String date;
//   final String time;

//   TimeDateModel({
//     required this.id,
//     required this.date,
//     required this.time,
//   });

//   factory TimeDateModel.fromJson(Map<String, dynamic> json) {
//     return TimeDateModel(
//       id: json['id'] ?? '', // Default to an empty string if null
//       date: json['date'] ?? '', // Default to an empty string if null
//       time: json['time'] ?? '', // Default to an empty string if null
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'date': date,
//       'time': time,
//     };
//   }

//   // CopyWith method
//   TimeDateModel copyWith({
//     String? id,
//     String? date,
//     String? time,
//   }) {
//     return TimeDateModel(
//       id: id ?? this.id,
//       date: date ?? this.date,
//       time: time ?? this.time,
//     );
//   }
// }
class TimeDateModel {
  final String id;
  final String date;
  final String time;
  final String updateBy;

  TimeDateModel({
    required this.id,
    required this.date,
    required this.time,
    required this.updateBy,
  });

  factory TimeDateModel.fromJson(Map<String, dynamic> json) {
    return TimeDateModel(
      id: json['id'] ?? '', // Default to an empty string if null
      date: json['date'] ?? '', // Default to an empty string if null
      time: json['time'] ?? '', // Default to an empty string if null
      updateBy: json['updateBy'] ?? '', // Default to an empty string if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'updateBy': updateBy,
    };
  }

  // CopyWith method
  TimeDateModel copyWith({
    String? id,
    String? date,
    String? time,
    String? updateBy,
  }) {
    return TimeDateModel(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      updateBy: updateBy ?? this.updateBy,
    );
  }
}
