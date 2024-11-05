import 'package:flutter/cupertino.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';

class InitializeDefaultCategory {
  static InitializeDefaultCategory instance = InitializeDefaultCategory();

  void createDefaultCategory(BuildContext context,
      ServiceProvider serviceProvider, AppProvider appProvider) {
    serviceProvider.initializeCategory(
        "Hair Cut", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Beard", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Threading", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Hari Wash", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Head Massage", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Hair Styling", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Hair Spa", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Hair Color", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Hair Texture", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Facial", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Bleach", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Clean Up", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Waxing", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "D Tan", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Pedicure", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Manicure", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Massage", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Body Polish", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Nail", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Makeup", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Bridal Package", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Party Makeup", appProvider.getSalonInformation.id, context);
    serviceProvider.initializeCategory(
        "Other", appProvider.getSalonInformation.id, context);
  }
}
