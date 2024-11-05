import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/salon_setting_model/salon_setting_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class VerderSetting extends StatefulWidget {
  const VerderSetting({super.key});

  @override
  State<VerderSetting> createState() => _VerderSettingState();
}

class _VerderSettingState extends State<VerderSetting> {
  TextEditingController timeController = TextEditingController();
  TextEditingController dayController = TextEditingController();

  bool _isLoading = false;
  SettingModel? _settingModel;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Fetch data here after dependencies are fully initialized
  //   getData();
  // }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    _settingModel = serviceProvider.getSettingModel;
    try {
      if (_settingModel!.isUpdate) {
        timeController.text = _settingModel!.diffbtwTimetap;
        dayController.text = _settingModel!.dayForBooking.toString();
      }
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    timeController.dispose();
    dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Setting ',
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
                      SizedBox(height: Dimensions.dimenisonNo10),
                      FormCustomTextField(
                        controller: timeController,
                        title:
                            "Enter the time difference in minutes between in-time taps?",
                        hintText: "Enter a Minute",
                        requiredField: false,
                      ),
                      SizedBox(height: Dimensions.dimenisonNo10),
                      FormCustomTextField(
                        controller: dayController,
                        title:
                            "Enter how many days before allowing for booking an appointment?",
                        hintText: "Enter a Day",
                        requiredField: false,
                      ),
                      SizedBox(height: Dimensions.dimenisonNo50),
                      CustomAuthButton(
                        text: "Save",
                        ontap: () async {
                          if (_settingModel!.isUpdate) {
                            ServiceProvider serviceProvider =
                                Provider.of<ServiceProvider>(context,
                                    listen: false);

                            String salonId = appProvider.getSalonInformation.id;
                            bool isVaildated = minValidation(
                              timeController.text,
                              dayController.text,
                            );
                            SettingModel settingUpdate =
                                serviceProvider.getSettingModel!.copyWith(
                              diffbtwTimetap: timeController.text.trim(),
                              dayForBooking:
                                  int.parse(dayController.text.trim()),
                            );
                            // if (isVaildated) {
                            UserBookingFB.instance.updateSettingFB(
                                settingUpdate,
                                salonId,
                                serviceProvider.getSettingModel!.id);
                            // }
                          } else {
                            String salonId = appProvider.getSalonInformation.id;
                            bool isVaildated = minValidation(
                              timeController.text,
                              dayController.text,
                            );

                            if (isVaildated) {
                              await UserBookingFB.instance.saveSettingToFB(
                                  salonId,
                                  timeController.text.trim(),
                                  int.parse(dayController.text.trim()),
                                  true,
                                  context);
                            }
                            // ignore: use_build_context_synchronously
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
