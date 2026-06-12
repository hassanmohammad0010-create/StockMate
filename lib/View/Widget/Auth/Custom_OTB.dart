import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomOtb extends StatelessWidget {
  CustomOtb({super.key, required this.onSubmit});
  Function(String data) onSubmit;

  @override
  Widget build(BuildContext context) {
    return OtpTextField(
      margin: EdgeInsetsGeometry.symmetric(horizontal: 4),
      filled: true,
      fillColor: Colors.white,
      numberOfFields: 6,

      enabledBorderColor: constColor,
      fieldWidth: 54,
      keyboardType: TextInputType.number,
      borderRadius: BorderRadius.circular(8),
      borderColor: constColor,
      showFieldAsBox: true,
      onSubmit: onSubmit,
    );
  }
}
