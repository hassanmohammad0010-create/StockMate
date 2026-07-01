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

  void _handleDefaultTap() {
    final TextEditingController qtyController = TextEditingController();

    CustomDialog.show(
      title: 'ارجاع الى المخزون',
      message: 'هل أنت متأكد من رغبتك في إرجاع هذا المنتج إلى المخزون؟',
      type: DialogType.warning,
      showTextField: true,
      textFieldHint: 'ادخل الكمية التي تريد إرجاعها',
      textFieldKeyboard: TextInputType.number,
      textFieldController: qtyController,
      textFieldValidator: (value) {
        if (value == null || value.trim().isEmpty) return null;
        final n = int.tryParse(value.trim());
        if (n == null) return 'يرجى ادخال رقم صحيح';
        if (n <= 0) return 'الكمية يجب ان تكون اكبر من صفر';
        if (maxReturnQuantity != null && n > maxReturnQuantity!) {
          return 'الكمية تتجاوز ما اضيف الى السلة (${maxReturnQuantity})';
        }
        return null;
      },
      onConfirm: () {
        final raw = qtyController.text.trim();
        final int returnQty = raw.isEmpty
            ? (maxReturnQuantity ?? 1)
            : int.parse(raw);
        onReturnConfirm?.call(returnQty);
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: h * 0.006, horizontal: w * 0.03),
      padding: EdgeInsets.symmetric(horizontal: w * 0.035, vertical: h * 0.014),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // أيقونة دائرية تعطي هوية بصرية للعنصر داخل السلة
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: buttonColor.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: buttonTextColor,
              size: 22,
            ),
          ),
          SizedBox(width: w * 0.03),
          // العنوان والوصف
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: w * 0.02),
          // زر الإجراء (شكل كبسولة مع تأثير لمس واضح)
          Material(
            color: buttonColor,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onTap ?? _handleDefaultTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: w * 0.035,
                  vertical: h * 0.011,
                ),
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: buttonTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
