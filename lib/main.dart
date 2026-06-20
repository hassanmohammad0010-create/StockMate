import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stock_mate_project/Routes/Bindings/App/Cart_Binding.dart';
import 'package:stock_mate_project/core/router/app_pages.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/Service/Auth/Create_Employee_Service.dart';

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
      initialRoute: AppRoutes.DepartmentHeadsMainPage,
      initialBinding: AppBinding(),
    );
  }
}

class HasanServiceTester extends StatelessWidget {
  const HasanServiceTester({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 250),
          Center(
            child: FloatingActionButton(
              onPressed: () async {
                print('1');
                await CreateEmployeeService().createEmployeeService(
                  email: 'email',
                  department: 'department',
                  name: 'name',
                  role: 'z',
                );
              },
              child: Text('data'),
            ),
          ),
        ],
      ),
    );
  }
}
