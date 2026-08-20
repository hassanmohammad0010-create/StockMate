// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class DepartmentHeadsMainTabController extends GetxController
    with GetSingleTickerProviderStateMixin {

  DepartmentHeadsMainTabController({this.length});

  late final TabController tabController;
  int _previousIndex = 0;
  int? length;
  static const int inventoryTabIndex = 1;
    static const int orderTabIndex = 2;


  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: length ?? 4, vsync: this);
    tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (tabController.indexIsChanging) return; 
    final int currentIndex = tabController.index;
    if (currentIndex != _previousIndex) {
      _cleanupTab(_previousIndex); 
      _previousIndex = currentIndex;
    }
  }

  void _cleanupTab(int index) {
    switch (index) {
      case inventoryTabIndex:
        if (Get.isRegistered<FilterController>(
          tag: AppRoutes.DepartmentHeadsInventoryPage,
        )) {
          Get.delete<FilterController>(
            tag: AppRoutes.DepartmentHeadsInventoryPage,
          );
        }
        case orderTabIndex:
        if (Get.isRegistered<FilterController>(
          tag: AppRoutes.DepartmentOrdersPage,
        )) {
          Get.delete<FilterController>(
            tag: AppRoutes.DepartmentOrdersPage,
          );
        }
        break;
    }
  }
  @override
  void onClose() {
    tabController.removeListener(_onTabChanged);
    tabController.dispose();
    super.onClose();
  }
}