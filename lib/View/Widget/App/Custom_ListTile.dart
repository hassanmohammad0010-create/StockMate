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

  // ← النص اللي بيعني إنه ما في رئيس للقسم
  static const String _noManagerText = 'لا يوجد رئيس للقسم';

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = description == _noManagerText;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.03, // ← بدل 12
        vertical: context.screenHeight * 0.005, // ← بدل 4
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.screenHeight * 0.005, // ← بدل 8
        ),
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
            padding: EdgeInsets.all(context.screenWidth * 0.025), // ← بدل 10
            decoration: BoxDecoration(
              // ← نخفف اللون شوي لو معطّلة
              color: isDisabled
                  ? backgroundColor.withOpacity(0.5)
                  : backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDisabled ? iconColor.withOpacity(0.5) : iconColor,
              size: context.screenHeight * 0.038, // ← بدل 32
            ),
          ),
          title: Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: cairo,
              fontSize: context.screenHeight * 0.019, // ← بدل 16
              color: isDisabled ? Colors.grey : null,
            ),
          ),
          subtitle: Text(
            description,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: constGray,
              fontFamily: lateef,
              fontSize: context.screenHeight * 0.024, // ← بدل 20
            ),
          ),
          // ← نخفي السهم لو التايل غير قابل للضغط
          trailing: isDisabled
              ? null
              : Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: context.screenHeight * 0.028, // ← بدل default
                ),
          // ← لو معطّلة، onTap بتصير null فيصير الـ ListTile فعلياً غير قابل للضغط
          onTap: isDisabled ? null : onTap,
        ),
      ),
    );
  }
}
