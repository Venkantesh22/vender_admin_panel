import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/models/save_date/save_appointment_date.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';

class ServiceProvider extends ChangeNotifier {
  List<CategoryModel> _categoryList = [];
  List<ServiceModel> _servicesList = [];
  CategoryModel? _selectedCategory;
  CategoryModel? _category;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<CategoryModel> get getCategoryList => _categoryList;
  List<ServiceModel> get getserviceList => _servicesList;
  CategoryModel? get selectedCategory => _selectedCategory;
  CategoryModel? get getCategory => _category;

  SettingModel? _settingModel;
  SettingModel? get getSettingModel => _settingModel;

  SaveDateModel? _saveDateModel;
  SaveDateModel? get getSaveDateModel => _saveDateModel;
  List<SaveDateModel> appointDate = [];

// Fatch Appointment date
  Future<void> fetchAppointmentDatePro(String adminId, String salonId) async {
    appointDate =
        await UserBookingFB.instance.getAppointmentDate(adminId, salonId);
    notifyListeners();
  }

//Fatch Setting for Firebase
  Future<void> fetchSettingPro(String salonId) async {
    _settingModel = await UserBookingFB.instance.fetchSettingFromFB(salonId);
    notifyListeners();
  }

//Function to fatch CategoryList
  Future<void> getCategoryListPro(String salonId) async {
    _categoryList =
        await FirebaseFirestoreHelper.instance.getCategoryListFirebase(salonId);
    notifyListeners();
  }

  // Create Default categories.
  Future<CategoryModel?> initializeCategory(
    String categoryName,
    String salonId,
    BuildContext context,
  ) async {
    CategoryModel categoryModel = await FirebaseFirestoreHelper.instance
        .initializeCategoryCollection(categoryName, salonId, context);
    _categoryList.add(categoryModel);
    print("Length is  ${_categoryList.length}");
    notifyListeners();
    return categoryModel;
  }

//Function to create new category to List
  void addNewCategoryPro(
    String adminId,
    String salonId,
    String categoryName,
    BuildContext context,
  ) async {
    CategoryModel categoryModel = await FirebaseFirestoreHelper.instance
        .addNewCategoryFirebase(adminId, categoryName, salonId, context);
    _categoryList.add(categoryModel);
    notifyListeners();
  }

  //Function to fatch services
  Stream<List<ServiceModel>> getServicesListFirebase(
    String salonId,
    String categoryId,
  ) {
    return FirebaseFirestore.instance
        .collection("admins")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('salon')
        .doc(salonId)
        .collection("category")
        .doc(categoryId)
        .collection("service")
        .snapshots()
        .map((snapshots) => snapshots.docs
            .map((doc) => ServiceModel.fromJson(doc.data()))
            .toList());
  }

  // Update a Single Services
  void updateSingleServicePro(int index, ServiceModel serviceModel) async {
    await FirebaseFirestoreHelper.instance
        .updateSingleServiceFirebae(serviceModel);
    _servicesList[index] = serviceModel;
  }

//Delete Single Services
  Future<void> deletelSingleServicePro(ServiceModel serviceModel) async {
    bool val = await FirebaseFirestoreHelper.instance
        .deleteServiceFirebase(serviceModel);
    if (val) {
      _servicesList.remove(serviceModel);
    }
  }

  Future<void> callBackFunction(String salonId) async {
    await getCategoryListPro(salonId);
    getServicesListFirebase;
    notifyListeners();
  }

  //! Category Function

  void selectCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Update a single Category
  void updateSingleCategoryPro(CategoryModel categoryModel) async {
    await FirebaseFirestoreHelper.instance
        .updateSingleCategoryFirebase(categoryModel);
    var isRemove = _categoryList.remove(categoryModel);
    if (isRemove) {
      _categoryList.add(categoryModel);
    }
    notifyListeners();
  }

//Delete singleCategory
  Future<void> deleteSingleCategoryPro(CategoryModel categoryModel) async {
    bool val = await FirebaseFirestoreHelper.instance
        .deleteSingleCategoryFb(categoryModel);
    if (val) {
      _categoryList.remove(categoryModel);
    }
    notifyListeners();
  }

  // Add new services .
  void addSingleServicePro(
    String adminId,
    String salonId,
    String categoryId,
    String categoryName,
    String servicesName,
    String serviceCode,
    double price,
    double hours,
    double min,
    String description,
  ) async {
    ServiceModel serviceModel =
        await FirebaseFirestoreHelper.instance.addServiceFirebase(
      adminId,
      salonId,
      categoryId,
      categoryName,
      servicesName,
      serviceCode,
      price,
      hours,
      min,
      description,
    );
    _servicesList.add(serviceModel);
    notifyListeners();
  }
}
