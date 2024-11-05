import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/custom_chip.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/custom_button.dart';
import 'package:samay_admin_plan/widget/dotted_line.dart';

class SingleServiceTap extends StatefulWidget {
  final ServiceModel serviceModel;
  const SingleServiceTap({
    super.key,
    required this.serviceModel,
  });

  @override
  State<SingleServiceTap> createState() => _SingleServiceTapState();
}

class _SingleServiceTapState extends State<SingleServiceTap> {
  bool _isAdd = false;
  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
            left: Dimensions.dimenisonNo16,
            right: Dimensions.dimenisonNo16,
            top: Dimensions.dimenisonNo10,
          ),
          padding: EdgeInsets.symmetric(
            vertical: Dimensions.dimenisonNo8,
            horizontal: Dimensions.dimenisonNo10,
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 1.5),
            borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.serviceModel.servicesName,
                        style: TextStyle(
                          color: AppColor.serviceTapTextColor,
                          fontSize: Dimensions.dimenisonNo16,
                          fontFamily: GoogleFonts.lato().fontFamily,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.dimenisonNo8),
                        child: Text(
                          'service code : ${widget.serviceModel.serviceCode}',
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
                  Spacer(),
                  CustomChip(text: widget.serviceModel.categoryName)
                ],
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: Dimensions.dimenisonNo8),
                child: const CustomDotttedLine(),
              ),

              Row(
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    size: Dimensions.dimenisonNo14,
                    color: Colors.black,
                  ),
                  widget.serviceModel.hours >= 1
                      ? Text(
                          ' ${widget.serviceModel.hours.toInt()}Hr :',
                          style: TextStyle(
                            color: AppColor.serviceTapTextColor,
                            fontSize: Dimensions.dimenisonNo12,
                            fontFamily: GoogleFonts.roboto().fontFamily,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        )
                      : const SizedBox(),
                  Text(
                    ' ${widget.serviceModel.minutes.toInt()}Min',
                    style: TextStyle(
                      color: AppColor.serviceTapTextColor,
                      fontSize: Dimensions.dimenisonNo12,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.currency_rupee_rounded,
                    size: Dimensions.dimenisonNo14,
                  ),
                  Text(
                    ' ${widget.serviceModel.price}',
                    style: TextStyle(
                      color: AppColor.serviceTapTextColor,
                      fontSize: Dimensions.dimenisonNo12,
                      fontFamily: GoogleFonts.roboto().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  CustomButtom(
                    buttonColor: bookingProvider.getWatchList
                            .contains(widget.serviceModel)
                        ? Colors.red
                        : AppColor.buttonColor,
                    ontap: () {
                      setState(() {
                        _isAdd = !_isAdd;
                      });
                      bookingProvider.getWatchList.contains(widget.serviceModel)
                          // _isAdd
                          ? setState(() {
                              bookingProvider.removeServiceToWatchList(
                                  widget.serviceModel);
                              bookingProvider.calculateTotalBookingDuration();
                              bookingProvider.calculateSubTotal();

                              print(
                                  "watch  lIst  remove ${bookingProvider.getWatchList.length}");
                            })
                          : setState(() {
                              bookingProvider
                                  .addServiceToWatchList(widget.serviceModel);
                              bookingProvider.calculateTotalBookingDuration();
                              bookingProvider.calculateSubTotal();
                              print(
                                  "watch  lIst add ${bookingProvider.getWatchList.length}");
                            });
                    },
                    text: bookingProvider.getWatchList
                            .contains(widget.serviceModel)
                        ? "Remove -"
                        : "Add+",
                  ),
                ],
              ),
              SizedBox(height: Dimensions.dimenisonNo10),
              Text(
                widget.serviceModel.description,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo12,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  // fontWeight: FontWeight.w500,
                  letterSpacing: 1,
                ),
              ),
              // SizedBox(height: Dimensions.dimenisonNo16),
            ],
          ),
        )
      ],
    );
  }
}
