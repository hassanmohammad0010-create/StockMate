// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentHeadsMainTabController.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Controller/Service/Get_User_Profile_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Unread_Notification_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Chat_Bot_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Orders_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Setting_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Home_Page.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class DepartmentHeadsMainPage extends StatelessWidget {
  const DepartmentHeadsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    if (!Get.isRegistered<DepartmentHeadsMainTabController>()) {
      Get.put(DepartmentHeadsMainTabController(), permanent: true);
    }
    final DepartmentHeadsMainTabController tabCtrl =
        Get.find<DepartmentHeadsMainTabController>();

    final GetNameRollOfUserController getNameRollOfUserController = Get.put(
      GetNameRollOfUserController(),
    );

    if (!Get.isRegistered<UnreadNotificationController>()) {
      Get.put(UnreadNotificationController(), permanent: true);
    }
    final UnreadNotificationController unreadCtrl =
        Get.find<UnreadNotificationController>();

    Get.put(UserProfileController());
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: SizedBox(
          width: w * 0.18,
          height: h * 0.08,
          child: FloatingActionButton(
            backgroundColor: constBlue,
            foregroundColor: Colors.white,
            splashColor: constColor,
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () {
              Get.toNamed(AppRoutes.DepartmentHeadsAddNewOrderPage);
            },
            child: Icon(Icons.add, size: 35),
          ),
        ),
        appBar: AppBar(
          toolbarHeight: h * 0.1,
          actions: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.smart_toy,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {
                    Get.to(ChatBotPage());
                  },
                ),
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () {
                        Get.toNamed(AppRoutes.NotificationPage);
                      },
                    ),
                    Obx(() {
                      final count = unreadCtrl.unreadCount.value;
                      if (count <= 0) return const SizedBox.shrink();

                      return Positioned(
                        right: w * 0.01,
                        top: h * 0.005,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: w * 0.012,
                            vertical: 1,
                          ),
                          constraints: BoxConstraints(
                            minWidth: w * 0.05,
                            minHeight: h * 0.02,
                          ),
                          decoration: const BoxDecoration(
                            color: constRed,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            count > 99 ? '99+' : '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
            SizedBox(width: w * 0.02),
          ],
          elevation: 4.0,
          shadowColor: constColor,
          foregroundColor: Colors.white,
          surfaceTintColor: constColor,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "StrokMate",
                style: TextStyle(
                  fontFamily: lateef,
                  fontSize: 32,
                  color: Colors.white,
                ),
              ),
              Text(
                "مستشفى الهلال الاحمر الطبي",
                style: TextStyle(
                  fontFamily: lateef,
                  fontSize: 24,
                  color: constBlue,
                ),
              ),
              SizedBox(height: h * 0.01),
            ],
          ),
          backgroundColor: constColor,
          bottom: TabBar(
            controller: tabCtrl.tabController,
            dividerColor: Theme.of(context).cardColor,
            indicatorColor: constBlue,
            indicatorWeight: 5,
            indicatorSize: TabBarIndicatorSize.tab,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(
                icon: const Icon(Icons.dashboard_sharp, color: Colors.white),
                child: Text(
                  'الرئيسية',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: cairo,
                    fontSize: 16,
                  ),
                ),
              ),
              Tab(
                icon: const Icon(Icons.inventory_2_sharp, color: Colors.white),
                child: Text(
                  'المخزون',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: cairo,
                    fontSize: 16,
                  ),
                ),
              ),
              Tab(
                icon: const Icon(Icons.receipt_long_sharp, color: Colors.white),
                child: Text(
                  'الطلبات',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: cairo,
                    fontSize: 16,
                  ),
                ),
              ),
              Tab(
                icon: const Icon(Icons.settings, color: Colors.white),
                child: Text(
                  'الاعدادات',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: cairo,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        // drawer: CustomDrawer(),
        // ✅ Obx بتستمع لـ id.value (RxnString) وتمنع بناء التبويبات
        // قبل ما الـ id يوصل فعليًا من التوكن/الـ API.
        body: Obx(() {
          final String? departmentId = getNameRollOfUserController.id.value;

          if (departmentId == null) {
            return const Center(child: CustomLoadingIndicator());
          }

          return TabBarView(
            controller: tabCtrl.tabController,
            children: [
              DepartmentHeadsHomePage(),
              DepartmentHeadsInventoryPage(departmentId: departmentId),
              DepartmentOrdersPage(),
              SettingPage(),
            ],
          );
        }),
      ),
    );
  }
}
