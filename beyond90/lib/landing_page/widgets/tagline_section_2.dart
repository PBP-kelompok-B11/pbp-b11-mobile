import 'package:flutter/material.dart';
import 'package:beyond90/app_colors.dart';

class TaglineSection2 extends StatelessWidget {
  const TaglineSection2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: "Explore stories and matches beyond the ",
              style: TextStyle(
                fontFamily: 'Geologica',
                fontSize: 18,
                fontWeight: FontWeight.normal,
                height: 1.3,
                color: AppColors.white,
              ),
            ),
            TextSpan(
              text: "90 minutes",
              style: TextStyle(
                fontFamily: 'Geologica',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.3,
                color: AppColors.lime,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
