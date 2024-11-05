import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/save_date/save_appointment_date.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/timestamped_model/date_time_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/user_order/user_order_model.dart';

class UserBookingFB {
  static UserBookingFB instance = UserBookingFB();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

//! Add New Appointment function

  /// Fetch all services from multiple categories for a specific salon.
  Future<List<ServiceModel>> getAllServicesFromCategories(
      String salonId) async {
    List<ServiceModel> allServices = []; // List to store all services
    String? adminUid = FirebaseAuth.instance.currentUser?.uid;

    try {
      // Fetch all categories under the salon.
      QuerySnapshot categorySnapshot = await FirebaseFirestore.instance
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("category")
          .where("haveData", isEqualTo: true)
          .get();

      // Iterate through categories and fetch services from each one.
      for (var categoryDoc in categorySnapshot.docs) {
        String categoryId = categoryDoc.id;

        // Fetch services for this category.
        QuerySnapshot serviceSnapshot = await FirebaseFirestore.instance
            .collection("admins")
            .doc(adminUid)
            .collection("salon")
            .doc(salonId)
            .collection("category")
            .doc(categoryId)
            .collection("service")
            .get();

        // Iterate through services in the category.
        for (var serviceDoc in serviceSnapshot.docs) {
          try {
            // Parse and add each service to the list.
            ServiceModel service = ServiceModel.fromJson(
                serviceDoc.data() as Map<String, dynamic>);
            allServices.add(service);
          } catch (e) {
            print('Error parsing service data: $e');
          }
        }
      }
    } catch (e) {
      print('Error fetching services: $e');
    }

    return allServices;
  }

//! User Appointment function
  //Get User Appointment by Date
  Future<List<OrderModel>> getUserBookingListFB(
      String selectDate, String salonId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collectionGroup('order')
              .where('serviceDate', isEqualTo: selectDate)
              .where('vendorId', isEqualTo: salonId)
              .get();

      List<OrderModel> bookingList =
          querySnapshot.docs.map((e) => OrderModel.fromJson(e.data())).toList();

      return bookingList;
    } catch (e) {
      print("Error fetching booking list: $e");
      return [];
    }
  }

// Update Appointment by Id
  Future<bool> updateAppointmentFB(
      String userId, appointmentId, OrderModel orderModel) async {
    await _firebaseFirestore
        .collection('UserOrder')
        .doc(userId)
        .collection('order')
        .doc(appointmentId)
        .update(orderModel.toJson());
    return true;
  }

