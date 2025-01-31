import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sight_mate_app/core/constants/colors.dart';

class CustomGeneralButton extends StatelessWidget {
  const CustomGeneralButton(
      {Key? key, this.text, this.onTap, this.width, this.height})
      : super(key: key);
  final String? text;
  final VoidCallback? onTap;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: AppColors.primaryBlueColor,
          borderRadius: BorderRadius.circular(45),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text!,
              style: GoogleFonts.cairo(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButtonWithIcon extends StatelessWidget {
  const CustomButtonWithIcon(
      {Key? key, required this.text, this.onTap, this.iconData, this.color})
      : super(key: key);
  final String text;
  final IconData? iconData;
  final VoidCallback? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blue,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: color,
            ),
            Center(
              child: Text(
                text,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
