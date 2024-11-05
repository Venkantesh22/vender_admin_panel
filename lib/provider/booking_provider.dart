import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/user_order/user_order_model.dart';

class BookingProvider with ChangeNotifier {
  final UserBookingFB _userBookingFB = UserBookingFB.instance;

  String _serviceBookingDuration = "0h 0m";
  List<OrderModel> _bookinglist = [];
  List<ServiceModel> _watchList = [];
  double _subTotal = 0.0;
  double _finalTotal = 0.0;

  List<ServiceModel> get getWatchList => _watchList;
  List<OrderModel> get getBookingList => _bookinglist;
  String get getServiceBookingDuration => _serviceBookingDuration;

  double get getSubTotal => _subTotal;
  double get getfinalTotal => _finalTotal;

  //! User Appointment function
  // Add Services to watch List
  void addServiceToWatchList(ServiceModel serviceModel) {
    _watchList.add(serviceModel);
    notifyListeners();
  }

  // Remove Services from watch List
  void removeServiceToWatchList(ServiceModel serviceModel) {
    _watchList.remove(serviceModel);
    notifyListeners();
  }

  //! User Appointment function
  // Get booking list for a specific date from Firebase
  Future<void> getBookingListPro(DateTime date, String salonId) async {
    String _formattedDate =
        DateFormat('dd/MM/yyyy').format(date); // Format date correctly
    _bookinglist =
        await _userBookingFB.getUserBookingListFB(_formattedDate, salonId);
    print("Fetched data for date: $_formattedDate");
    notifyListeners();
  }

  // Update appointment
  Future<bool> updateAppointment(
      int index, String userId, appointmentId, OrderModel orderModel) async {
    try {
      await _userBookingFB.updateAppointmentFB(
          userId, appointmentId, orderModel);
      _bookinglist[index] = orderModel;
      return true;
    } catch (e) {
      showMessage("Error : Appointment is not update");
      print("Error : Appointment is not update");

      return false;
    }
  }

  // Calculate total time for all services in the watch list
  void calculateTotalBookingDuration() {
    double totalHours = 0;
    double totalMinutes = 0;

    for (var service in _watchList) {
      totalHours += service.hours;
      totalMinutes += service.minutes;
    }

    // Convert total minutes to hours and minutes
    totalHours += (totalMinutes / 60).floor();
    totalMinutes = totalMinutes % 60;

    // Update the serviceBookingDuration with formatted time
    _serviceBookingDuration = "${totalHours.floor()}h ${totalMinutes.toInt()}m";

    // Notify listeners about the change
    notifyListeners();
  }

  //SubTotal
  void calculateSubTotal() {
    _subTotal = _watchList.fold(0.0, (sum, item) => sum + item.price);
    print("subTotal :- $_subTotal");
    _finalTotal = _subTotal + 20;
    print("finalTotal :- $_finalTotal");
    notifyListeners();
  }

  // Convert TimeOfDay to a formatted string
  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final DateTime dateTime = DateTime(
        now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
    return DateFormat('HH:mm').format(dateTime);
  }

  // Parse formatted time string back to TimeOfDay safely
  TimeOfDay parseTimeOfDay(String timeString) {
    // Split the time string (e.g., "09:00") into hours and minutes
    final parts = timeString.split(":");
    if (parts.length != 2) {
      throw FormatException("Invalid time format");
    }

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // Ensure the values are valid for TimeOfDay
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
      throw FormatException("Invalid time values");
    }

    return TimeOfDay(hour: hour, minute: minute);
  }
}
