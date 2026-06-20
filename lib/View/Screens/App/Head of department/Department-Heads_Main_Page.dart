// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Orders_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Setting_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Home_Page.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class DepartmentHeadsMainPage extends StatelessWidget {
  const DepartmentHeadsMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          floatingActionButton: SizedBox(
            width: context.screenWidth * 0.18,
            height: context.screenHeight * 0.08,
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
            toolbarHeight: context.screenHeight * 0.1,
            actions: [
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
                  Positioned(
                    right: context.screenWidth * 0.02,
                    top: context.screenHeight * 0.01,
                    child: Container(
                      width: context.screenWidth * 0.02,
                      height: context.screenHeight * 0.015,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: context.screenWidth * 0.02),
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
                SizedBox(height: context.screenHeight * 0.01),
              ],
            ),
            backgroundColor: constColor,
            bottom: TabBar(
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
                  icon: const Icon(
                    Icons.inventory_2_sharp,
                    color: Colors.white,
                  ),

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
                  icon: const Icon(
                    Icons.receipt_long_sharp,
                    color: Colors.white,
                  ),

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
          body: TabBarView(
            children: [
              DepartmentHeadsHomePage(),
              DepartmentHeadsInventoryPage(),
              DepartmentOrdersPage(),
              SettingPage(),
            ],
          ),
        ),
      ),
    );
  }
}
