// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class EditServicePage extends StatefulWidget {
  final int index;
  final ServiceModel serviceModel;
  final CategoryModel categoryModel;
  const EditServicePage({
    Key? key,
    required this.index,
    required this.serviceModel,
    required this.categoryModel,
  }) : super(key: key);

  @override
  State<EditServicePage> createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  @override
  Widget build(BuildContext context) {
    // AppProvider appProvider = Provider.of<AppProvider>(context);
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final TextEditingController _serviceController =
        TextEditingController(text: widget.serviceModel.servicesName);
    final TextEditingController _serviceCodeController =
        TextEditingController(text: widget.serviceModel.serviceCode);
    final TextEditingController _priceController =
        TextEditingController(text: widget.serviceModel.price.toString());
    final TextEditingController _hoursController =
        TextEditingController(text: widget.serviceModel.hours.toString());
    final TextEditingController _minController =
        TextEditingController(text: widget.serviceModel.minutes.toString());
    final TextEditingController _descriptionController =
        TextEditingController(text: widget.serviceModel.description);
    return Scaffold(
      backgroundColor: AppColor.bgForAdminCreateSec,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          // color: Colors.grey,
          color: AppColor.bgForAdminCreateSec,
          child: Container(
            alignment: Alignment.topLeft,
            width: Dimensions.screenWidth / 1.5,
            // margin: EdgeInsets.only(top: Dimensions.dimenisonNo30),
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.dimenisonNo30,
                vertical: Dimensions.dimenisonNo30),
            decoration: const BoxDecoration(
              // color: Colors.green,
              color: Colors.white,
              // borderRadius: BorderRadius.circular(Dimensions.dimenisonNo20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Update ${widget.serviceModel.servicesName} Service ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo24,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close)),
                  ],
                ),
                const Divider(),
                SizedBox(
                  height: Dimensions.dimenisonNo20,
                ),
                FormCustomTextField(
                    controller: _serviceController, title: "Service name"),
                SizedBox(
                  height: Dimensions.dimenisonNo20,
                ),
                FormCustomTextField(
                    controller: _serviceCodeController, title: "Service Code"),
                SizedBox(
                  height: Dimensions.dimenisonNo10,
                ),
                FormCustomTextField(
                    controller: _priceController, title: "Service price"),
                SizedBox(
                  height: Dimensions.dimenisonNo10,
                ),
                Text(
                  'Time duration',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo18,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Dimensions.dimenisonNo10,
                    ),
                    Text(
                      'Timing',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo18,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.15,
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.dimenisonNo10,
                    ),
                    SizedBox(
                      height: Dimensions.dimenisonNo30,
                      width: Dimensions.dimenisonNo50,
                      child: TextFormField(
                        cursorHeight: Dimensions.dimenisonNo16,
                        style: TextStyle(
                            fontSize: Dimensions.dimenisonNo12,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        controller: _hoursController,
                        decoration: InputDecoration(
                          hintText: " HH ",
                          hintStyle: TextStyle(
                            fontSize: Dimensions.dimenisonNo12,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: Dimensions.dimenisonNo10,
                              vertical: Dimensions.dimenisonNo10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.dimenisonNo16),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo10),
                      child: Text(
                        ':',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo20,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.dimenisonNo30,
                      width: Dimensions.dimenisonNo50,
                      child: TextFormField(
                        cursorHeight: Dimensions.dimenisonNo16,
                        style: TextStyle(
                            fontSize: Dimensions.dimenisonNo12,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        controller: _minController,
                        decoration: InputDecoration(
                          hintText: " MM ",
                          hintStyle: TextStyle(
                            fontSize: Dimensions.dimenisonNo12,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.bold,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: Dimensions.dimenisonNo10,
                              vertical: Dimensions.dimenisonNo10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Dimensions.dimenisonNo16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dimensions.dimenisonNo10,
                ),
                FormCustomTextField(
                    maxline: 6,
                    controller: _descriptionController,
                    title: "Service Description"),
                SizedBox(
                  height: Dimensions.dimenisonNo10,
                ),
                CustomAuthButton(
                  text: "Save",
                  ontap: () async {
                    try {
                      showLoaderDialog(context);
                      bool isVaildated = addNewServiceVaildation(
                          _serviceController.text.trim(),
                          _serviceCodeController.text.trim(),
                          _priceController.text.trim(),
                          _hoursController.text.trim(),
                          _minController.text.trim(),
                          _descriptionController.text.trim());

                      if (isVaildated) {
                        ServiceModel serviceModel =
                            widget.serviceModel.copyWith(
                          servicesName: _serviceController.text.trim(),
                          serviceCode: _serviceCodeController.text.trim(),
                          price: double.parse(_priceController.text.trim()),
                          hours: double.parse(_hoursController.text.trim()),
                          minutes: double.parse(_minController.text.trim()),
                          description: _descriptionController.text.trim(),
                        );

                        serviceProvider.updateSingleServicePro(
                            widget.index, serviceModel);
                      }
                      Navigator.of(context, rootNavigator: true).pop();
                      Navigator.of(context).pop();

                      showMessage(
                          "Successfully updated ${widget.serviceModel.servicesName} service");
                    } catch (e) {
                      showMessage("Error not updated  service");
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
