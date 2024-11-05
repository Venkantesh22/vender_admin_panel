import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:samay_admin_plan/constants/global_variable.dart';
import 'package:samay_admin_plan/provider/app_provider.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

// ignore: must_be_immutable
class WeekRow extends StatefulWidget {
  final String dayOfWeek;
  TextEditingController time;
  String value;

  WeekRow({
    super.key,
    required this.dayOfWeek,
    required this.time,
    this.value = "",
  });

  @override
  State<WeekRow> createState() => _WeekRowState();
}

class _WeekRowState extends State<WeekRow> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    // String? _Timing;
    final List<String> _timeOrClose =
        appProvider.getSalonInformation.monday!.isEmpty
            ? [
                "${GlobalVariable.OpenTime.format(context).toString()} To ${GlobalVariable.CloseTime.format(context).toString()}",
                'Close',
              ]
            : [
                "${appProvider.getSalonInformation.openTime?.format(context).toString()} To ${appProvider.getSalonInformation.closeTime!.format(context).toString()}",
                'Close',
              ];
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Dimensions.dimenisonNo30,
          vertical: Dimensions.dimenisonNo10),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.dayOfWeek,
            style: TextStyle(
              color: Colors.black,
              fontSize: Dimensions.dimenisonNo16,
              fontFamily: GoogleFonts.roboto().fontFamily,
              letterSpacing: 0.02,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: Dimensions.dimenisonNo50,
            width: Dimensions.dimenisonNo200,
            child: DropdownButtonFormField<String>(
              hint: Text(
                'Select Time',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: Dimensions.dimenisonNo16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.40,
                ),
              ),
              value: widget.value.length > 3
                  ? widget.value
                  : widget.time.text.isNotEmpty
                      ? widget.time.text
                      : null,
              items: _timeOrClose.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  widget.time.text = newValue!;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
