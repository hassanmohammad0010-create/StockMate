// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< Updated upstream
import 'package:stock_mate_project/Service/App/lock_service.dart';
=======
>>>>>>> Stashed changes
import 'package:stock_mate_project/Service/Boss/Get_urgent_Purchase_Requests_Service.dart';
import 'package:stock_mate_project/core/Function/prompt_manager.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/core/router/app_pages.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

SharedPreferences? tokenSharedPreferences;
SharedPreferences? identitySharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
  tokenSharedPreferences = prefs;
  identitySharedPreferences = prefs;


  const storage = FlutterSecureStorage();
  await storage.deleteAll();


  await dotenv.load(fileName: ".env");

  await PromptManager.initialize();

  // تحقق من حالة القفل قبل تحديد الصفحة الأولى للتطبيق
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
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 250),
          // CustomLoadingIndicator(message: 'جاري تحميل الموردين...'),
          Center(
            child: FloatingActionButton(
              onPressed: () async {
                // ignore: avoid_print
                List<PurchaseRequest> datad =
                    await GetUrgentPurchaseRequestsService()
                        .getUrgentPurchaseRequestsService();
                // ignore: avoid_print
                print(datad[0].requester);
              },
              child: Text('data'),
            ),
          ),
          SizedBox(height: 250),
          // CustomSearchField()
        ],
      ),
    );
  }
}