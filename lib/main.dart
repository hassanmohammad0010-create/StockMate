import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_mate_project/Service/App/lock_service.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_Department_Requests_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_urgent_Purchase_Requests_Service.dart';
import 'package:stock_mate_project/core/Function/prompt_manager.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';
import 'package:stock_mate_project/core/router/app_pages.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

SharedPreferences? shareprefs;
SharedPreferences? tokenSharedPreferences;
SharedPreferences? identitySharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  tokenSharedPreferences = prefs;
  identitySharedPreferences = prefs;
  shareprefs = prefs;

  await shareprefs?.clear();

  await dotenv.load(fileName: ".env");

  await PromptManager.initialize();

  // تحقق من حالة القفل قبل تحديد الصفحة الأولى للتطبيق
  final isLockEnabled = await LockService.instance.isLockEnabled();

  runApp(
    StockMate(
      initialRoute: isLockEnabled
          ? AppRoutes.LockScreen
          : AppRoutes.DepartmentHeadsMainPage,
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

  @override
  final String pageName = '/HasanServiceTester';
  TextEditingController? c = TextEditingController();
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

// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:stock_mate_project/Service/App/lock_service.dart';
// import 'package:stock_mate_project/Service/Boss/Get_All_Department_Requests_Service.dart';
// import 'package:stock_mate_project/core/Function/prompt_manager.dart';
// import 'package:stock_mate_project/core/models/Request_Model.dart';
// import 'package:stock_mate_project/core/router/app_pages.dart';
// import 'package:stock_mate_project/core/router/app_routes.dart';

// SharedPreferences? shareprefs;
// SharedPreferences? tokenSharedPreferences;
// SharedPreferences? identitySharedPreferences;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final stopwatch = Stopwatch()..start();

//   final prefs = await SharedPreferences.getInstance();
//   // ignore: avoid_print
//   print('⏱ SharedPreferences.getInstance: ${stopwatch.elapsedMilliseconds}ms');

//   tokenSharedPreferences = prefs;
//   identitySharedPreferences = prefs;
//   shareprefs = prefs;

//   await shareprefs?.clear();
//   // ignore: avoid_print
//   print('⏱ shareprefs.clear: ${stopwatch.elapsedMilliseconds}ms');

//   await dotenv.load(fileName: ".env");
//   // ignore: avoid_print
//   print('⏱ dotenv.load: ${stopwatch.elapsedMilliseconds}ms');

//   await PromptManager.initialize();
//   // ignore: avoid_print
//   print('⏱ PromptManager.initialize: ${stopwatch.elapsedMilliseconds}ms');

//   // تحقق من حالة القفل قبل تحديد الصفحة الأولى للتطبيق
//   final isLockEnabled = await LockService.instance.isLockEnabled();
//   // ignore: avoid_print
//   print('⏱ LockService.isLockEnabled: ${stopwatch.elapsedMilliseconds}ms');

//   // ignore: avoid_print
//   print('⏱ TOTAL before runApp: ${stopwatch.elapsedMilliseconds}ms');

//   runApp(
//     StockMate(
//       initialRoute: isLockEnabled
//           ? AppRoutes.LockScreen
//           : AppRoutes.DepartmentHeadsMainPage,
//     ),
//   );
// }

// class StockMate extends StatelessWidget {
//   final String initialRoute;

//   const StockMate({super.key, required this.initialRoute});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Stock Mate',
//       locale: Get.deviceLocale,
//       debugShowCheckedModeBanner: false,
//       getPages: AppPages.routes,
//       initialRoute: initialRoute,
//     );
//   }
// }

// class HasanServiceTester extends StatelessWidget {
//   HasanServiceTester({super.key});

//   @override
//   final String pageName = '/HasanServiceTester';
//   TextEditingController? c = TextEditingController();
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 250),
//           // CustomLoadingIndicator(message: 'جاري تحميل الموردين...'),
//           Center(
//             child: FloatingActionButton(
//               onPressed: () async {
//                 // ignore: avoid_print
//                 List<RequestModel> datad = await GetAllRequestService()
//                     .getAllDepartmentRequests();
//                 print(datad[0].requestFrequency.arabicLabel);
//               },
//               child: Text('data'),
//             ),
//           ),
//           SizedBox(height: 250),
//           // CustomSearchField()
//         ],
//       ),
//     );
//   }
// }