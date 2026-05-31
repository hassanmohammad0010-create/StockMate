import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomRow extends StatelessWidget {
  CustomRow({
    super.key,
    required this.title,
    required this.iconData,
    required this.label,
  });
  String title, label;
  IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(iconData, size: 30, color: constGray),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: constGray,
                      fontFamily: cairo,
                    ),
                  ),
                ],
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontFamily: cairo,
                ),
              ),
            ],
          ),
          Divider(endIndent: 16, indent: 16, thickness: 0.5),
        ],
      ),
    );
  }
}
