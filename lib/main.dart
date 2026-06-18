import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_mate_project/Routes/Bindings/App/Cart_Binding.dart';
import 'package:stock_mate_project/core/router/app_pages.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

SharedPreferences? shareprefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialBinding: CartBinding(),
    );
  }
}
