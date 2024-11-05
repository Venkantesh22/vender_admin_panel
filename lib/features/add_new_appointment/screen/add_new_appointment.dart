// ignore_for_file: unused_local_variable, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/Calender/screen/calender.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_tap.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/single_service_tap_icon.dart';
import 'package:samay_admin_plan/features/add_new_appointment/widget/time_tap.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/home/main_home/home_screen.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/samay_fb.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/service_model/service_model.dart';
import 'package:samay_admin_plan/models/timestamped_model/date_time_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class AddNewAppointment extends StatefulWidget {
  final SalonModel salonModel;
  const AddNewAppointment({
    Key? key,
    required this.salonModel,
  }) : super(key: key);

  @override
  State<AddNewAppointment> createState() => _AddNewAppointmentState();
}

class _AddNewAppointmentState extends State<AddNewAppointment> {
  DateTime _time = DateTime.now();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _appointmentDateController = TextEditingController();
  TextEditingController _appointmentTimeController =
      TextEditingController(text: "Select Time");
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _userNote = TextEditingController();

  List<ServiceModel> serchServiceList = [];
  List<ServiceModel> allServiceList = [];
  List<ServiceModel> selectService = [];

  bool _showCalender = false;
  bool _showServiceList = false;
  bool _showTimeContaine = false;
  bool _isLoading = false;

