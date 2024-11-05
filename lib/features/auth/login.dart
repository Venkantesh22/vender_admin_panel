// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/constants/router.dart';
import 'package:samay_admin_plan/features/auth/singup.dart';
import 'package:samay_admin_plan/features/home/main_home/home_screen.dart';
import 'package:samay_admin_plan/firebase_helper/firebase_auth_helper/firebase_auth_helper.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/color.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = true; // Start with loading as true

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchImagesInBackground();
    });
  }

  // Fetching the data in the background
  Future<void> fetchImagesInBackground() async {
    try {
      // Fetch data in the background without blocking the UI
      AppProvider appProvider =
          Provider.of<AppProvider>(context, listen: false);

      if (appProvider.getLogImageList.isEmpty) {
        await appProvider.callBackFunction();
      }

      if (appProvider.getLogImageList.isNotEmpty)
        await Future.delayed(Duration(seconds: 2));
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching images: $e");
    }
    // finally {
    //   // Once the fetch is complete, remove the loading state
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      backgroundColor: _isLoading ? AppColor.whileColor : AppColor.bgForAuth,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Container(
                margin: EdgeInsets.all(Dimensions.dimenisonNo30),
                padding: EdgeInsets.all(Dimensions.dimenisonNo20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.dimenisonNo20,
                          vertical: Dimensions.dimenisonNo10),
                      decoration: BoxDecoration(
                          color: AppColor.bgForAdminCreateSec,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius:
                              BorderRadius.circular(Dimensions.dimenisonNo20)),
                      width: Dimensions.dimenisonNo400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Admin Login',
                            style: TextStyle(
                              color: AppColor.createText,
                              fontSize: Dimensions.dimenisonNo24,
                              fontFamily: GoogleFonts.roboto().fontFamily,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: Dimensions.dimenisonNo20),
                          Container(
                              height: Dimensions.dimenisonNo80,
                              width: Dimensions.dimenisonNo80,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.dimenisonNo18)),
                              child: appProvider.getLogImageList.isNotEmpty
                                  ? Image.network(
                                      appProvider.getLogo.image,
                                      // fit: BoxFit.cover,
                                      loadingBuilder:
                                          (context, child, progress) {
                                        return progress == null
                                            ? child
                                            : const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) => Icon(
                                        Icons
                                            .broken_image, // User icon in case of error
                                        size: Dimensions
                                            .dimenisonNo60, // Set the size of the icon (adjust as needed)
                                        color: Colors
                                            .grey, // Set the color of the icon (adjust as needed)
                                      ),
                                    )
                                  : const Center(
                                      child: CircularProgressIndicator())
                              // Image.asset(
                              //   AppImages.logo,
                              // ),
                              ),
                          SizedBox(height: Dimensions.dimenisonNo20),
                          CustomTextField(
                              controller: _emailController,
                              obscureForPassword: false,
                              keyboardType: TextInputType.emailAddress,
                              label: "Email"),
                          SizedBox(height: Dimensions.dimenisonNo10),
                          CustomTextField(
                              controller: _passwordController,
                              obscureForPassword: true,
                              keyboardType: TextInputType.name,
                              label: "Password"),
                          SizedBox(height: Dimensions.dimenisonNo20),
                          CustomAuthButton(
                            text: "Login",
                            ontap: () async {
                              bool isVaildated = loginVaildation(
                                  _emailController.text,
                                  _passwordController.text);

                              if (isVaildated) {
                                bool isLogined =
                                    await FirebaseAuthHelper.instance.login(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim(),
                                        context);
                                if (isLogined) {
                                  Routes.instance.pushAndRemoveUntil(
                                      widget: const HomeScreen(),
                                      context: context);
                                }
                              }
                            },
                          ),
                          SizedBox(height: Dimensions.dimenisonNo20),
                          InkWell(
                            onTap: () {
                              Routes.instance.push(
                                  widget: const SingupScreen(),
                                  context: context);
                            },
                            child: Text(
                              'Not registered yet?',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: Dimensions.dimenisonNo16,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline,
                                letterSpacing: 0.15,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Dimensions.dimenisonNo60,
                    ),
                    Column(
                      children: [
                        Text(
                          'Main hu Samay,                     ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo30,
                            fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15,
                          ),
                        ),
                        Text(
                          '      mere Sath chalo.!',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: Dimensions.dimenisonNo30,
                            fontFamily: GoogleFonts.inknutAntiqua().fontFamily,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.15,
                          ),
                        ),
                        Expanded(
                            child: appProvider.getLogImageList.isNotEmpty
                                ? Image.network(
                                    appProvider.getcartoon.image,
                                    height: Dimensions.dimenisonNo400,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      return progress == null
                                          ? child
                                          : const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) => Icon(
                                      Icons
                                          .broken_image, // User icon in case of error
                                      size: Dimensions
                                          .dimenisonNo60, // Set the size of the icon (adjust as needed)
                                      color: Colors
                                          .grey, // Set the color of the icon (adjust as needed)
                                    ),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator())

                            // Image.asset(
                            //   "assets/images/cartoon.png",
                            //   height: Dimensions.dimenisonNo400,
                            // ),
                            ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
