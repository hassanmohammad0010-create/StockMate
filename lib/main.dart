import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Create_Employee_Account_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Electronic_Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Entry_And_Exit_Report_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Department_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Purchasing_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Suppliers_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Under_Implementation_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department-Heads_Main_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_OTB_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Login_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Reset_Password_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Splash_View_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_Account_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Completed_Request_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,

      getPages: [
        GetPage(name: SplashViewPage().pageName, page: () => SplashViewPage()),
        GetPage(name: LoginPage().pageName, page: () => LoginPage()),

        GetPage(
          name: ResetPasswordPage().pageName,
          page: () => ResetPasswordPage(),
        ),
        GetPage(name: MainPage().pageName, page: () => MainPage()),
        GetPage(
          name: DepartmentHeadsMainPage().pageName,
          page: () => DepartmentHeadsMainPage(),
        ),
        GetPage(
          name: CompletedRequestPage().pageName,
          page: () => CompletedRequestPage(),
        ),
        GetPage(
          name: UnderImplementationRequestPage().pageName,
          page: () => UnderImplementationRequestPage(),
        ),
        GetPage(
          name: NesseryPurchasingRequestPage().pageName,
          page: () => NesseryPurchasingRequestPage(),
        ),
        GetPage(
          name: NesseryDepartmentRequestPage().pageName,
          page: () => NesseryDepartmentRequestPage(),
        ),
        GetPage(
          name: ElectronicInventoryPage().pageName,
          page: () => ElectronicInventoryPage(),
        ),
        GetPage(
          name: EntryAndExitReportPage().pageName,
          page: () => EntryAndExitReportPage(),
        ),
        GetPage(name: SuppliersPage().pageName, page: () => SuppliersPage()),
        GetPage(
          name: CreateEmployeeAccountPage().pageName,
          page: () => CreateEmployeeAccountPage(),
        ),
      ],
      initialRoute: SplashViewPage().pageName,
    );
  }
}
