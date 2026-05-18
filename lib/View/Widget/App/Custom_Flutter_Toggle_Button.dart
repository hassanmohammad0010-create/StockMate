import 'package:flutter/material.dart';
import 'package:flutter_toggle_button/flutter_toggle_button.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';

class CustomFlutterToggleButton extends StatelessWidget {
  const CustomFlutterToggleButton({
    super.key,
    required this.controller,
    required this.firstOption,
    required this.secondOption,
  });
  final String firstOption, secondOption;
  final ToggleController controller;
  @override
  Widget build(BuildContext context) {
    return FlutterToggleButton(
      items: [
        Text(firstOption, style: TextStyle(fontSize: 22, fontFamily: lateef)),
        Text(secondOption, style: TextStyle(fontSize: 22, fontFamily: lateef)),
      ],
      onTap: (index) {
        controller.changeIndex(index); // ← ربط الزر بالكونترولر
      },
      buttonWidth: 120,
      buttonHeight: 50,
      borderRadius: 8,
      outerContainerBorderColor: constLightBlue,
      outerContainerColor: constLightBlue,
      buttonBorderColor: constLightBlue,
      buttonTextFontSize: 18,
      enableTextColor: Colors.white,
      disableTextColor: constBlue,
      buttonGradient: const LinearGradient(colors: [constBlue, constBlue]),
    );
  }
}
