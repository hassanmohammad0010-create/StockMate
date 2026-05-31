import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomQuantityContainer extends StatelessWidget {
  CustomQuantityContainer({
    super.key,
    required this.bg,
    required this.label,
    required this.textColor,
    required this.value,
  });
  String value, label;
  Color bg, textColor;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(fontSize: 11, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
