// Placeholder for the "Support" page
import 'package:flutter/material.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    'Contact Us',
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
                  child: const Divider(),
                ),
                Text(
                  'Contact Us : ${GlobalVariable.customerNo}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(
                  height: Dimensions.dimenisonNo12,
                ),
                Text(
                  'Email ID :  ${GlobalVariable.customerGmail}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w500,
                    height: 0,
                    letterSpacing: 0.15,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
