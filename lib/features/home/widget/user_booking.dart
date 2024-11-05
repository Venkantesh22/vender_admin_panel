import 'package:flutter/material.dart';
import 'package:samay_admin_plan/features/home/widget/state_text.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_firestore_helper/user_order_fb.dart';
import 'package:samay_admin_plan/models/user_model/user_model.dart';
import 'package:samay_admin_plan/models/user_order/user_order_model.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:flutter/scheduler.dart';

class UserBookingTap extends StatefulWidget {
  final OrderModel orderModel;

  const UserBookingTap({
    super.key,
    required this.orderModel,
  });

  @override
  State<UserBookingTap> createState() => _UserBookingTapState();
}

class _UserBookingTapState extends State<UserBookingTap> {
  bool isLoading = false;
  late UserModel userModel;

  @override
  void initState() {
    super.initState();
    // Use SchedulerBinding to avoid 'setState' being called during layout/build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    userModel = await UserBookingFB.instance
        .getUserInforOrderFB(widget.orderModel.userId);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : FutureBuilder<UserModel>(
            future: UserBookingFB.instance
                .getUserInforOrderFB(widget.orderModel.userId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              }

              // Retrieve the userModel from the snapshot
              userModel = snapshot.data!;

              return Container(
                margin: EdgeInsets.only(
                  bottom: Dimensions.dimenisonNo12,
                  left: Dimensions.dimenisonNo12,
                  right: Dimensions.dimenisonNo12,
                ),
                padding: EdgeInsets.all(Dimensions.dimenisonNo8),
                height: Dimensions.dimenisonNo60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.mainColor,
                  borderRadius: BorderRadius.circular(Dimensions.dimenisonNo12),
                ),
                child: Row(
                  children: [
                    SizedBox(width: Dimensions.dimenisonNo16),
                    CircleAvatar(
                      radius: Dimensions.dimenisonNo20,
                      backgroundColor: Colors.green[100],
                      backgroundImage: NetworkImage(userModel.image),
                      onBackgroundImageError: (error, stackTrace) {
                        debugPrint('Image load error: $error');
                      },
                    ),
                    // CircleAvatar(
                    //   radius: Dimensions.dimenisonNo20,
                    //   backgroundColor: Colors.green[100],
                    //   child: ClipOval(
                    //     child: Image.network(
                    //       userModel.image,
                    //       errorBuilder: (context, error, stackTrace) {
                    //         return Icon(
                    //             Icons.error); // Shows error icon if image fails
                    //       },
                    //       fit: BoxFit.cover,
                    //     ),
                    //   ),
                    // ),
                    SizedBox(width: Dimensions.dimenisonNo20),
                    SizedBox(
                      width: Dimensions.dimenisonNo200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel.name,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Dimensions.dimenisonNo16,
                            ),
                          ),
                          Text(
                            userModel.phone.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Dimensions.dimenisonNo14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Text(
                        '${widget.orderModel.serviceStartTime} To ${widget.orderModel.serviceEndTime}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Dimensions.dimenisonNo14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    StateText(status: widget.orderModel.status),
                    SizedBox(width: Dimensions.dimenisonNo16),
                  ],
                ),
              );
            },
          );
  }
}
