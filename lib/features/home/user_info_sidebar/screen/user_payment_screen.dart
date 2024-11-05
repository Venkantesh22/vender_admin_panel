import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/price_text.dart';
import 'package:samay_admin_plan/models/user_order/user_order_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class UserSideBarPaymentScreen extends StatelessWidget {
  final OrderModel orderModel;
  const UserSideBarPaymentScreen({Key? key, required this.orderModel, u})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final double subtotal = orderModel.totalPrice - 20;

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Container(
          color: AppColor.whileColor,
          padding: EdgeInsets.symmetric(
              horizontal: Dimensions.dimenisonNo16,
              vertical: Dimensions.dimenisonNo10),
          width: Dimensions.screenWidth / 1.5,
          child: Column(
            children: [
              Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Details',
                    style: TextStyle(
                      fontSize: Dimensions.dimenisonNo20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: Dimensions.dimenisonNo5),
                  CustomText(
                    firstText: "Payment Method:",
                    lastText: orderModel.payment,
                    // lastText: "Pay at Place",
                  ),
                  SizedBox(height: Dimensions.dimenisonNo5),
                  // CustomText(
                  //   firstText: "Subtotal:",
                  //   lastText: subtotal.toString(),
                  //   // lastText: '2222',
                  //   showicon: true,
                  // ),
                  SizedBox(height: Dimensions.dimenisonNo5),
                  const Divider(),
                  CustomText(
                    firstText: "Total:",
                    lastText: orderModel.totalPrice.toString(),
                    // lastText: '2222',
                    showicon: true,
                  ),
                  SizedBox(height: Dimensions.dimenisonNo20),
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment Options',
                      style: TextStyle(
                        fontSize: Dimensions.dimenisonNo20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: Dimensions.dimenisonNo12),
                    Container(
                      // height: Dimensions.dimenisonNo55,
                      padding: EdgeInsets.all(Dimensions.dimenisonNo8),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(Dimensions.dimenisonNo12),
                        border: Border.all(width: 1.6, color: Colors.black),
                      ),
                      child: ExpansionTile(
                        title: Text(
                          'Cash',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo16,
                            fontFamily: GoogleFonts.inter().fontFamily,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Icon(Icons.payment),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.dimenisonNo12,
                    ),
                    Text(
                      "Note:- Online Payment will come soon now only cash Payment is available",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: Dimensions.dimenisonNo12),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
