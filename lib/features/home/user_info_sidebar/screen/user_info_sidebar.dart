import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/edit_appointment/screen/edit_appointment.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/screen/user_payment_screen.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/infor.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/row_of_state.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/widget/service_tap_orderlist.dart';
import 'package:samay_admin_plan/features/home/widget/state_text.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/timestamped_model/date_time_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/widget/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/widget/custom_icon_button.dart';
import 'package:samay_admin_plan/models/user_order/user_order_model.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class UserInfoSideBar extends StatefulWidget {
  final OrderModel orderModel;
  final int index;

  const UserInfoSideBar({
    Key? key,
    required this.orderModel,
    required this.index,
  }) : super(key: key);

  @override
  State<UserInfoSideBar> createState() => _UserInfoSideBarState();
}

class _UserInfoSideBarState extends State<UserInfoSideBar> {
  bool isLoading = false;
  late UserModel userModel;
  late SalonModel salonModel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    userModel = await UserBookingFB.instance
        .getUserInforOrderFB(widget.orderModel.userId);
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    salonModel = appProvider.getSalonInformation;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    //function activate
    bool activateDeleteAndEditButton = false;
    if (widget.orderModel.status == "(Cancel)" ||
        widget.orderModel.status == "Completed") {
      activateDeleteAndEditButton = true;
    } else {
      activateDeleteAndEditButton = false;
    }
    // Method to launch the dialer with the phone number
    void _launchDialer(String phoneNumber) async {
      try {
        Uri dialNumber = Uri(scheme: "tel", path: phoneNumber);
        await launchUrl(dialNumber);
      } catch (e) {
        showMessage('Could not launch Mobile $e');
      }
    }

