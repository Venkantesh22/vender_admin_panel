import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/features/Account_Create_Form/screen/form_weektime_screen.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/setting/ForgetPassword/forget_password_page.dart';
import 'package:samay_admin_plan/features/setting/about/about_us_page.dart';
import 'package:samay_admin_plan/features/setting/admin/admin_screen.dart';
import 'package:samay_admin_plan/features/setting/logout/logout.dart';
import 'package:samay_admin_plan/features/setting/setting/verder_setting.dart';
import 'package:samay_admin_plan/features/setting/social_media/social_media.dart';
import 'package:samay_admin_plan/features/setting/support/support_page.dart';
import 'package:samay_admin_plan/features/setting/vender_profile/vender_page.dart';
import 'package:samay_admin_plan/features/setting/week_time_edit/week_time_edit.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  // @override
  // void initState() {
  //   // TODO: implement initState

  //   super.initState();
  //   getData();
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data here after dependencies are fully initialized
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    AppProvider appProvider = Provider.of<AppProvider>(context);
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    try {
      serviceProvider.fetchSettingPro(appProvider.getSalonInformation.id);
    } catch (e) {
      print("Error fetching data: $e");
    }

    setState(() {
      _isLoading = false;
    });
  }

  final List<String> _menuTitles = [
    'Salon Profile',
    'Admin Profile',
    'Week Time Schedule',
    'Social Media',
    'Setting',
    'About Us',
    'Contact Us',
    'Forget Password',
    'Logout',
  ];

  final List<IconData> _menuIcons = [
    Icons.person,
    Icons.admin_panel_settings,
    Icons.schedule,
    Icons.share,
    Icons.settings,
    Icons.info,
    Icons.support_agent,
    Icons.lock_reset,
    Icons.logout,
  ];

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    final List<Widget> _pages = [
      const SalonProfilePage(),
      const AdminPage(),
      appProvider.getSalonInformation.monday!.isEmpty
          ? const FormTimeSection()
          : const WeekTimeEdit(),
      const SocialMediaPage(),
      const VerderSetting(),
      const AboutUsPage(),
      const SupportPage(),
      const ForgetPassword(),
      const LogoutPage(),
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Drawer(
                  child: ListView.builder(
                    itemCount: _menuTitles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Icon(_menuIcons[index],
                            color: _selectedIndex == index
                                ? Colors.white
                                : Colors.black),
                        title: Text(
                          _menuTitles[index],
                          style: TextStyle(
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        tileColor: _selectedIndex == index
                            ? AppColor.buttonColor
                            : null,
                        onTap: () {
                          // Use SchedulerBinding to avoid setState in build/layout phase
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _selectedIndex = index;
                            });
                          });
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
    );
  }
}
