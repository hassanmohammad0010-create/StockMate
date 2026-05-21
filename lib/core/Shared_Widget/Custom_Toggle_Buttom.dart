// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';

// ignore: must_be_immutable
class CustomToggleButtom extends StatelessWidget {
  CustomToggleButtom({
    super.key,
    required this.first,
    required this.second,
    required this.controller,
  });
  // final ToggleController controller = Get.put(ToggleController());
  final ToggleController controller;

  String first, second;
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        color: constLightBlue,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // لون الظل
            blurRadius: 8, // ضبابية الظل
            spreadRadius: 1, // انتشار الظل
            offset: Offset(0, 0), // اتجاه الظل (x, y)
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,

        children: [_buildTab(first, 0, context), _buildTab(second, 1, context)],
      ),
    );
  }

  Widget _buildTab(String label, int index, context) {
    return Obx(() {
      final bool isSelected = controller.selectedIndex.value == index;

      return GestureDetector(
        onTap: () => controller.changeIndex(index),
        child: AnimatedContainer(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.34,
          height: MediaQuery.of(context).size.height * 0.055,
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: isSelected ? constBlue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // لون الظل
                      blurRadius: 8, // ضبابية الظل
                      spreadRadius: 1, // انتشار الظل
                      offset: Offset(0, 0), // اتجاه الظل (x, y)
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : constBlue,
              fontFamily: lateef,
              fontSize: 24,
            ),
          ),
        ),
      );
    });
  }
}
