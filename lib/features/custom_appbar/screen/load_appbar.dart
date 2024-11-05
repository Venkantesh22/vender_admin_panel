import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/custom_appbar/widget/appbar_item.dart';
import 'package:samay_admin_plan/features/home/main_home/home_screen.dart';
import 'package:samay_admin_plan/features/services_page/screen/services_page.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class LoadAppBar extends StatefulWidget implements PreferredSizeWidget {
  const LoadAppBar({super.key});

  @override
  State<LoadAppBar> createState() => _LoadAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _LoadAppBarState extends State<LoadAppBar> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return AppBar(
      backgroundColor: AppColor.mainColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo10,
          vertical: Dimensions.dimenisonNo10,
        ),
        child: Row(
          children: [
            // Image.asset(
            //   AppImages.logo,
            //   height: Dimensions.dimenisonNo40,
            // ),
            appProvider.getLogImageList.isNotEmpty
                ? Image.network(
                    appProvider.getLogo.image,
                    height: Dimensions.dimenisonNo40,
                    // fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      return progress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                    },
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.broken_image, // User icon in case of error
                      size: Dimensions
                          .dimenisonNo60, // Set the size of the icon (adjust as needed)
                      color: Colors
                          .grey, // Set the color of the icon (adjust as needed)
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
            SizedBox(width: Dimensions.dimenisonNo20),
            Container(
              width: 3,
              height: Dimensions.dimenisonNo40,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            SizedBox(width: Dimensions.dimenisonNo20),
            Appbaritem(
              text: "Calendar",
              icon: Icons.calendar_month_outlined,
              ontap: () {
                Routes.instance
                    .push(widget: const HomeScreen(), context: context);
              },
            ),
            // SizedBox(width: Dimensions.dimenisonNo20),
            // Appbaritem(
            //   text: "Sales",
            //   icon: Icons.bar_chart,
            //   ontap: () {
            //     Routes.instance.push(widget: HomeScreen(), context: context);
            //   },
            // ),
            SizedBox(width: Dimensions.dimenisonNo20),
            Appbaritem(
              text: "Services",
              icon: Icons.room_service,
              ontap: () {
                Routes.instance.push(widget: ServicesPages(), context: context);
              },
            ),
            const Spacer(),
            SizedBox(width: Dimensions.dimenisonNo20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.black),
                onPressed: () {
                  Routes.instance
                      .push(widget: ServicesPages(), context: context);
                },
              ),
            ),
            SizedBox(width: Dimensions.dimenisonNo20),
            Container(
              width: 3,
              height: Dimensions.dimenisonNo40,
              decoration: const BoxDecoration(color: Colors.white),
            ),
            SizedBox(width: Dimensions.dimenisonNo20),
            Padding(
              padding: EdgeInsets.all(Dimensions.dimenisonNo20),
              child: CircleAvatar(
                radius: Dimensions.dimenisonNo20,
                child: SizedBox(
                  height: Dimensions.dimenisonNo20,
                  width: Dimensions.dimenisonNo20,
                  child: const CircularProgressIndicator(),
                ),
              ),
            ),
            SizedBox(width: Dimensions.dimenisonNo20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dimensions.dimenisonNo20,
                  width: Dimensions.dimenisonNo20,
                  child: const CircularProgressIndicator(),
                ),
                SizedBox(
                  height: Dimensions.dimenisonNo5,
                ),
                Text(
                  'Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Dimensions.dimenisonNo12,
                    fontFamily: GoogleFonts.roboto().fontFamily,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