    // Method to open WhatsApp with the phone number
    Future<void> _openWhatsApp(String phoneNumber) async {
      try {
        final Uri whatsappUrl = Uri.parse('https://wa.me/$phoneNumber');
        await launchUrl(whatsappUrl);
      } catch (e) {
        showMessage('Could not launch WhatsApp $e');
      }
    }

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                    width: 2.0,
                    color: Colors.black,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: Dimensions.dimenisonNo16,
                      right: Dimensions.dimenisonNo16,
                      top: Dimensions.dimenisonNo18,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Appointment',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        widget.orderModel.status == "(Cancel)"
                            ? const SizedBox()
                            : widget.orderModel.isUpdate
                                ? const StateText(status: "(Update)")
                                : const SizedBox(),
                        if (widget.orderModel.status == "(Cancel)")
                          StateText(status: widget.orderModel.status),
                        const Spacer(),
                        Opacity(
                          opacity: activateDeleteAndEditButton ? 0.5 : 1.0,
                          // opacity: widget.orderModel.status == "(Cancel)" ? 0.5 : 1.0,
                          child: IgnorePointer(
                            ignoring: activateDeleteAndEditButton,
                            // ignoring: widget.orderModel.status == "(Cancel)",
                            child: IconButton(
                              onPressed: () {
                                // BookingProvider bookingProvider =
                                //     Provider.of<BookingProvider>(context,
                                //         listen: false);
                                // bookingProvider.getWatchList.clear();
                                // bookingProvider.getWatchList
                                //     .addAll(widget.orderModel.services);

                                activateDeleteAndEditButton
                                    ? showInforAlertDialog(
                                        context,
                                        "Appointments cannot be edited ",
                                        "Appointment is ${widget.orderModel.status} you cannot edited it",
                                      )
                                    : Routes.instance.push(
                                        widget: EditAppointment(
                                          index: widget.index,
                                          orderModer: widget.orderModel,
                                          userModel: userModel,
                                          salonModel: salonModel,
                                        ),
                                        context: context);
                              },
                              icon: const Icon(
                                Icons.edit_square,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: Dimensions.dimenisonNo5),
                        Opacity(
                          opacity: activateDeleteAndEditButton ? 0.5 : 1.0,
                          child: IgnorePointer(
                            ignoring: activateDeleteAndEditButton,
                            child: IconButton(
                              onPressed: () {
                                activateDeleteAndEditButton
                                    ? showInforAlertDialog(
                                        context,
                                        "Appointment cannot be cancelled ",
                                        "Appointment is ${widget.orderModel.status} you cannot cancel it",
                                      )
                                    : showDeleteAlertDialog(
                                        context,
                                        "Cancel Appointment",
                                        "Do you want Cancel Appointment", () {
                                        try {
                                          showLoaderDialog(context);
                                          //create emptye list of timeDateList and add currently time for update
                                          List<TimeDateModel> timeDateList = [];
                                          timeDateList.addAll(
                                              widget.orderModel.timeDateList);
                                          TimeDateModel timeDateModel =
                                              TimeDateModel(
                                                  id: widget.orderModel.orderId,
                                                  date: GlobalVariable
                                                      .getCurrentDate(),
                                                  time: GlobalVariable
                                                      .getCurrentTime(),
                                                  updateBy:
                                                      "${salonModel.name} (Cancel the Appointment)");
                                          timeDateList.add(timeDateModel);
                                          OrderModel orderUpdate =
                                              widget.orderModel.copyWith(
                                                  status: "(Cancel)",
                                                  timeDateList: timeDateList);
                                          BookingProvider bookingProvider =
                                              Provider.of<BookingProvider>(
                                                  context,
                                                  listen: false);

                                          bookingProvider.updateAppointment(
                                              widget.index,
                                              userModel.id,
                                              widget.orderModel.orderId,
                                              orderUpdate);
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          Navigator.of(context).pop();
                                          showMessage(
                                              "Appointment has been cancelled ");
                                        } catch (e) {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                          showMessage(
                                              "Error : Appointment is not cancelled ");
                                          print("Error : $e ");
                                        }
                                      });
                              },
                              icon: const Icon(
                                Icons.delete_forever_sharp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: Dimensions.dimenisonNo5),
                  RowOfStates(
                    index: widget.index,
                    orderModel: widget.orderModel,
                    salonModel: salonModel,
                    userModel: userModel,
                  ),
                  const Divider(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.dimenisonNo16,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.green[100],
                          backgroundImage: NetworkImage(
                            userModel.image,
                          ),
                          radius: Dimensions.dimenisonNo20,
                        ),
                        SizedBox(width: Dimensions.dimenisonNo10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel.name,
                                style: TextStyle(
                                  overflow: TextOverflow.clip,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Dimensions.dimenisonNo16,
                                ),
                              ),
                              Text(
                                "M.no ${userModel.phone}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: Dimensions.dimenisonNo14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.call,
                            color: Colors.black,
                            size: Dimensions.dimenisonNo30,
                          ),
                          onPressed: () {
                            // _launchDialer(orderModel.userModel.phone.toString());
                          },
                        ),
                        SizedBox(width: Dimensions.dimenisonNo10),
                        CustomIconButton(
                          iconSize: Dimensions.dimenisonNo30,
                          icon: FontAwesomeIcons.whatsapp,
                          ontap: () {
                            // _openWhatsApp(orderModel.userModel.phone.toString());
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.dimenisonNo16),
                    child: Center(
                      child: Text(
                        'Appointment Information',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: Dimensions.dimenisonNo18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimensions.dimenisonNo16),
                  userInfoColumn(
                    title: "Appointment Date",
                    infoText:
                        "${widget.orderModel.serviceStartTime} TO ${widget.orderModel.serviceEndTime} ",
                  ),
                  userInfoColumn(
                    title: "Appointment Time",
                    infoText: widget.orderModel.serviceDate,
                  ),
                  userInfoColumn(
                    title: "Appointment No.",
                    infoText:
                        ' 000${widget.orderModel.appointmentNo.toString()}',
                  ),
                  Divider(thickness: Dimensions.dimenisonNo5),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.dimenisonNo16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service List",
                          style: TextStyle(
                            fontSize: Dimensions.dimenisonNo15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: Dimensions.dimenisonNo10),
                        ...widget.orderModel.services.map(
                          (singleService) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.dimenisonNo18_5),
                              child: SingleServiceOrderList(
                                  serviceModel: singleService),
                            );
                          },
                        ).toList(),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.dimenisonNo10),
                  Divider(),
                  widget.orderModel.userNote.length >= 2
                      ? userInfoColumn(
                          title: "Client Note",
                          infoText: widget.orderModel.userNote)
                      : const userInfoColumn(
                          title: "Client Note", infoText: "No user note"),
                  //payment section
                  SizedBox(height: Dimensions.dimenisonNo10),

                  const Divider(thickness: 3),

                  // Price Details Section

                  Padding(
                    padding: EdgeInsets.all(Dimensions.dimenisonNo16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Price Details',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(
                          height: Dimensions.dimenisonNo12,
                        ),
                        // Price Details Section
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.dimenisonNo10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Payment Status',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo14,
                                      // fontWeight: FontWeight.w500,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    widget.orderModel.payment,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.dimenisonNo20),
                              Row(
                                children: [
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo14,
                                      fontWeight: FontWeight.w400,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.dimenisonNo5),
                                  Text(
                                    '(services ${widget.orderModel.services.length})',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo14,
                                      // fontWeight: FontWeight.w500,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.currency_rupee,
                                    size: Dimensions.dimenisonNo18,
                                  ),
                                  Text(
                                    widget.orderModel.subtatal.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.dimenisonNo10),

                              // Platform Fees
                              Row(
                                children: [
                                  Text(
                                    'Platform Fees',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo14,
                                      // fontWeight: FontWeight.w500,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.currency_rupee,
                                    size: Dimensions.dimenisonNo14,
                                  ),
                                  Text(
                                    widget.orderModel.platformFees.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo14,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.dimenisonNo20),

                              // Total Amount
                              Row(
                                children: [
                                  Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.currency_rupee,
                                    size: Dimensions.dimenisonNo18,
                                  ),
                                  Text(
                                    widget.orderModel.totalPrice.toString(),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: Dimensions.dimenisonNo16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.90,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.dimenisonNo10),

                  const Divider(thickness: 3),
                  Padding(
                    padding: EdgeInsets.only(left: Dimensions.dimenisonNo16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Appointment Book Details",
                          style: TextStyle(
                            fontSize: Dimensions.dimenisonNo15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.orderModel.timeDateList.length,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              // Display the first element separately
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Book on  ${widget.orderModel.timeDateList[0].date}  at  ${widget.orderModel.timeDateList[0].time} by ${userModel.name}",
                                    style: TextStyle(
                                        fontSize: Dimensions.dimenisonNo12),
                                  ),
                                  // Display all remaining elements
                                  const SizedBox(
                                    height: 4,
                                  ),
                                  if (widget.orderModel.timeDateList.length > 1)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...widget.orderModel.timeDateList
                                            .sublist(1)
                                            .map(
                                          (singleTimeDate) {
                                            return Text(
                                              "update on ${singleTimeDate.date} at ${singleTimeDate.time} by ${singleTimeDate.updateBy}",
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.dimenisonNo12),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            } else {
                              // Returning an empty container to avoid redundant data (first element)
                              return SizedBox.shrink();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.dimenisonNo20),
                  Opacity(
                    opacity: widget.orderModel.status == "(Cancel)" ? 0.5 : 1.0,
                    child: IgnorePointer(
                      ignoring: widget.orderModel.status == "(Cancel)",
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.dimenisonNo16),
                        width: double.infinity,
                        child: CustomButtom(
                            text: "CheckOut",
                            ontap: () {
                              Routes.instance.push(
                                  widget: UserSideBarPaymentScreen(
                                    orderModel: widget.orderModel,
                                  ),
                                  context: context);
                            },
                            buttonColor: AppColor.buttonColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dimensions.dimenisonNo20,
                  ),
                ],
              ),
            ),
          );
  }
}
