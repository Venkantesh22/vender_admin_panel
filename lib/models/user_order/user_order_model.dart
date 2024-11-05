import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/timestamped_model/date_time_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';

class OrderModel {
  final String orderId;
  final String userId;
  final String vendorId;
  final String adminId;
  final int appointmentNo;
  final List<ServiceModel> services;
  final String status;
  final String totalPrice;
  final String subtatal;
  final String platformFees; // New field added
  final String payment;
  final String serviceDuration;
  final String serviceDate;
  final String serviceStartTime;
  final String serviceEndTime;
  final String userNote;
  // final SalonModel salonModel;
  // final UserModel userModel;
  final List<TimeDateModel> timeDateList; // New field added
  final bool isUpdate;
  OrderModel({
    required this.orderId,
    required this.userId,
    required this.vendorId,
    required this.adminId,
    required this.appointmentNo,
    required this.services,
    required this.status,
    required this.totalPrice,
    required this.subtatal, // Initialize new field
    required this.platformFees, // Initialize new field
    required this.payment,
    required this.serviceDuration,
    required this.serviceDate,
    required this.serviceStartTime,
    required this.serviceEndTime,
    required this.userNote,
    // required this.salonModel,
    // required this.userModel,
    required this.timeDateList, // Initialize new field
    this.isUpdate = false,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        orderId: json['orderId'] ?? '',
        userId: json['userId'] ?? '',
        vendorId: json['vendorId'] ?? '',
        adminId: json['adminId'] ?? '',
        appointmentNo: (json['appointmentNo'] ?? 0.0) as int,
        services: (json['services'] as List?)
                ?.map((item) => ServiceModel.fromJson(item))
                .toList() ??
            [],
        status: json['status'] ?? 'error',
        totalPrice: (json['totalPrice'] ?? 0.0).toString(),
        platformFees: (json['platformFees'] ?? 0.0).toString(),
        subtatal: (json['subtatal'] ?? 0.0).toString(),
        payment: json['payment'] ?? 'Unknown',
        serviceDuration: json['serviceDuration'] ?? '0h 0m',
        serviceDate: json['serviceDate'] ?? 'Unknown Date',
        serviceStartTime: json['serviceStartTime'] ?? 'Unknown Start Time',
        serviceEndTime: json['serviceEndTime'] ?? 'Unknown End Time',
        userNote: json['userNote'] ?? '',
        // salonModel:
        //     SalonModel.fromJson(json['salonModel'], json['salonModel']['id']),
        // userModel: UserModel.fromJson(json['userModel'] ?? {}),
        timeDateList: (json['timeDateList'] as List?)
                ?.map((item) => TimeDateModel.fromJson(item))
                .toList() ??
            [],
        isUpdate: json['isUpdate']);
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'vendorId': vendorId,
      'adminId': adminId,
      'appointmentNo': appointmentNo,
      'services': services.map((e) => e.toJson()).toList(),
      'status': status,
      'totalPrice': totalPrice,
      'subtatal': subtatal, // Serialize the new field
      'platformFees': platformFees, // Serialize the new field
      'payment': payment,
      'serviceDuration': serviceDuration,
      'serviceDate': serviceDate,
      'serviceStartTime': serviceStartTime,
      'serviceEndTime': serviceEndTime,
      'userNote': userNote,
      // 'salonModel': salonModel.toJson(),
      // 'userModel': userModel.toJson(),
      'timeDateList': timeDateList
          .map((e) => e.toJson())
          .toList(), // Serialize the list of TimeDateModel
      "isUpdate": isUpdate,
    };
  }

  OrderModel copyWith({
    List<ServiceModel>? services,
    UserModel? userModel,
    String? status,
    String? totalPrice,
    String? subtatal, // New field in copyWith method
    String? platformFees, // New field in copyWith method
    String? payment,
    String? serviceDuration,
    String? serviceDate,
    String? serviceStartTime,
    String? serviceEndTime,
    String? userNote,
    String? appointmentStatus,
    List<TimeDateModel>? timeDateList, // New field in copyWith method
    bool? isUpdate,
  }) {
    return OrderModel(
      orderId: orderId,
      userId: userId,
      vendorId: vendorId,
      adminId: adminId,
      appointmentNo: appointmentNo,
      services: services ?? this.services,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      subtatal: subtatal ?? this.subtatal, // Updated with the new field
      platformFees:
          platformFees ?? this.platformFees, // Updated with the new field
      payment: payment ?? this.payment,
      serviceDuration: serviceDuration ?? this.serviceDuration,
      serviceDate: serviceDate ?? this.serviceDate,
      serviceStartTime: serviceStartTime ?? this.serviceStartTime,
      serviceEndTime: serviceEndTime ?? this.serviceEndTime,
      userNote: userNote ?? this.userNote,

      timeDateList:
          timeDateList ?? this.timeDateList, // Updated with the new field
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }
}
