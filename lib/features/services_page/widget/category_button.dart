import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay_admin_plan/utility/dimenison.dart';

class CatergryButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const CatergryButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CatergryButton> createState() => _CatergryButtonState();
}

class _CatergryButtonState extends State<CatergryButton> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
                color: _isHovering
                    ? Color.fromARGB(255, 155, 152, 152).withOpacity(0.5)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.dimenisonNo10)),
            margin: const EdgeInsets.all(3),
            padding: EdgeInsets.fromLTRB(
                Dimensions.dimenisonNo16,
                Dimensions.dimenisonNo10,
                Dimensions.dimenisonNo10,
                Dimensions.dimenisonNo10),
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: Dimensions.dimenisonNo16,
                fontFamily: GoogleFonts.roboto().fontFamily,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15,
              ),
            ),
          ),
        )
        //  ListTile(
        //   tileColor: _isHovering ? Colors.red : Colors.transparent,
        //   title: Text(
        //     widget.text,
        //     style: TextStyle(
        //       color: Colors.white,
        //       fontSize: Dimensions.dimenisonNo18,
        //       fontFamily: GoogleFonts.roboto().fontFamily,
        //       fontWeight: FontWeight.w300,
        //       letterSpacing: 0.15,
        //     ),
        //   ),
        //   onTap: widget.onTap,
        // ),
        );
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }
}
