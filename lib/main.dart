import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Enter_OTB_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Login_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Reset_Password_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Splash_View_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Confirm_Account_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Completed_Request_Page.dart';

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
      title: 'Flutter Demo',
      getPages: [
        GetPage(name: SplashViewPage().pageName, page: () => SplashViewPage()),
        GetPage(name: LoginPage().pageName, page: () => LoginPage()),
        GetPage(
          name: ConfirmAccountPage().pageName,
          page: () => ConfirmAccountPage(),
        ),

        GetPage(name: EnterOTBPage().pageName, page: () => EnterOTBPage()),
        GetPage(
          name: ResetPasswordPage().pageName,
          page: () => ResetPasswordPage(),
        ),
        GetPage(name: MainPage().pageName, page: () => MainPage()),
        GetPage(
          name: CompletedRequestPage().pageName,
          page: () => CompletedRequestPage(),
        ),
      ],
      initialRoute: SplashViewPage().pageName,
    );
  }
}
