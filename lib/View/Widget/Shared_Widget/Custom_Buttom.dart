import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomButtom extends StatelessWidget {
  CustomButtom({super.key, required this.tital, required this.onTap});
  String tital;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 32,
        decoration: BoxDecoration(
          color: constDarkBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          tital,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontFamily: lateef,
          ),
        ),
      ),
    );
  }
}
