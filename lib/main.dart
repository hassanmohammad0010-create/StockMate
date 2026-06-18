import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/router/app_pages.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

// SharedPreferences? tokenSharedPreferences;
// SharedPreferences? identitySharedPreferences;
void main() async {
  WidgetsFlutterBinding();
  // tokenSharedPreferences = await SharedPreferences.getInstance();
  // identitySharedPreferences = await SharedPreferences.getInstance();
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
      getPages: AppPages.routes,
      initialRoute: AppRoutes.DepartmentHeadsMainPage,

      //  [
      //   GetPage(name: SplashViewPage().pageName, page: () => SplashViewPage()),
      //   GetPage(name: LoginPage().pageName, page: () => LoginPage()),

      //   GetPage(
      //     name: ResetPasswordPage().pageName,
      //     page: () => ResetPasswordPage(),
      //   ),
      //   GetPage(name: MainPage().pageName, page: () => MainPage()),
      //   GetPage(
      //     name: DepartmentHeadsMainPage().pageName,
      //     page: () => DepartmentHeadsMainPage(),
      //   ),
      //   GetPage(
      //     name: CompletedRequestPage().pageName,
      //     page: () => CompletedRequestPage(),
      //   ),
      //   GetPage(
      //     name: UnderImplementationRequestPage().pageName,
      //     page: () => UnderImplementationRequestPage(),
      //   ),
      //   GetPage(
      //     name: NesseryPurchasingRequestPage().pageName,
      //     page: () => NesseryPurchasingRequestPage(),
      //   ),
      //   GetPage(
      //     name: NesseryDepartmentRequestPage().pageName,
      //     page: () => NesseryDepartmentRequestPage(),
      //   ),
      //   GetPage(
      //     name: ElectronicInventoryPage().pageName,
      //     page: () => ElectronicInventoryPage(),
      //   ),
      //   GetPage(
      //     name: EntryAndExitReportPage().pageName,
      //     page: () => EntryAndExitReportPage(),
      //   ),
      //   GetPage(name: SuppliersPage().pageName, page: () => SuppliersPage()),
      //   GetPage(
      //     name: CreateEmployeeAccountPage().pageName,
      //     page: () => CreateEmployeeAccountPage(),
      //   ),
      //   GetPage(
      //     name: DepartmentHeadsAddNewOrderPage().pageName,
      //     page: () => DepartmentHeadsAddNewOrderPage(),
      //   ),
      //   GetPage(
      //     name: DisplayPurchasingOrderPage().pageName,
      //     page: () => DisplayPurchasingOrderPage(),
      //   ),

      //   GetPage(
      //     name: DepartmentOrdersPage().pageName,
      //     page: () => DepartmentOrdersPage(),
      //   ),
      //   GetPage(
      //     name: AddOrdinaryOrderPage().pageName,
      //     page: () => AddOrdinaryOrderPage(),
      //   ),
      //   GetPage(
      //     name: AddRecurringOrderPage().pageName,
      //     page: () => AddRecurringOrderPage(),
      //   ),
      //   GetPage(name: ReportPage().pageName, page: () => ReportPage()),
      //   GetPage(
      //     name: RecurringConfirmPage().pageName,
      //     page: () => RecurringConfirmPage(),
      //   ),
      //   GetPage(
      //     name: OrdinaryConfirmPage().pageName,
      //     page: () => OrdinaryConfirmPage(),
      //   ),
      //   GetPage(
      //     name: SendPrescriptionPage().pageName,
      //     page: () => SendPrescriptionPage(),
      //   ),
      //   GetPage(name: CartPage().pageName, page: () => CartPage()),

      //   GetPage(name: ArchivePage().pageName, page: () => ArchivePage()),
      //   GetPage(
      //     name: CartArchivePage().pageName,
      //     page: () => CartArchivePage(),
      //   ),
      //   GetPage(
      //     name: PrescriptionArchivePage().pageName,
      //     page: () => PrescriptionArchivePage(),
      //   ),

      //   GetPage(
      //     name: ArchiveDetailsPage().pageName,
      //     page: () => const ArchiveDetailsPage(),
      //   ),
      //   GetPage(
      //     name: NotificationPage().pageName,
      //     page: () => const NotificationPage(),
      //   ),
      // ],
    );
  }
}
