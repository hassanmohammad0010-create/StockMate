import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Boss_Home_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Setting_Page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  final String pageName = '/HomePage';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: constColor,

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
                    // TODO: فتح صفحة الإشعارات
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
            indicatorColor: constBlue,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),

            tabs: [
              Tab(
                icon: const Icon(Icons.dashboard_sharp),
                child: Text(
                  'الرئيسية',
                  style: TextStyle(fontFamily: cairo, fontSize: 16),
                ),
              ),
              Tab(
                icon: const Icon(Icons.inventory_2_sharp),

                child: Text(
                  'المخزون',
                  style: TextStyle(fontFamily: cairo, fontSize: 16),
                ),
              ),
              Tab(
                icon: const Icon(Icons.receipt_long_sharp),

                child: Text(
                  'الطلبات',
                  style: TextStyle(fontFamily: cairo, fontSize: 16),
                ),
              ),
              Tab(
                icon: const Icon(Icons.settings),
                child: Text(
                  'الاعدادات',
                  style: TextStyle(fontFamily: cairo, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        // drawer: CustomDrawer(),
        body: TabBarView(
          children: [HomePage(), Scaffold(), Scaffold(), SettingPage()],
        ),
      ),
    );
  }
}
