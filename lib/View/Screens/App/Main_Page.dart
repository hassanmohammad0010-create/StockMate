// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Unread_Notification_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Boss_Home_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Requests_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Setting_Page.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  final String pageName = '/HomePage';

  @override
  Widget build(BuildContext context) {
    // ✅ نفس نمط DepartmentHeadsMainPage: تسجيل واحد فقط، permanent
    if (!Get.isRegistered<UnreadNotificationController>()) {
      Get.put(UnreadNotificationController(), permanent: true);
    }
    final UnreadNotificationController unreadCtrl =
        Get.find<UnreadNotificationController>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: constBackgroundColor,
        appBar: AppBar(
          toolbarHeight: context.screenHeight * 0.1,
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
                    Get.toNamed(AppRoutes.ChatPage);
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
                    // ✅ الـ badge صار reactive وبيختفي تلقائياً لو العدد صفر
                    Obx(() {
                      final count = unreadCtrl.unreadCount.value;
                      if (count <= 0) return const SizedBox.shrink();

                      return Positioned(
                        right: context.screenWidth * 0.01,
                        top: context.screenHeight * 0.005,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.012,
                            vertical: 1,
                          ),
                          constraints: BoxConstraints(
                            minWidth: context.screenWidth * 0.05,
                            minHeight: context.screenHeight * 0.02,
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
            SizedBox(width: context.screenWidth * 0.02),
          ],
          elevation: 5,
          shadowColor: Colors.black,
          foregroundColor: Colors.white,
          surfaceTintColor: constColor,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "StockMate",
                style: TextStyle(
                  fontFamily: lateef,
                  fontSize: context.screenHeight * 0.038,
                  color: Colors.white,
                ),
              ),
              Text(
                "مستشفى الهلال الاحمر الطبي",
                style: TextStyle(
                  fontFamily: lateef,
                  fontSize: context.screenHeight * 0.028,
                  color: constBlue,
                ),
              ),
              SizedBox(height: context.screenHeight * 0.01),
            ],
          ),
          backgroundColor: constColor,
          bottom: TabBar(
            indicatorColor: constBlue,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(
              fontSize: context.screenHeight * 0.015,
              fontWeight: FontWeight.w600,
            ),
            tabs: [
              Tab(
                icon: const Icon(Icons.dashboard_sharp),
                child: Text(
                  'الرئيسية',
                  style: TextStyle(
                    fontFamily: cairo,
                    fontSize: context.screenHeight * 0.019,
                  ),
                ),
              ),
              Tab(
                icon: const Icon(Icons.inventory_2_sharp),
                child: Text(
                  'المخزون',
                  style: TextStyle(
                    fontFamily: cairo,
                    fontSize: context.screenHeight * 0.019,
                  ),
                ),
              ),
              Tab(
                icon: const Icon(Icons.receipt_long_sharp),
                child: Text(
                  'الطلبات',
                  style: TextStyle(
                    fontFamily: cairo,
                    fontSize: context.screenHeight * 0.019,
                  ),
                ),
              ),
              Tab(
                icon: const Icon(Icons.settings),
                child: Text(
                  'الاعدادات',
                  style: TextStyle(
                    fontFamily: cairo,
                    fontSize: context.screenHeight * 0.019,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BossHomePage(),
            InventoryPage(),
            RequestPage(),
            SettingPage(),
          ],
        ),
      ),
    );
  }
}
