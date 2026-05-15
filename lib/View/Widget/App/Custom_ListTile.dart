import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomListTile extends StatelessWidget {
  CustomListTile({
    super.key,
    required this.backgroundColor,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.onTap,
    required this.title,
  });
  IconData icon;
  Color iconColor, backgroundColor;
  String title, description;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 32),
          ),

          title: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: cairo,
              fontSize: 16,
            ),
          ),

          subtitle: Text(
            description,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: constGray,
              fontFamily: lateef,
              fontSize: 20,
            ),
          ),

          trailing: Icon(Icons.chevron_right, color: Colors.grey),

          onTap: onTap,
        ),
      ),
    );
  }
}
