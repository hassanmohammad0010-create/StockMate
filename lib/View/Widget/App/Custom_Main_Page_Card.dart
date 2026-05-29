import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomMainPageCard extends StatelessWidget {
  CustomMainPageCard({
    super.key,
    required this.requestNum,
    required this.description,
    required this.icons,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.onTap,
  });
  Color iconColor, iconBackgroundColor;
  IconData icons;
  final int requestNum;
  final String description;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // لون الظل
                blurRadius: 8, // ضبابية الظل
                spreadRadius: 1, // انتشار الظل
                offset: Offset(0, 0), // اتجاه الظل (x, y)
              ),
            ],
          ),
          width: MediaQuery.of(context).size.width * 0.46,
          height: MediaQuery.of(context).size.height * 0.22,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Row(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: iconBackgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icons, size: 40, color: iconColor),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                  Text(
                    '$requestNum',
                    style: TextStyle(
                      color: constColor,
                      fontFamily: lateef,
                      fontSize: 48,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Text(
                  description,
                  style: TextStyle(
                    color: constGray,
                    fontFamily: cairo,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Align(
                alignment: AlignmentGeometry.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                  decoration: BoxDecoration(
                    color: iconColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'عرض التفاصيل',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: cairo,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
