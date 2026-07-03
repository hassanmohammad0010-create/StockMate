// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.icon,
    required this.number,
    required this.title,
    required this.buttonTitle,
    required this.onTap,
    required this.iconBackgroundColor,
    required this.buttonColor,
  });

  final Icon icon;
  final String number;
  final String title;
  final String buttonTitle;
  final VoidCallback onTap;
  final Color iconBackgroundColor;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {

    final h = context.screenHeight;
    final w = context.screenWidth;

    // ignore: sized_box_for_whitespace
    return Container(
      width: w * 0.48,
      height: h * 0.17,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                vertical: h * 0.015,
                horizontal: w * 0.06,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: icon,
                  ),
                  SizedBox(width: w * 0.06),
                  Text(number, style: TextStyle(fontSize: 30)),
                ],
              ),
            ),
            SizedBox(height: h * 0.005),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: w * 0.06),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: h * 0.005),
            Container(
              width: w * 0.38,
              margin: EdgeInsets.symmetric(
                vertical: h * 0.005,
              ),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(8),
              ),
              height: h * 0.03,
              child: MaterialButton(
                onPressed: onTap,
                child: Text(
                  buttonTitle,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
