// ignore_for_file: prefer_const_constructors, unrelated_type_equality_checks

import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/widget/account_time_section.dart';
import 'package:samay_admin_plan/features/home/main_home/home_screen.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class SalonProfilePage extends StatefulWidget {
  const SalonProfilePage({super.key});

  @override
  State<SalonProfilePage> createState() => _SalonProfilePageState();
}

class _SalonProfilePageState extends State<SalonProfilePage> {
  final TextEditingController _salonName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _mobile = TextEditingController();
  final TextEditingController _whatApp = TextEditingController();
  final TextEditingController _descrition = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  final TextEditingController _openTime = TextEditingController();
  final TextEditingController _closeTime = TextEditingController();

  String? adminUid = FirebaseAuth.instance.currentUser?.uid;
  late TimeOfDay openTimeAfterTime;
  late TimeOfDay closeTimeAfterTime;

  bool _isLoading = false;
  bool isupdate = false;
  bool isImageChange = false;

  //! For DropDownList
  String? _selectedSalonType;
  final List<String> _salonTypeOptions = [
    'Unisex',
    'Only Male',
    'Only Female',
  ];

  Uint8List? selectedImage;

  chooseImages() async {
    FilePickerResult? chosenImageFile =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (chosenImageFile != null) {
      setState(() {
        selectedImage = chosenImageFile.files.single.bytes;
      });
    }
    isImageChange = true;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    try {
      _selectedSalonType = appProvider.getSalonInformation.salonType;
      _salonName.text = appProvider.getSalonInformation.name;
      _email.text = appProvider.getSalonInformation.email;
      _mobile.text = appProvider.getSalonInformation.number.toString();
      _whatApp.text = appProvider.getSalonInformation.whatApp.toString();
      _descrition.text = appProvider.getSalonInformation.description;
      _address.text = appProvider.getSalonInformation.address;
      _city.text = appProvider.getSalonInformation.city;
      _state.text = appProvider.getSalonInformation.state;
      _pincode.text = appProvider.getSalonInformation.pinCode;
      _openTime.text = appProvider.getSalonInformation.openTime as String;
      _closeTime.text = appProvider.getSalonInformation.closeTime as String;
      // _instagram.text = appProvider.getSalonInformation.instagram!;
      // _facebook.text = appProvider.getSalonInformation.facebook!;
      // _googleMap.text = appProvider.getSalonInformation.googleMap!;
      // _linked.text = appProvider.getSalonInformation.linked!;

      openTimeAfterTime = stringToTimeOfDay(_openTime.text);
      closeTimeAfterTime = stringToTimeOfDay(_closeTime.text);
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  TimeOfDay stringToTimeOfDay(String timeString) {
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1].toUpperCase() == 'PM';

    if (isPM && hour != 12) {
      return TimeOfDay(hour: hour + 12, minute: minute);
    } else if (!isPM && hour == 12) {
      return TimeOfDay(hour: 0, minute: minute);
    } else {
      return TimeOfDay(hour: hour, minute: minute);
    }
  }

  @override
  void dispose() {
    _salonName.dispose();
    _email.dispose();
    _mobile.dispose();
    _whatApp.dispose();
    _descrition.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _pincode.dispose();
    _openTime.dispose();
    _closeTime.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: _isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                // color: Colors.grey,
                color: AppColor.bgForAdminCreateSec,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.dimenisonNo30,
                        vertical: Dimensions.dimenisonNo20),
                    // color: Colors.green,
                    color: Colors.white,
                    width: Dimensions.screenWidth / 1.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Saloon Profile Details',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: Dimensions.dimenisonNo36,
                              fontWeight: FontWeight.w500,
                              height: 0,
                              letterSpacing: 0.15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: Dimensions.dimenisonNo10),
                          child: Divider(),
                        ),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Upload ${GlobalVariable.salon} Images ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimenisonNo18,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: const Color(0xFFFC0000),
                                  fontSize: Dimensions.dimenisonNo18,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: 0.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        selectedImage == null
                            ? InkWell(
                                onTap: chooseImages,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.dimenisonNo20)),
                                  width: Dimensions.dimenisonNo300,
                                  height: Dimensions.dimenisonNo200,
                                  clipBehavior: Clip.antiAlias,
                                  child:
                                      appProvider.getSalonInformation.image !=
                                              null
                                          ? Image.network(
                                              appProvider
                                                  .getSalonInformation.image!,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.image,
                                              size: Dimensions.dimenisonNo200,
                                            ),
                                ),
                              )
                            : InkWell(
                                onTap: chooseImages,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: Dimensions.dimenisonNo20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.dimenisonNo20)),
                                  width: Dimensions.dimenisonNo300,
                                  height: Dimensions.dimenisonNo200,
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.memory(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _salonName,
                          title: "${GlobalVariable.salon} Name",
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _email,
                          title: "Email ID",
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _mobile,
                          title: "Mobile No",
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _whatApp,
                          title: "WhatApp No",
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${GlobalVariable.salon} Type ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Dimensions.dimenisonNo18,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.15,
                                ),
                              ),
                              TextSpan(
                                text: '*',
                                style: TextStyle(
                                  color: const Color(0xFFFC0000),
                                  fontSize: Dimensions.dimenisonNo18,
                                  fontFamily: GoogleFonts.roboto().fontFamily,
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                  letterSpacing: 0.15,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: Dimensions.dimenisonNo5),
                        DropdownButtonFormField<String>(
                          hint: Text(
                            'Select ${GlobalVariable.salon} Type',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: Dimensions.dimenisonNo16,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.40,
                            ),
                          ),
                          value: _selectedSalonType,
                          items: _salonTypeOptions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSalonType = newValue;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a ${GlobalVariable.salon} type';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _descrition,
                          title: "${GlobalVariable.salon} Description",
                          maxline: 5,
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        TimingSection(appProvider, context),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        FormCustomTextField(
                          controller: _address,
                          title: "Address",
                          maxline: 2,
                        ),
                        SizedBox(height: Dimensions.dimenisonNo20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: Dimensions.dimenisonNo200,
                                child: FormCustomTextField(
                                    controller: _city, title: "City")),
                            SizedBox(
                                width: Dimensions.dimenisonNo200,
                                child: FormCustomTextField(
                                    controller: _state, title: "State")),
                            SizedBox(
                              width: Dimensions.dimenisonNo200,
                              child: FormCustomTextField(
                                  controller: _pincode, title: "Pincode"),
                            ),
                          ],
                        ),
                        // SizedBox(height: Dimensions.dimenisonNo20),
                        // Text(
                        //   'Social media Information',
                        //   style: TextStyle(
                        //     color: Colors.black,
                        //     fontSize: Dimensions.dimenisonNo16,
                        //     fontWeight: FontWeight.w500,
                        //     fontFamily: GoogleFonts.roboto().fontFamily,
                        //     letterSpacing: 0.15,
                        //   ),
                        // ),
                        // SizedBox(height: Dimensions.dimenisonNo10),
                        // Column(
                        //   children: [
                        //     SalonSocialMediaAdd(
                        //       text: appProvider.getSalonInformation.instagram!,
                        //       icon: FontAwesomeIcons.instagram,
                        //       controller: _instagram,
                        //       isUpdate: true,
                        //     ),
                        //     SalonSocialMediaAdd(
                        //       text: appProvider.getSalonInformation.facebook!,
                        //       icon: FontAwesomeIcons.facebook,
                        //       controller: _facebook,
                        //       isUpdate: true,
                        //     ),
                        //     SalonSocialMediaAdd(
                        //       text: appProvider.getSalonInformation.googleMap!,
                        //       icon: FontAwesomeIcons.mapLocationDot,
                        //       controller: _googleMap,
                        //       isUpdate: true,
                        //     ),
                        //     SalonSocialMediaAdd(
                        //       text: appProvider.getSalonInformation.linked!,
                        //       icon: FontAwesomeIcons.linkedin,
                        //       controller: _linked,
                        //       isUpdate: true,
                        //     ),
                        //   ],
                        // ),
                        SizedBox(height: Dimensions.dimenisonNo20),
                        CustomAuthButton(
                          text: "Update",
                          ontap: () async {
                            try {
                              // if (_isVaildated) {
                              SalonModel salonModelUpdate =
                                  appProvider.getSalonInformation.copyWith(
                                name: _salonName.text.trim(),
                                email: _email.text.trim(),
                                number: int.parse(_mobile.text.trim()),
                                whatApp: int.parse(_whatApp.text.trim()),
                                salonType: _selectedSalonType!,
                                description: _descrition.text.trim(),
                                address: _address.text.trim(),
                                city: _city.text.trim(),
                                state: _state.text.trim(),
                                pinCode: _pincode.text.trim(),
                                openTime:
                                    _openTime == TimeOfDay(hour: 0, minute: 0)
                                        ? openTimeAfterTime
                                        : GlobalVariable.openTimeGlo,
                                closeTime:
                                    _closeTime == TimeOfDay(hour: 0, minute: 0)
                                        ? closeTimeAfterTime
                                        : GlobalVariable.closerTimeGlo,
                                // instagram: _instagram.text.isEmpty
                                //     ? appProvider.getSalonInformation.instagram
                                //     : _instagram.text.trim(),
                                // facebook: _facebook.text.isEmpty
                                //     ? appProvider.getSalonInformation.facebook
                                //     : _facebook.text.trim(),
                                // googleMap: _googleMap.text.isEmpty
                                //     ? appProvider.getSalonInformation.googleMap
                                //     : _googleMap.text.trim(),
                                // linked: _linked.text.isEmpty
                                //     ? appProvider.getSalonInformation.linked
                                //     : _linked.text.trim(),
                                monday: appProvider
                                            .getSalonInformation.monday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.monday
                                    : _openTime ==
                                                TimeOfDay(
                                                    hour: 00, minute: 00) &&
                                            _closeTime ==
                                                TimeOfDay(hour: 00, minute: 00)
                                        ? appProvider.getSalonInformation.monday
                                        : "${GlobalVariable.OpenTime.format(context).toString()} To ${GlobalVariable.CloseTime.format(context).toString()}",
                                tuesday: appProvider
                                            .getSalonInformation.tuesday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.tuesday
                                    : _openTime ==
                                                TimeOfDay(
                                                    hour: 00, minute: 00) &&
                                            _closeTime ==
                                                TimeOfDay(hour: 00, minute: 00)
                                        ? appProvider
                                            .getSalonInformation.tuesday
                                        : "${GlobalVariable.OpenTime.format(context).toString()} To ${GlobalVariable.CloseTime.format(context).toString()}",
                                wednesday: appProvider
                                            .getSalonInformation.wednesday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.monday
                                    : _openTime ==
                                                TimeOfDay(
                                                    hour: 00, minute: 00) &&
                                            _closeTime ==
                                                TimeOfDay(hour: 00, minute: 00)
                                        ? appProvider
                                            .getSalonInformation.wednesday
                                        : "${GlobalVariable.OpenTime.format(context).toString()} To ${GlobalVariable.CloseTime.format(context).toString()}",
                                thursday: appProvider
                                            .getSalonInformation.thursday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.thursday
                                    : _openTime ==
                                                TimeOfDay(
                                                    hour: 00, minute: 00) &&
                                            _closeTime ==
                                                TimeOfDay(hour: 00, minute: 00)
                                        ? appProvider
                                            .getSalonInformation.thursday
                                        : "${GlobalVariable.OpenTime.format(context).toString()} To ${GlobalVariable.CloseTime.format(context).toString()}",
                                friday: appProvider
                                            .getSalonInformation.friday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.friday
                                    : _openTime ==
                                                TimeOfDay(
                                                    hour: 00, minute: 00) &&
                                            _closeTime ==
                                                TimeOfDay(hour: 00, minute: 00)
                                        ? appProvider.getSalonInformation.friday
                                        : "${GlobalVariable.OpenTime.format(context).toString()} To ${GlobalVariable.CloseTime.format(context).toString()}",
                                saturday: appProvider
                                            .getSalonInformation.saturday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.saturday
                                    : _openTime ==
                                                TimeOfDay(
                                                    hour: 00, minute: 00) &&
                                            _closeTime ==
                                                TimeOfDay(hour: 00, minute: 00)
                                        ? appProvider
                                            .getSalonInformation.saturday
                                        : "${GlobalVariable.OpenTime.format(context).toString()} To ${GlobalVariable.CloseTime.format(context).toString()}",
                                sunday: appProvider
                                            .getSalonInformation.sunday ==
                                        'Close'
                                    ? appProvider.getSalonInformation.sunday
                                    : _openTime ==
                                                TimeOfDay(
                                                    hour: 00, minute: 00) &&
                                            _closeTime ==
                                                TimeOfDay(hour: 00, minute: 00)
                                        ? appProvider.getSalonInformation.sunday
                                        : "${GlobalVariable.OpenTime.format(context).toString()} To ${GlobalVariable.CloseTime.format(context).toString()}",
                              );

                              isImageChange
                                  ? isupdate =
                                      await appProvider.updateSalonInfoFirebase(
                                          context, salonModelUpdate,
                                          image: selectedImage)
                                  : isupdate =
                                      await appProvider.updateSalonInfoFirebase(
                                      context,
                                      salonModelUpdate,
                                    );

                              showMessage("Salon Update Successfully add");
                              print("Salon ID ${GlobalVariable.salonID}");

                              if (isupdate) {
                                Routes.instance.push(
                                    widget: const HomeScreen(),
                                    // ignore: use_build_context_synchronously
                                    context: context);
                              }
                              // }
                            } catch (e) {
                              print(e.toString());
                              showMessage(
                                  'Salon is not Update or an error occurred');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Row TimingSection(AppProvider appProvider, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        // "Select the timing of ${GlobalVariable.salon}",
                        "Timing of ${GlobalVariable.salon}",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: Dimensions.dimenisonNo18,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15,
                    ),
                  ),
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: const Color(0xFFFC0000),
                      fontSize: Dimensions.dimenisonNo18,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w500,
                      height: 0,
                      letterSpacing: 0.15,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.dimenisonNo5,
            ),
            Padding(
              padding: EdgeInsets.only(left: Dimensions.dimenisonNo16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Opening Time ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo16,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.dimenisonNo20),
                        child: Icon(
                          CupertinoIcons.stopwatch,
                          size: Dimensions.dimenisonNo16,
                        ),
                      ),
                      Center(
                        child: Text(
                          appProvider.getSalonInformation.openTime!
                              .format(context),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.dimenisonNo10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Closing Time  ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo16,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.15,
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.dimenisonNo22,
                      ),
                      Icon(
                        CupertinoIcons.stopwatch,
                        size: Dimensions.dimenisonNo16,
                      ),
                      SizedBox(
                        width: Dimensions.dimenisonNo20,
                      ),
                      Text(
                        appProvider.getSalonInformation.closeTime!
                            .format(context),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),

        //! select a time
        PickTimeSection(
          openController: _openTime,
          closeController: _closeTime,
          heading: "If you want to Change Timing update here",
        ),
      ],
    );
  }
}
