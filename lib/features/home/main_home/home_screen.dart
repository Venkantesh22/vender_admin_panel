import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/models/salon_form_models/salon_infor_model.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/user_order/user_order_model.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/load_appbar.dart';
import 'package:samay_admin_plan/features/home/user_info_sidebar/screen/user_info_sidebar.dart';
import 'package:samay_admin_plan/features/home/user_list/screen/user_list.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/provider/booking_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  OrderModel? selectedOrder;
  int? selectIndex;
  SalonModel? salonModal;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    BookingProvider bookingProvider =
        Provider.of<BookingProvider>(context, listen: false);
    ServiceProvider serviceProvider =
        Provider.of<ServiceProvider>(context, listen: false);
    try {
      await appProvider.getSalonInfoFirebase();
      await appProvider.getAdminInfoFirebase();

      if (appProvider.getLogImageList.isEmpty) {
        await appProvider.callBackFunction();
      }
      await serviceProvider
          .callBackFunction(appProvider.getSalonInformation.id);
      bookingProvider.getWatchList.clear();
      salonModal = appProvider.getSalonInformation;
    } catch (e) {
      print("Error fetching data: $e");
      // Optional: Show error UI
    } finally {
      if (mounted) {
        // Check if the widget is still mounted
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // Function to update the selected order
  void _onBookingSelected(OrderModel order, int index) {
    setState(() {
      selectedOrder = order;
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    // Provide fallback UI in case salonModal is null
    if (salonModal == null) {
      return Scaffold(
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : Text("Failed to load salon information."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.whileColor,
      appBar: isLoading
          ? const PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: LoadAppBar(),
            )
          : const PreferredSize(
              preferredSize: Size.fromHeight(60.0),
              child: CustomAppBar(),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Left Side: User Booking List
                Expanded(
                  child: UserList(
                    salonModel: salonModal!,
                    onBookingSelected: _onBookingSelected,
                  ),
                ),
                // Right Side: Detailed User Information
                Container(
                  decoration: const BoxDecoration(
                    color: AppColor.sideBarBgColor,
                    border: Border(
                      left: BorderSide(
                          width: 2.0,
                          color: Colors
                              .black), // Set the width and color of the border
                    ),
                  ),
                  width: Dimensions.screenWidth / 3,
                  child: selectedOrder != null
                      ? UserInfoSideBar(
                          orderModel: selectedOrder!, index: selectIndex!)
                      : const Center(
                          child: Text("Select a booking to see details"),
                        ),
                ),
              ],
            ),
    );
  }
}
