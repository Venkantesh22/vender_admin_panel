import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose

    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      body: Container(
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
              children: [
                Center(
                  child: Text(
                    'Forget Password',
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
                  padding:
                      EdgeInsets.symmetric(vertical: Dimensions.dimenisonNo10),
                  child: Divider(),
                ),
                Text(
                  'Enter your registered email address',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo18,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(height: Dimensions.dimenisonNo10),
                FormCustomTextField(
                  controller: _emailController,
                  title: "Email",
                ),
                SizedBox(height: Dimensions.dimenisonNo10),
                CustomAuthButton(
                  text: "Send Email",
                  ontap: () async {
                    String userEmail = appProvider.getAdminInformation.email;
                    bool isVaildated = emailVaildation(
                      _emailController.text,
                    );

                    if (isVaildated) {
                      if (userEmail == _emailController.text.trim()) {
                        FirebaseAuthHelper.instance
                            .resetPassword(_emailController.text.trim());
                      } else {
                        showMessage(" Invalid email.");
                      }
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
