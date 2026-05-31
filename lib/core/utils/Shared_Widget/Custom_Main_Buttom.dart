// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomMainButtom extends StatelessWidget {
  const CustomMainButtom({
    super.key,
    required this.title,
    required this.color,
    required this.fontcolor,
    required this.onPressed,
    this.icon,
  });

  final String title;
  final Color color;
  final Color fontcolor;
  final void Function()? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.92,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: fontcolor,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            if (icon != null) ...[
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Icon(icon, size: 20, color: fontcolor),
            ],
          ],
        ),
      ),
    );
  }
}
