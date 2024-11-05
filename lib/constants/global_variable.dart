import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalVariable {
  static TimeOfDay OpenTime = TimeOfDay(hour: 6, minute: 0);
  static TimeOfDay CloseTime = TimeOfDay(hour: 21, minute: 0);
  static TimeOfDay openTimeGlo = TimeOfDay(hour: 6, minute: 0);
  static TimeOfDay closerTimeGlo = TimeOfDay(hour: 6, minute: 0);
  static String salonID = '';

  static const String salon = "Salon";

// variable for increment appointment no.
  static String samayCollectionId = '6fa4GusAyAIkcAuBkYlu';
  static String salonCollectionId = 'j5bzQoxDswYJdSLQI3Lw';
  static int appointmentNO = 0;

  static String customerNo = "7972391849";
  static String customerGmail = "helpquickjet@gmail.com";

  // Function to get current date and time in a formatted string
  static String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('MMM dd yyyy').format(now);
  }

  static String getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('hh:mm a').format(now); // HH:mm a (e.g. 03:45 PM)
  }

  //Samay Admin plain
  static int salonPlatformFee = 20;
}
