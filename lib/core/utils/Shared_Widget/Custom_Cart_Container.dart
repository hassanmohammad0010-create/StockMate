// ignore_for_file: file_names, deprecated_member_use, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/DialogType.dart';

class CustomCartContainer extends StatelessWidget {
  const CustomCartContainer({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.buttonText,
    this.onReturnConfirm,
    this.maxReturnQuantity,
  });

  final String title;
  final String subtitle;
  final void Function()? onTap;
  final Color buttonColor;
  final Color buttonTextColor;
  final String buttonText;
  final void Function(int returnQuantity)? onReturnConfirm;
  final int? maxReturnQuantity;

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final TextEditingController qtyController = TextEditingController();

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
              onPressed: onTap ??
                  () {
                    qtyController.clear();
                    CustomDialog.show(
                      title: 'ارجاع الى المخزون',
                      message:
                          'هل أنت متأكد من رغبتك في إرجاع هذا المنتج إلى المخزون؟',
                      type: DialogType.warning,
                      showTextField: true,
                      textFieldHint:
                          'ادخل الكمية التي تريد إرجاعها (افتراضياً الكل)',
                      textFieldKeyboard: TextInputType.number,
                      textFieldController: qtyController,
                      textFieldValidator: (value) {
                        if (value == null || value.trim().isEmpty) return null;
                        final n = int.tryParse(value.trim());
                        if (n == null) return 'يرجى ادخال رقم صحيح';
                        if (n <= 0) return 'الكمية يجب ان تكون اكبر من صفر';
                        if (maxReturnQuantity != null &&
                            n > maxReturnQuantity!) {
                          return 'الكمية تتجاوز ما اضيف الى السلة (${maxReturnQuantity})';
                        }
                        return null;
                      },
                      onConfirm: () {
                        final raw = qtyController.text.trim();
                        final int returnQty =
                            raw.isEmpty ? (maxReturnQuantity ?? 1) : int.parse(raw);
                        onReturnConfirm?.call(returnQty);
                        Get.back();
                      },
                    );
                  },
              child: Text(
                buttonText,
                style: TextStyle(color: buttonTextColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
