// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Orders_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Setting_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Home_Page.dart';

class DepartmentHeadsMainPage extends StatelessWidget {
  const DepartmentHeadsMainPage({super.key});

  final String pageName = '/DepartmentHeadsMainPage';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
              backgroundColor: constBackgroundColor,

        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
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
                    // fTODO: فتح صفحة الإشعارات
                  },
                ),
                // نقطة حمراء تدل على وجود إشعارات جديدة
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
          elevation: 10,
          shadowColor: Colors.black,
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
              const SizedBox(height: 8),
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
        body: TabBarView(
          children: [
            DepartmentHeadsHomePage(),
            DepartmentHeadsInventoryPage(),
            DepartmentOrdersPage(),
            SettingPage(),
          ],
        ),
      ),
    );
  }
}
