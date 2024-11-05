import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/constants/custom_chip.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class SingleServiceOrderList extends StatelessWidget {
  final ServiceModel serviceModel;

  const SingleServiceOrderList({
    Key? key,
    required this.serviceModel,
  }) : super(key: key);

  // @override
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.dimenisonNo12),
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.dimenisonNo5,
          horizontal: Dimensions.dimenisonNo12),
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.dimenisonNo12),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '▪️ ${serviceModel.servicesName}',
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo14,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.dimenisonNo8),
                      child: Text(
                        'service code : ${serviceModel.serviceCode}',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: Dimensions.dimenisonNo10,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                CustomChip(
                  text: serviceModel.categoryName,
                )
              ],
            ),
          ),
          const Divider(),
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.dimenisonNo5,
                  ),
                  Row(
                    children: [
                      Text(
                        "During : ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      serviceModel.hours >= 1
                          ? Text(
                              ' ${serviceModel.hours.toInt()}Hr :',
                              style: TextStyle(
                                color: AppColor.serviceTapTextColor,
                                fontSize: Dimensions.dimenisonNo12,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            )
                          : SizedBox(),
                      Text(
                        "${serviceModel.minutes.toInt()}Min",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dimensions.dimenisonNo5,
                  ),
                  Row(
                    children: [
                      Text(
                        'Total Amount :  ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                      Icon(
                        Icons.currency_rupee_outlined,
                        size: Dimensions.dimenisonNo12,
                      ),
                      Text(
                        serviceModel.price.toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo12,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // const Spacer(),
              // IconButton(
              //   onPressed: () {
              //     try {
              //       // showLoaderDialog(context);
              //       // appProvider.removeServiceToWatchList(serviceModel);
              //       // appProvider.calculateSubTotal();
              //       // appProvider.calculateTotalBookingDuration();

              //       // Navigator.of(context, rootNavigator: true).pop();

              //       showMessage('Service is removed from Watch List');
              //     } catch (e) {
              //       showMessage(
              //           'Error occurred while removing service from Watch List: ${e.toString()}');
              //     }
              //   },
              //   icon: Icon(
              //     Icons.delete,
              //     color: Colors.red,
              //     size: Dimensions.dimenisonNo30,
              //   ),
              // ),
              // SizedBox(
              //   width: Dimensions.dimenisonNo20,
              // )
            ],
          ),
        ],
      ),
    );
  }
}
