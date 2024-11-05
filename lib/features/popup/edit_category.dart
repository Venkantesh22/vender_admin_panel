import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:samay_admin_plan/constants/constants.dart';
import 'package:samay_admin_plan/models/category_model/category_model.dart';
import 'package:samay_admin_plan/provider/service_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';
import 'package:samay_admin_plan/widget/customauthbutton.dart';
import 'package:samay_admin_plan/widget/customtextfield.dart';

class EditCategoryPopup extends StatefulWidget {
  final CategoryModel? categoryModel;
  const EditCategoryPopup({
    Key? key,
    required this.categoryModel,
  }) : super(key: key);

  @override
  State<EditCategoryPopup> createState() => _EditCategoryPopupState();
}

class _EditCategoryPopupState extends State<EditCategoryPopup> {
  @override
  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(context);
    final TextEditingController _categoryController =
        TextEditingController(text: widget.categoryModel?.categoryName);

    return AlertDialog(
      titlePadding: EdgeInsets.only(
        left: Dimensions.dimenisonNo20,
        right: Dimensions.dimenisonNo20,
        top: Dimensions.dimenisonNo20,
      ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo20,
          vertical: Dimensions.dimenisonNo10),
      actionsPadding: EdgeInsets.symmetric(
        vertical: Dimensions.dimenisonNo10,
      ),
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add New Category',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: Dimensions.dimenisonNo18,
                  fontFamily: GoogleFonts.roboto().fontFamily,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
              ),
            ],
          ),
          const Divider()
        ],
      ),
      content: SizedBox(
        height: Dimensions.dimenisonNo60,
        child: FormCustomTextField(
            controller: _categoryController, title: "Category Name"),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomAuthButton(
              buttonWidth: Dimensions.dimenisonNo150,
              text: "Cancel",
              bgColor: Colors.red,
              ontap: () {
                Navigator.pop(context);
              },
            ),
            CustomAuthButton(
              buttonWidth: Dimensions.dimenisonNo150,
              text: "Save",
              ontap: () {
                try {
                  showLoaderDialog(context);

                  bool isVaildated =
                      addNewCategoryVaildation(_categoryController.text);

                  if (isVaildated) {
                    CategoryModel categoryModel = widget.categoryModel!
                        .copyWith(
                            categoryName: _categoryController.text.trim());
                    serviceProvider.updateSingleCategoryPro(categoryModel);

                    Navigator.of(context, rootNavigator: true).pop();

                    // showMessage(
                    //     "New Category add Successfully Reload the Page");
                  }

                  Navigator.of(context, rootNavigator: true).pop();
                  showInforAlertDialog(
                      context,
                      "Successfully Edit the Category",
                      "Category is Edit Successfully reload the page to see changes.");
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showMessage("Error create new Category ${e.toString()}");
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
