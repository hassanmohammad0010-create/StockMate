import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20Purchasing%20committee/Head_Of_Purchasing_Home_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20Purchasing%20committee/Head_of_Purchasing_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Setting_Page.dart';

class MainPageHeadOfPurchasingPage extends StatelessWidget {
  const MainPageHeadOfPurchasingPage({super.key});
  final String pageName = '/MainPageHeadOfPurchasingPage';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // backgroundColor: constColor,
        backgroundColor: constBackgroundColor,
        appBar: AppBar(
          toolbarHeight: context.screenHeight * 0.1,
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: context.screenHeight * 0.033,
                  ),
                  onPressed: () {},
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: context.screenHeight * 0.012,
                    height: context.screenHeight * 0.012,
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
            HeadOfPurchasingHomePage(),
            HeadOfPurchasingRequestPage(),
            SettingPage(),
          ],
        ),
      ),
    );
  }
}
