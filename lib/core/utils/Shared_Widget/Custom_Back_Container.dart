import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomBackContainer extends StatelessWidget {
  const CustomBackContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 32),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.20,
      decoration: BoxDecoration(color: constColor),
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.18,
          height: MediaQuery.of(context).size.height * 0.08,
          decoration: BoxDecoration(
            color: constBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_forward_outlined,
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