  // Function to get current date and time in a formatted string
  String getCurrentDate() {
    DateTime now = DateTime.now();
    return DateFormat('dd-MM-yyyy').format(now);
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    return DateFormat('hh:mm a').format(now); // HH:mm a (e.g. 03:45 PM)
  }

//Serching  Services base on service name and code
  void serchService(String value) {
    // Filtering based on both service name and service code
    serchServiceList = allServiceList
        .where((element) =>
            element.servicesName.toLowerCase().contains(value.toLowerCase()) ||
            element.serviceCode.toLowerCase().contains(value.toLowerCase()))
        .toList();

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getData();
    _initializeTimes();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });

    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);

    try {
      await appProvider.getSalonInfoFirebase();
      _appointmentDateController.text = DateFormat("dd/MM/yyyy").format(_time);
      List<ServiceModel> fetchedServices = await UserBookingFB.instance
          .getAllServicesFromCategories(appProvider.getSalonInformation.id);
      bookingProvider.getWatchList.clear();
      setState(() {
        allServiceList = fetchedServices;
      });
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  String? _selectedTimeSlot;
  String?
      _serviceEndTime; //! to get _serviceEndTime add _serviceStartTime + serviceDurtion

//for Salon open and closer time
  DateTime? _startTime;
  DateTime? _endTime;

//For time slot
  Map<String, List<String>> _categorizedTimeSlots = {
    'Morning': [],
    'Afternoon': [],
    'Evening': [],
    'Night': [],
  };

  String timeOfDayToString(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour
        .toString()
        .padLeft(2, '0'); // Ensures two digits for hour
    final minute = timeOfDay.minute
        .toString()
        .padLeft(2, '0'); // Ensures two digits for minute
    return "$hour:$minute";
  }

  void _initializeTimes() {
    try {
      String salonOpenTime = timeOfDayToString(widget.salonModel.openTime!);
      String salonCloseTime = timeOfDayToString(widget.salonModel.closeTime!);

      // Since the times are in 24-hour format, use 'HH:mm' instead of 'hh:mm a'
      _startTime = DateFormat('HH:mm').parse(salonOpenTime);
      _endTime = DateFormat('HH:mm').parse(salonCloseTime);

      print("Parsed startTime: $_startTime, endTime: $_endTime");
    } catch (e) {
      print('Error parsing time: $e');
    }
  }

  String _normalizeTimeString(String timeString) {
    return timeString.replaceAllMapped(
      RegExp(r'(\d{1,2}):(\d{2})\s*(AM|PM)'),
      (match) => '${match[1]?.padLeft(2, '0')}:${match[2]} ${match[3]}',
    );
  }

  int parseDuration(String duration) {
    final regex = RegExp(r'(\d+)h (\d+)m');
    final match = regex.firstMatch(duration);

    if (match != null) {
      final hours = int.parse(match.group(1)!);
      final minutes = int.parse(match.group(2)!);
      return hours * 60 + minutes;
    }

    return 0; // Default to 0 if parsing fails
  }

//Generate Time slotes
  void _generateTimeSlots(int serviceDurationInMinutes) {
    if (_startTime != null && _endTime != null) {
      DateTime currentTime = _startTime!;
      _categorizedTimeSlots.forEach((key, value) => value.clear());

      while (currentTime.isBefore(_endTime!)) {
        final slotEndTime =
            currentTime.add(Duration(minutes: serviceDurationInMinutes));

        // Display only the time part, ignoring the date
        String formattedTime = DateFormat('hh:mm a').format(currentTime);

        if (currentTime.hour < 12) {
          _categorizedTimeSlots['Morning']!.add(formattedTime);
        } else if (currentTime.hour < 17) {
          _categorizedTimeSlots['Afternoon']!.add(formattedTime);
        } else if (currentTime.hour < 21) {
          _categorizedTimeSlots['Evening']!.add(formattedTime);
        } else {
          _categorizedTimeSlots['Night']!.add(formattedTime);
        }

        // Move to the next time slot
        currentTime =
            currentTime.add(Duration(minutes: 30)); // Adjust as needed
      }

      // Ensure the last slot includes the closing time
      String lastSlotFormattedTime = DateFormat('hh:mm a').format(_endTime!);
      if (_categorizedTimeSlots['Night']!.last != lastSlotFormattedTime) {
        _categorizedTimeSlots['Night']!.add(lastSlotFormattedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider = Provider.of<BookingProvider>(context);
    final serviceBookingDuration = bookingProvider.getServiceBookingDuration;
    final serviceDurationInMinutes = parseDuration(serviceBookingDuration);
    _generateTimeSlots(serviceDurationInMinutes);

    return Scaffold(
      backgroundColor: AppColor.whileColor,
      appBar: const CustomAppBar(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: GestureDetector(
                onTap: () {
                  if (_showCalender ||
                      _showServiceList ||
                      _showTimeContaine == true) {
                    setState(() {
                      _showCalender = false;
                      _showServiceList = false;
                      _showTimeContaine = false;
                    });
                  }
                },
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.screenHeight * 2,
                      child: Stack(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.all(Dimensions.dimenisonNo16),
                                  child: Text(
                                    "Add New Appointment",
                                    style: TextStyle(
                                      fontSize: Dimensions.dimenisonNo20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Container to User TextBox
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: Dimensions.dimenisonNo16),
                                  padding:
                                      EdgeInsets.all(Dimensions.dimenisonNo16),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1.5),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.dimenisonNo8),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        // User Name textbox
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: Dimensions.dimenisonNo70,
                                              width: Dimensions.dimenisonNo250,
                                              child: FormCustomTextField(
                                                requiredField: false,
                                                controller: _nameController,
                                                title: "First Name",
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimensions.dimenisonNo30,
                                            ),
                                            //! User last Name textbox

                                            SizedBox(
                                              height: Dimensions.dimenisonNo70,
                                              width: Dimensions.dimenisonNo250,
                                              child: FormCustomTextField(
                                                requiredField: false,
                                                controller: _lastNameController,
                                                title: "Last Name",
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimensions.dimenisonNo30,
                                            ),
                                            //! select Date text box
                                            SizedBox(
                                              height: Dimensions.dimenisonNo70,
                                              width: Dimensions.dimenisonNo250,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Appointment Date",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: Dimensions
                                                          .dimenisonNo18,
                                                      fontFamily:
                                                          GoogleFonts.roboto()
                                                              .fontFamily,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.90,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        Dimensions.dimenisonNo5,
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions
                                                        .dimenisonNo30,
                                                    width: Dimensions
                                                        .dimenisonNo250,
                                                    child: TextFormField(
                                                      onTap: () {
                                                        setState(() {
                                                          _showCalender =
                                                              !_showCalender;
                                                        });
                                                        print(_showCalender);
                                                      },
                                                      readOnly: true,
                                                      cursorHeight: Dimensions
                                                          .dimenisonNo16,
                                                      style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo12,
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .roboto()
                                                                  .fontFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      controller:
                                                          _appointmentDateController,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .dimenisonNo10,
                                                            vertical: Dimensions
                                                                .dimenisonNo10),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .dimenisonNo16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        //! Search box for Services  text box

                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              height: Dimensions.dimenisonNo70,
                                              width: Dimensions.dimenisonNo250,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Service",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: Dimensions
                                                          .dimenisonNo18,
                                                      fontFamily:
                                                          GoogleFonts.roboto()
                                                              .fontFamily,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.90,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        Dimensions.dimenisonNo5,
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions
                                                        .dimenisonNo30,
                                                    width: Dimensions
                                                        .dimenisonNo250,
                                                    child: TextFormField(
                                                      onChanged:
                                                          (String value) {
                                                        serchService(value);
                                                      },
                                                      onTap: () {
                                                        setState(() {
                                                          _showServiceList =
                                                              !_showServiceList;
                                                        });
                                                      },
                                                      cursorHeight: Dimensions
                                                          .dimenisonNo16,
                                                      style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo12,
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .roboto()
                                                                  .fontFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      controller:
                                                          _serviceController,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText:
                                                            "Search Service...",
                                                        contentPadding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .dimenisonNo10,
                                                            vertical: Dimensions
                                                                .dimenisonNo10),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .dimenisonNo16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimensions.dimenisonNo30,
                                            ),
                                            //! mobile text box
                                            SizedBox(
                                              height: Dimensions.dimenisonNo70,
                                              width: Dimensions.dimenisonNo250,
                                              child: FormCustomTextField(
                                                requiredField: false,
                                                controller: _mobileController,
                                                title: "Mobile No",
                                              ),
                                            ),
                                            SizedBox(
                                              width: Dimensions.dimenisonNo30,
                                            ),

                                            //! select time textbox
                                            SizedBox(
                                              height: Dimensions.dimenisonNo70,
                                              width: Dimensions.dimenisonNo250,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Time",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: Dimensions
                                                          .dimenisonNo18,
                                                      fontFamily:
                                                          GoogleFonts.roboto()
                                                              .fontFamily,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0.90,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        Dimensions.dimenisonNo5,
                                                  ),
                                                  SizedBox(
                                                    height: Dimensions
                                                        .dimenisonNo30,
                                                    width: Dimensions
                                                        .dimenisonNo250,
                                                    child: TextFormField(
                                                      onTap: () {
                                                        setState(() {
                                                          _showTimeContaine =
                                                              !_showTimeContaine;
                                                          print(
                                                              "Time : $_showTimeContaine");
                                                        });
                                                      },
                                                      cursorHeight: Dimensions
                                                          .dimenisonNo16,
                                                      style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo12,
                                                          fontFamily:
                                                              GoogleFonts
                                                                      .roboto()
                                                                  .fontFamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                      controller:
                                                          _appointmentTimeController,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding: EdgeInsets.symmetric(
                                                            horizontal: Dimensions
                                                                .dimenisonNo10,
                                                            vertical: Dimensions
                                                                .dimenisonNo10),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .dimenisonNo16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        // SizedBox(height: Dimensions.dimenisonNo16),
                                      ],
                                    ),
                                  ),
                                ),
                                //! Genarate List of Service which in Watch list
                                GestureDetector(
                                  onTap: () {
                                    if (_showCalender ||
                                        _showServiceList ||
                                        _showTimeContaine == true) {
                                      setState(() {
                                        _showCalender = false;
                                        _showServiceList = false;
                                        _showTimeContaine = false;
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dimensions.dimenisonNo18,
                                        vertical: Dimensions.dimenisonNo12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Select Serivce",
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.dimenisonNo18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const Spacer(),
                                            Text(
                                              "Service Duration ${bookingProvider.getServiceBookingDuration}",
                                              style: TextStyle(
                                                fontSize:
                                                    Dimensions.dimenisonNo18,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: Dimensions.dimenisonNo10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  Dimensions.dimenisonNo12),
                                          child: Wrap(
                                            spacing: Dimensions
                                                .dimenisonNo12, // Horizontal space between items
                                            runSpacing: Dimensions
                                                .dimenisonNo12, // Vertical space between rows
                                            children: List.generate(
                                              bookingProvider
                                                  .getWatchList.length,
                                              (index) {
                                                ServiceModel servicelist =
                                                    bookingProvider
                                                        .getWatchList[index];
                                                return SizedBox(
                                                  width:
                                                      Dimensions.dimenisonNo300,
                                                  child:
                                                      SingleServiceTapDeleteIcon(
                                                    serviceModel: servicelist,
                                                    onTap: () {
                                                      try {
                                                        showLoaderDialog(
                                                            context);
                                                        setState(() {
                                                          bookingProvider
                                                              .removeServiceToWatchList(
                                                                  servicelist);

                                                          bookingProvider
                                                              .calculateTotalBookingDuration();
                                                          bookingProvider
                                                              .calculateSubTotal();
                                                        });

                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();
                                                        showMessage(
                                                            'Service is removed from Watch List');
                                                      } catch (e) {
                                                        showMessage(
                                                            'Error occurred while removing service from Watch List: ${e.toString()}');
                                                      }
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimensions.dimenisonNo12),
                                        //! TextBox for user note
                                        SizedBox(
                                          width: Dimensions.screenWidth,
                                          child: FormCustomTextField(
                                            requiredField: false,
                                            controller: _userNote,
                                            title: "User Note",
                                            maxline: 2,
                                            hintText:
                                                "Instruction of for appointment",
                                          ),
                                        ),
                                        SizedBox(
                                            height: Dimensions.dimenisonNo12),
                                        // Detail of appointment
                                        //! Appointment Details
                                        if (_appointmentDateController != null)
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.dimenisonNo250),
                                            padding: EdgeInsets.symmetric(
                                                horizontal:
                                                    Dimensions.dimenisonNo20),
                                            decoration: BoxDecoration(
                                              color: AppColor.grey,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.dimenisonNo10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height: Dimensions
                                                        .dimenisonNo16),
                                                if (_selectedTimeSlot != null)
                                                  Text(
                                                    'Service Time',
                                                    style: TextStyle(
                                                      fontSize: Dimensions
                                                          .dimenisonNo16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                const Divider(
                                                  color: Colors.white,
                                                ),
                                                if (_selectedTimeSlot !=
                                                    null) ...[
                                                  SizedBox(
                                                      height: Dimensions
                                                          .dimenisonNo10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Appointment Date',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                      Spacer(),
                                                      Text(
                                                        _appointmentDateController
                                                            .text,
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .dimenisonNo10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Appointment Duration',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        bookingProvider
                                                            .getServiceBookingDuration,
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 1,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .dimenisonNo10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Appointment Start Time',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        '$_selectedTimeSlot',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .dimenisonNo10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Appointment End Time',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Text(
                                                        DateFormat('hh:mm a')
                                                            .format(
                                                          DateFormat('hh:mm a')
                                                              .parse(
                                                                  _selectedTimeSlot!)
                                                              .add(
                                                                Duration(
                                                                    minutes:
                                                                        serviceDurationInMinutes),
                                                              ),
                                                        ),
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .dimenisonNo10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'SubTotal',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        Icons.currency_rupee,
                                                        size: Dimensions
                                                            .dimenisonNo16,
                                                      ),
                                                      Text(
                                                        bookingProvider
                                                            .getSubTotal
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .dimenisonNo10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Platform fee',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        Icons.currency_rupee,
                                                        size: Dimensions
                                                            .dimenisonNo16,
                                                      ),
                                                      Text(
                                                        GlobalVariable
                                                            .salonPlatformFee
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .dimenisonNo10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Total',
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                      const Spacer(),
                                                      Icon(
                                                        Icons.currency_rupee,
                                                        size: Dimensions
                                                            .dimenisonNo16,
                                                      ),
                                                      Text(
                                                        bookingProvider
                                                            .getfinalTotal
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: Dimensions
                                                              .dimenisonNo14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.90,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height: Dimensions
                                                          .dimenisonNo16),

                                                  //! Save Button
                                                  CustomAuthButton(
                                                    text: "Save Appointment",
                                                    ontap: () async {
                                                      showLoaderDialog(context);

                                                      //! Calculating service in time.
                                                      _serviceEndTime =
                                                          DateFormat('hh:mm a')
                                                              .format(
                                                        DateFormat('hh:mm a')
                                                            .parse(
                                                                _selectedTimeSlot!)
                                                            .add(
                                                              Duration(
                                                                  minutes:
                                                                      serviceDurationInMinutes),
                                                            ),
                                                      );
                                                      TimeDateModel
                                                          timeDateModel =
                                                          TimeDateModel(
                                                              id: widget
                                                                  .salonModel
                                                                  .id,
                                                              date: GlobalVariable
                                                                  .getCurrentDate(),
                                                              time: GlobalVariable
                                                                  .getCurrentTime(),
                                                              updateBy:
                                                                  "${widget.salonModel.name} (Create a Appointment)");
                                                      //! user full name
                                                      String fullName =
                                                          "${_nameController.text.trim()} ${_lastNameController.text.trim()}";
                                                      //! user model
                                                      UserModel userInfo = UserModel(
                                                          id: widget.salonModel
                                                              .adminId,
                                                          name: fullName,
                                                          phone:
                                                              _mobileController
                                                                  .text
                                                                  .trim(),
                                                          image:
                                                              'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png',
                                                          email: "No email",
                                                          password: " ",
                                                          timeDateModel:
                                                              timeDateModel);
                                                      // get Book appointment time

                                                      bool _isVaildater =
                                                          addNewAppointmentVaildation(
                                                              _nameController
                                                                  .text,
                                                              _lastNameController
                                                                  .text,
                                                              _mobileController
                                                                  .text);
                                                      Navigator.of(context,
                                                              rootNavigator:
                                                                  true)
                                                          .pop();
                                                      if (_isVaildater) {
                                                        showLoaderDialog(
                                                            context);
                                                        //get appointmentNo by add 1
                                                        int appointmentNo =
                                                            await SamayFB
                                                                .instance
                                                                .incrementSalonAppointmentNo();
                                                        bool value =
                                                            // ignore: use_build_context_synchronously
                                                            await UserBookingFB
                                                                .instance
                                                                .saveAppointmentManual(
                                                          bookingProvider
                                                              .getWatchList,
                                                          userInfo,
                                                          appointmentNo,
                                                          bookingProvider
                                                              .getfinalTotal
                                                              .toString(),
                                                          GlobalVariable
                                                              .salonPlatformFee
                                                              .toString(),
                                                          bookingProvider
                                                              .getSubTotal
                                                              .toString(),
                                                          "PAP (Pay At Place)",
                                                          bookingProvider
                                                              .getServiceBookingDuration,
                                                          _appointmentDateController
                                                              .text
                                                              .trim(),
                                                          _appointmentTimeController
                                                              .text
                                                              .trim(),
                                                          _serviceEndTime!,
                                                          _userNote.text.isEmpty
                                                              ? " "
                                                              : _userNote.text
                                                                  .trim(),
                                                          widget.salonModel,
                                                          context,
                                                        );
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pop();

                                                        showMessage(
                                                            "Successfull add the appointment");

                                                        if (value) {
                                                          showLoaderDialog(
                                                              context);
                                                          Future.delayed(
                                                            const Duration(
                                                                seconds: 1),
                                                            () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return AlertDialog(
                                                                    content:
                                                                        SizedBox(
                                                                      height: Dimensions
                                                                          .dimenisonNo250,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        children: [
                                                                          SizedBox(
                                                                            height:
                                                                                Dimensions.dimenisonNo12,
                                                                          ),
                                                                          Icon(
                                                                            FontAwesomeIcons.solidHourglassHalf,
                                                                            size:
                                                                                Dimensions.dimenisonNo40,
                                                                            color:
                                                                                AppColor.buttonColor,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                Dimensions.dimenisonNo20,
                                                                          ),
                                                                          Text(
                                                                            'Appointment Book Successfull',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: Dimensions.dimenisonNo16,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                Dimensions.dimenisonNo16,
                                                                          ),
                                                                          Text(
                                                                            '     Your booking has been processed!\nDetails of appointment are included below',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: Dimensions.dimenisonNo12,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                Dimensions.dimenisonNo20,
                                                                          ),
                                                                          Text(
                                                                            'Appointment No : ${GlobalVariable.appointmentNO}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: Dimensions.dimenisonNo14,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Routes.instance.push(
                                                                              widget: const HomeScreen(),
                                                                              context: context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          'OK',
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                Dimensions.dimenisonNo18,
                                                                            fontWeight:
                                                                                FontWeight.w700,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            },
                                                          );
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        }
                                                      }
                                                    },
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_showTimeContaine)
                            Positioned(
                              right: Dimensions.dimenisonNo360,
                              top: Dimensions.dimenisonNo150,
                              child: SingleChildScrollView(
                                child: Container(
                                  padding:
                                      EdgeInsets.all(Dimensions.dimenisonNo12),
                                  color: Colors.white,
                                  width: Dimensions.dimenisonNo500,
                                  child: Column(
                                    children: [
                                      TimeSlot(
                                        section: 'Morning',
                                        timeSlots:
                                            _categorizedTimeSlots['Morning'] ??
                                                [],
                                        selectedTimeSlot: _selectedTimeSlot,
                                        serviceDurationInMinutes:
                                            serviceDurationInMinutes,
                                        endTime: _endTime,
                                        onTimeSlotSelected: (selectedSlot) {
                                          setState(() {
                                            _selectedTimeSlot = selectedSlot;
                                            _appointmentTimeController.text =
                                                selectedSlot;
                                          });
                                        },
                                      ),
                                      TimeSlot(
                                        section: 'Afternoon',
                                        timeSlots: _categorizedTimeSlots[
                                                'Afternoon'] ??
                                            [],
                                        selectedTimeSlot: _selectedTimeSlot,
                                        serviceDurationInMinutes:
                                            serviceDurationInMinutes,
                                        endTime: _endTime,
                                        onTimeSlotSelected: (selectedSlot) {
                                          setState(() {
                                            _selectedTimeSlot = selectedSlot;
                                            _appointmentTimeController.text =
                                                selectedSlot;
                                          });
                                        },
                                      ),
                                      TimeSlot(
                                        section: 'Evening',
                                        timeSlots:
                                            _categorizedTimeSlots['Evening'] ??
                                                [],
                                        selectedTimeSlot: _selectedTimeSlot,
                                        serviceDurationInMinutes:
                                            serviceDurationInMinutes,
                                        endTime: _endTime,
                                        onTimeSlotSelected: (selectedSlot) {
                                          setState(() {
                                            _selectedTimeSlot = selectedSlot;
                                            _appointmentTimeController.text =
                                                selectedSlot;
                                          });
                                        },
                                      ),
                                      TimeSlot(
                                        section: 'Night',
                                        timeSlots:
                                            _categorizedTimeSlots['Night'] ??
                                                [],
                                        selectedTimeSlot: _selectedTimeSlot,
                                        serviceDurationInMinutes:
                                            serviceDurationInMinutes,
                                        endTime: _endTime,
                                        onTimeSlotSelected: (selectedSlot) {
                                          setState(() {
                                            _selectedTimeSlot = selectedSlot;
                                            _appointmentTimeController.text =
                                                selectedSlot;
                                          });
                                        },
                                      ),
                                      SizedBox(
                                        height: Dimensions.dimenisonNo12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          if (_showCalender)
                            Positioned(
                              right: Dimensions.dimenisonNo360,
                              top: Dimensions.dimenisonNo120,
                              child: SizedBox(
                                height: Dimensions.dimenisonNo400,
                                width: Dimensions.dimenisonNo360,
                                child: CustomCalendar(
                                  salonModel: widget.salonModel,
                                  controller: _appointmentDateController,
                                  initialDate: _time,
                                  onDateChanged: (selectedDate) {},
                                ),
                              ),
                            ),
                          if (_showServiceList)
                            Positioned(
                              left: 93,
                              top: 215,
                              child: Container(
                                width: Dimensions.dimenisonNo500,
                                constraints: const BoxConstraints(
                                  maxHeight:
                                      320, // Set a max height to make it scrollable
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.dimenisonNo10),
                                ),
                                child: _serviceController.text.isNotEmpty &&
                                        serchServiceList.isEmpty
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                          top: Dimensions.dimenisonNo12,
                                          left: Dimensions.dimenisonNo16,
                                          bottom: Dimensions.dimenisonNo12,
                                        ),
                                        child: Text(
                                          "No service found",
                                          style: TextStyle(
                                              fontSize:
                                                  Dimensions.dimenisonNo14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    : serchServiceList.contains(
                                                // ignore: iterable_contains_unrelated_type
                                                _serviceController.text) ||
                                            _serviceController.text.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                              top: Dimensions.dimenisonNo12,
                                              left: Dimensions.dimenisonNo16,
                                              bottom: Dimensions.dimenisonNo12,
                                            ),
                                            child: Text(
                                              "Enter a Service name or Code",
                                              style: TextStyle(
                                                  fontSize:
                                                      Dimensions.dimenisonNo14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: serchServiceList.length,
                                            itemBuilder: (context, index) {
                                              ServiceModel serviceModel =
                                                  serchServiceList[index];
                                              return
                                                  // !isSearched()

                                                  SingleServiceTap(
                                                      serviceModel:
                                                          serviceModel);
                                            },
                                          ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
