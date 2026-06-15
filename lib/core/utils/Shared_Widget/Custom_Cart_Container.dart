// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Dialog.dart';

class CustomCartContainer extends StatelessWidget {
  const CustomCartContainer({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.buttonText,
  });

  final String title;
  final String subtitle;
  final void Function()? onTap;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      height: h * 0.09,
      margin: EdgeInsets.symmetric(vertical: h * 0.005, horizontal: w * 0.01),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle),
          trailing: Container(
            width: w * 0.35,
            height: h * 0.04,
            decoration: BoxDecoration(
              color: buttonColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: MaterialButton(
              onPressed:
                  onTap ??
                  () {
                    CustomDialog.show(
                      title: 'ارجاع الى المخزون',
                      message:
                          'هل أنت متأكد من رغبتك في إرجاع هذا المنتج إلى المخزون؟',
                      type: DialogType.warning,
                      showTextField: true,
                      textFieldHint: 'ادخل الكمية التي تريد إرجاعها',
                    );
                  },
              child: Text(
                buttonText,
                style: TextStyle(
                  color: buttonTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
