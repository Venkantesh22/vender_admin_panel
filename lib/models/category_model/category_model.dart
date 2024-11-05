class CategoryModel {
  final String id;
  final String categoryName;
  final String salonId;
  final bool haveData;

  CategoryModel({
    required this.id,
    required this.categoryName,
    required this.salonId,
    this.haveData = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'id': id,
      'salonId': salonId,
      'haveData': haveData,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'],
      id: map['id'],
      salonId: map['salonId'],
      haveData: map['haveData'],
    );
  }
  factory CategoryModel.fromJson(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'],
      id: map['id'],
      salonId: map['salonId'],
      haveData: map['haveData'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
        "salonId": salonId,
        "haveData": haveData,
      };

  CategoryModel copyWith({
    String? categoryName,
    bool? haveData,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      id: id,
      salonId: salonId,
      haveData: haveData ?? this.haveData,
    );
  }
}
