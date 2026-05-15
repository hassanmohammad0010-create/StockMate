import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToggleController extends GetxController {
  var selectedIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    // pageController.dispose();
    super.onClose();
  }

  void reset() {
    selectedIndex.value = 0;
    pageController.jumpToPage(0);
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }
}
