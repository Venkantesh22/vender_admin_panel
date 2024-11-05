import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/features/custom_appbar/screen/custom_appbar.dart';
import 'package:samay_admin_plan/features/services_page/screen/category_drawer.dart';
import 'package:samay_admin_plan/features/services_page/screen/services_list.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';

class ServicesPages extends StatefulWidget {
  const ServicesPages({super.key});

  @override
  State<ServicesPages> createState() => _ServicesPagesState();
}

class _ServicesPagesState extends State<ServicesPages> {
  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CustomAppBar(),
      ),
      body: Row(
        children: [
          // Ensure CatergoryDrawer only takes fixed width
          const CatergoryDrawer(),

          // Expanded to fill remaining space
          Expanded(
            child: serviceProvider.getCategoryList.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Colors.red,
                  ))
                : Navigator(
                    onGenerateRoute: (settings) {
                      if (settings.name == '/services_list') {
                        return MaterialPageRoute(
                          builder: (context) => ServicesList(),
                        );
                      }
                      return null;
                    },
                    initialRoute: '/services_list',
                    onUnknownRoute: (settings) => MaterialPageRoute(
                      builder: (context) => ServicesList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
