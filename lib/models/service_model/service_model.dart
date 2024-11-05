class ServiceModel {
  final String id;
  final String salonId;
  final String categoryId;
  final String categoryName;
  final String servicesName;
  final String serviceCode;
  final double price;
  final double hours;
  final double minutes;
  final String description;

  ServiceModel({
    required this.id,
    required this.salonId,
    required this.categoryId,
    required this.categoryName,
    required this.servicesName,
    required this.serviceCode,
    required this.price,
    required this.hours,
    required this.minutes,
    required this.description,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      salonId: json['salonId'],
      categoryId: json['categoryId'],
      categoryName: json['categoryName'],
      id: json['id'],
      servicesName: json['servicesName'],
      serviceCode: json['serviceCode'],
      price: json['price'],
      hours: json['hours'],
      minutes: json['minutes'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'salonId': salonId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'id': id,
      'servicesName': servicesName,
      'serviceCode': serviceCode,
      'price': price,
      'hours': hours,
      'minutes': minutes,
      'description': description,
    };
  }

  ServiceModel copyWith({
    // String? salonId,
    // String? categoryId,
    // String? id,
    String? servicesName,
    String? serviceCode,
    double? price,
    double? hours,
    double? minutes,
    String? description,
  }) {
    return ServiceModel(
      salonId: salonId,
      categoryId: categoryId,
      categoryName: categoryName,
      id: id,
      servicesName: servicesName ?? this.servicesName,
      serviceCode: serviceCode ?? this.serviceCode,
      price: price ?? this.price,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      description: description ?? this.description,
    );
  }
}
