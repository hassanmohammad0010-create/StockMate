// ignore_for_file: must_be_immutable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_mate_project/Service/App/lock_service.dart';
import 'package:stock_mate_project/View/Screens/OnBording/On_Bording_App_View.dart';
import 'package:stock_mate_project/core/Function/prompt_manager.dart';
import 'package:stock_mate_project/core/router/app_pages.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/firebase_options.dart';

SharedPreferences? onBordingSharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();

  onBordingSharedPreferences = prefs;

  await dotenv.load(fileName: ".env");

  await PromptManager.initialize();

  final isLockEnabled = await LockService.instance.isLockEnabled();

  runApp(
    StockMate(
      initialRoute: isLockEnabled
          ? AppRoutes.LockScreen
          : AppRoutes.SplashViewPage,
    ),
  );
}

class StockMate extends StatelessWidget {
  final String? initialRoute;

  const StockMate({super.key, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stock Mate',
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: initialRoute,
    );
  }
}

class HasanServiceTester extends StatelessWidget {
  HasanServiceTester({super.key});

  final String pageName = '/HasanServiceTester';
  TextEditingController? c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return OnBordingAppViewPage();
  }
}
