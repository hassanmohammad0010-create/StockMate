import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Create_Employee_Account_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Electronic_Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Entry_And_Exit_Report_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Department_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Purchasing_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Suppliers_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Under_Implementation_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Add_Ordinary_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Add_Recurring_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department-Heads_Main_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Add_New_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Home_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Orders_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Report_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Login_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Reset_Password_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Splash_View_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Completed_Request_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stock Mate',
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   fontFamily: 'Cairo'
      // ),
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
        GetPage(
          name: DepartmentHeadsAddNewOrderPage().pageName,
          page: () => DepartmentHeadsAddNewOrderPage(),
        ),
        GetPage(
          name: DepartmentHeadsHomePage().pageName,
          page: () => DepartmentHeadsHomePage(),
        ),
        GetPage(
          name: DepartmentOrdersPage().pageName,
          page: () => DepartmentOrdersPage(),
        ),
        GetPage(
          name: AddOrdinaryOrderPage().pageName,
          page: () => AddOrdinaryOrderPage(),
        ),
        GetPage(
          name: AddRecurringOrderPage().pageName,
          page: () => AddRecurringOrderPage(),
        ),
          GetPage(
          name: ReportPage().pageName,
          page: () => ReportPage(),
        ),
      
      ],
      initialRoute: DepartmentHeadsMainPage().pageName,
    );
  }
}