// Save new Appointment
  Future<bool> saveAppointmentManual(
      List<ServiceModel> listOfServices,
      UserModel userModel,
      int appointmentNo,
      String totalPrice,
      String subtatal,
      String platformFees,
      String payment,
      String serviceDuration,
      String serviceDate,
      String serviceStartTime,
      String serviceEndTime,
      String userNote,
      SalonModel? salonModel,
      BuildContext context) async {
    try {
      String? adminUid = _auth.currentUser?.uid;
      final List<TimeDateModel> timeDateList = [];

      if (listOfServices == null) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Dismiss any loading dialog
        showMessage("Error: User Service is not available.");
        return false;
      }
      if (userModel == null) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Dismiss any loading dialog
        showMessage("Error: User Model is not available.");
        return false;
      }

      if (salonModel == null) {
        Navigator.of(context, rootNavigator: true)
            .pop(); // Dismiss any loading dialog
        showMessage("Error: Salon information is not available.");
        return false;
      }

      DocumentReference documentReference = _firebaseFirestore
          .collection("UserOrder")
          .doc(adminUid)
          .collection('order')
          .doc();

      //Add TimeDate list
      TimeDateModel timeDateModel = TimeDateModel(
          id: documentReference.id,
          date: GlobalVariable.getCurrentDate(),
          time: GlobalVariable.getCurrentTime(),
          updateBy: "Vender");
      timeDateList.add(timeDateModel);

      documentReference.set({
        "orderId": documentReference.id,
        "appointmentNo": appointmentNo,
        "salonModel": salonModel.toJson(), // Convert SalonModel to JSON
        "userModel": userModel.toJson(), // Convert SalonModel to JSON
        "services": listOfServices.map((e) => e.toJson()).toList(),
        "status": "Pending",
        "totalPrice": totalPrice,
        "platformFees": platformFees,
        "subtatal": subtatal,
        "payment": payment,
        "serviceDuration": serviceDuration,
        "serviceDate": serviceDate,
        "serviceStartTime": serviceStartTime,
        "serviceEndTime": serviceEndTime,
        "userNote": userNote,

        "timeDateList": timeDateList.map((e) => e.toJson()).toList(),
        "isUpdate": false,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

// Get salon information
  Future<SalonModel?> getSalonInformationOrderFB(
    String adminId,
    String vendorId,
  ) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("admins")
              .doc(adminId)
              .collection('salon')
              .doc(vendorId)
              .get();
      return SalonModel.fromJson(querySnapshot.data()!, querySnapshot.id);
    } catch (e) {
      showMessage('Error fetching vender: $e');
    }
    return null;
  }

  //Get User by Order userId infor
  Future<UserModel> getUserInforOrderFB(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseFirestore.collection('users').doc(userId).get();
    return UserModel.fromJson(querySnapshot.data()!);
  }

  //Save of setting to Firebase
  Future<SettingModel> saveSettingToFB(String salonId, String diffbtwTimetap,
      int dayForBooking, bool isUpdate, BuildContext context) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      DocumentReference reference = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("setting")
          .doc();

      SettingModel settingModel = SettingModel(
          id: reference.id,
          salonId: salonId,
          diffbtwTimetap: diffbtwTimetap,
          isUpdate: isUpdate,
          dayForBooking: dayForBooking);

      await reference.set(settingModel.toJson());
      showMessage("Setting save Successfully ");
      return settingModel;
    } catch (e) {
      print("Error save the Setting ${e.toString()}");
      showMessage("Error save the Setting ${e.toString()}");
      rethrow; // Ensure the error is still thrown
    }
  }

  // Fetch the setting from Firebase
  Future<SettingModel?> fetchSettingFromFB(String salonId) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      // Reference to the collection where the setting is stored
      CollectionReference settingCollection = _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("setting");

      // Get the first document (since there's only one document)
      QuerySnapshot querySnapshot = await settingCollection.limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the first document snapshot
        DocumentSnapshot docSnapshot = querySnapshot.docs.first;

        // Convert the document to a SettingModel
        SettingModel settingModel =
            SettingModel.fromJson(docSnapshot.data() as Map<String, dynamic>);

        return settingModel;
      } else {
        print("No setting found for the given salonId.");
        return null; // No setting found
      }
    } catch (e) {
      print("Error fetching the setting: ${e.toString()}");
      showMessage("Error fetching the setting");
      rethrow; // Ensure the error is still thrown
    }
  }

  // Update the setting from Firebase

  Future<bool> updateSettingFB(
      SettingModel settingModel, String salonId, String settingId) async {
    try {
      String? adminUid = FirebaseAuth.instance.currentUser?.uid;

      await _firebaseFirestore
          .collection("admins")
          .doc(adminUid)
          .collection("salon")
          .doc(salonId)
          .collection("setting")
          .doc(settingId)
          .update(settingModel.toJson());
      showMessage("Setting update Successfully ");
      return true;
    } catch (e) {
      print("Error update the setting: ${e.toString()}");
      showMessage("Error update the setting");
      rethrow;
    }
  }

  //Fatch only appointment date
  Future<List<SaveDateModel>> getAppointmentDate(
    String adminId,
    String salonId,
  ) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firebaseFirestore
              .collection("admins")
              .doc(adminId)
              .collection("salon")
              .doc(salonId)
              .collection("appointment_Date")
              .get();
      List<SaveDateModel> listDate = querySnapshot.docs
          .map((e) => SaveDateModel.fromJson(e.data()))
          .toList();
      return listDate;
    } on Exception catch (e) {
      print("Error : date are not fatch $e");
      rethrow;
    }
  }
}
