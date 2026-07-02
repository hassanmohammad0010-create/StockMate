import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock_mate_project/Routes/Bindings/App/Cart_Binding.dart';
import 'package:stock_mate_project/Service/Auth/OTB_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_All_Department_Requests_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_Consumable_Items_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_urgent_Department_Requests_Service.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20Purchasing%20committee/Main_Page_Heap_of_Purchasing.dart';
import 'package:stock_mate_project/View/Screens/Auth/Splash_View_Page.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';
import 'package:stock_mate_project/core/router/app_pages.dart';

SharedPreferences? shareprefs;

SharedPreferences? tokenSharedPreferences;
SharedPreferences? identitySharedPreferences;

void main() async {
  WidgetsFlutterBinding();
  tokenSharedPreferences = await SharedPreferences.getInstance();
  identitySharedPreferences = await SharedPreferences.getInstance();
  shareprefs = await SharedPreferences.getInstance();
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
      initialRoute: HasanServiceTester().pageName,
      initialBinding: AppBinding(),
    );
  }
}

class HasanServiceTester extends StatelessWidget {
  const HasanServiceTester({super.key});
  final String pageName = '/HasanServiceTester';
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 250),
          Center(
            child: FloatingActionButton(
              onPressed: () async {
                List<MaterialItem> data = await GetConsumableItemsService()
                    .getConsumableItemsService();
                print(data[0].category);
              },
              child: Text('data'),
            ),
          ),
        ],
      ),
    );
  }
}
