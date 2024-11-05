import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';

import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/service%20view/screen/edit_service_page.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class SingleServiceTap extends StatelessWidget {
  final ServiceModel serviceModel;
  final CategoryModel categoryModel;
  final int index;
  const SingleServiceTap({
    Key? key,
    required this.serviceModel,
    required this.categoryModel,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    return Container(
      width: 500,
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo10,
          vertical: Dimensions.dimenisonNo10),
      //  Single Services Container
      child: Container(
        margin: EdgeInsets.only(right: Dimensions.dimenisonNo200),
        padding: EdgeInsets.only(
          left: Dimensions.dimenisonNo10,
          right: Dimensions.dimenisonNo10,
          top: Dimensions.dimenisonNo10,
        ),
        height: Dimensions.dimenisonNo200,
        decoration: ShapeDecoration(
          color: AppColor.bgForAdminCreateSec,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1),
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      serviceModel.servicesName,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: Dimensions.dimenisonNo20,
                        fontFamily: GoogleFonts.roboto().fontFamily,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.04,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: Dimensions.dimenisonNo10),
                      child: Text(
                        'service code : ${serviceModel.serviceCode}',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 124, 118, 118),
                          fontSize: Dimensions.dimenisonNo14,
                          fontFamily: GoogleFonts.roboto().fontFamily,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.dimenisonNo10,
                    )
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Routes.instance.push(
                        widget: EditServicePage(
                            index: index,
                            serviceModel: serviceModel,
                            categoryModel: categoryModel),
                        context: context);
                  },
                  icon: const Icon(
                    Icons.edit_square,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDeleteAlertDialog(context, "Delete Service",
                        "Do you want to delete ${serviceModel.servicesName} Service",
                        () {
                      try {
                        showLoaderDialog(context);
                        serviceProvider.deletelSingleServicePro(serviceModel);
                        Navigator.of(context, rootNavigator: true).pop();
                        Navigator.of(context, rootNavigator: true).pop();
                        showMessage(
                            "Successfully delete ${serviceModel.servicesName}");
                      } catch (e) {
                        Navigator.of(context, rootNavigator: true).pop();
                        showMessage(
                            "Error not delete ${serviceModel.servicesName}");
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            // subtitile
            Row(
              children: [
                Icon(
                  Icons.currency_rupee,
                  size: Dimensions.dimenisonNo16,
                ),
                Text(
                  serviceModel.price.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
                SizedBox(
                  width: Dimensions.dimenisonNo20,
                ),
                Icon(
                  Icons.watch_later_outlined,
                  size: Dimensions.dimenisonNo16,
                ),
                SizedBox(
                  width: Dimensions.dimenisonNo10,
                ),
                Text(
                  "${serviceModel.hours.toString()}:${serviceModel.minutes.toString()} hr.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: Dimensions.dimenisonNo16,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.15,
                  ),
                ),
                Text(index.toString())
              ],
            ),
            Divider(),
            Expanded(
              child: Text(
                serviceModel.description,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo16,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
