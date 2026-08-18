// lib/core/utils/Departments_Heads/Custom_Date_Field/Custom_Date_Field.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

/// حقل اختيار تاريخ بنفس التصميم الخارجي تبع CustomDropdown بالضبط
/// (نفس الـ border، الأيقونة، النص، وزر المسح) — بس بدل ما يفتح
/// overlay قائمة، بيفتح showDatePicker عن طريق [onTap].
class CustomDateField extends StatelessWidget {
  const CustomDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.formattedValue,
    this.onClear,
    this.icon = Icons.date_range,
    this.clearable = true,
    this.errorText,
  });

  final String label;
  final DateTime? value;

  /// نص العرض الجاهز (متلاً controller.formatDate(value))
  /// لو مو ممرر، رح نعرض value.toString() كـ fallback
  final String? formattedValue;

  final VoidCallback onTap;
  final VoidCallback? onClear;
  final IconData icon;
  final bool clearable;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final hasValue = value != null;
    final isError = errorText != null && errorText!.isNotEmpty;
    final showClear = hasValue && clearable;

    final borderColor = isError ? constRed : Colors.grey.shade300;
    final borderWidth = isError ? 1.5 : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onTap,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 8, 0),
                    child: Row(
                      children: [
                        Icon(icon, size: 25, color: constBlue),
                        SizedBox(width: w * 0.04),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: h * 0.018),
                            child: hasValue
                                ? Text(
                                    formattedValue ?? value.toString(),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: constColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                : Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (showClear)
                GestureDetector(
                  onTap: onClear,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: w * 0.02,
                      vertical: h * 0.005,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (isError)
          Padding(
            padding: EdgeInsets.only(right: w * 0.05, top: h * 0.005),
            child: Text(
              errorText!,
              style: TextStyle(color: constRed, fontSize: 11),
            ),
          ),
      ],
    );
  }
}
