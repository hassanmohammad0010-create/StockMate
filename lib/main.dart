import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock_mate_project/Service/Boss/Get_All_Department_Requests_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_urgent_Purchase_Requests_Service.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';
import 'package:stock_mate_project/core/router/app_pages.dart';
import 'package:stock_mate_project/Routes/Bindings/App/App_Binding.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

SharedPreferences? shareprefs;

SharedPreferences? tokenSharedPreferences;
SharedPreferences? identitySharedPreferences;

void main() async {
  WidgetsFlutterBinding();
  tokenSharedPreferences = await SharedPreferences.getInstance();
  identitySharedPreferences = await SharedPreferences.getInstance();
  shareprefs = await SharedPreferences.getInstance();

  await shareprefs?.clear();

  runApp(const StockMate());
}

class StockMate extends StatelessWidget {
  const StockMate({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Stock Mate',
      locale: Get.deviceLocale,
      debugShowCheckedModeBanner: false,
      getPages: AppPages.routes,
      initialRoute: AppRoutes.SplashViewPage,
      initialBinding: AppBinding(),
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
