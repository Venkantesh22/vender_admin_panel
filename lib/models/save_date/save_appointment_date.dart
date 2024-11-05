class SaveDateModel {
  final String date;

  // Constructor
  SaveDateModel({required this.date});

  // fromJson: A factory constructor to create a SaveDateModel instance from a JSON map
  factory SaveDateModel.fromJson(Map<String, dynamic> json) {
    return SaveDateModel(
      date: json['date'] as String,
    );
  }

  // toJson: Converts the SaveDateModel instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'date': date,
    };
  }

  // copyWith: Creates a copy of the SaveDateModel instance with the option to modify specific fields
  SaveDateModel copyWith({String? date}) {
    return SaveDateModel(
      date: date ?? this.date,
    );
  }
}
