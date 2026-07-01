import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:stock_mate_project/Routes/Bindings/App/Department_Orders_Binding.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Completed_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Create_Employee_Account_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Purchasing_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Electronic_Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Entry_And_Exit_Report_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Department_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Nessery_Purchasing_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Suppliers_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Under_Implementation_Request_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Add_Ordinary_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Add_Recurring_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Archive_Details_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Archive_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Cart_Archive_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Cart_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department-Heads_Main_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Add_New_Order_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Home_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Inventory_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Department_Heads_Orders_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/New_Prescription_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Ordinary_Confirm_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Prescriotion_Archive_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Prescriptions_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Processed_Prescriptions_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Recurring_Confirm_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Send_Prescription_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Main_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Notification_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Report_Page.dart';
import 'package:stock_mate_project/View/Screens/App/Setting_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Login_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Reset_Password_Page.dart';
import 'package:stock_mate_project/View/Screens/Auth/Splash_View_Page.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.DepartmentHeadsMainPage,
      page: () => const DepartmentHeadsMainPage(),
    ),
    GetPage(
      name: AppRoutes.AddOrdinaryOrderPage,
      page: () => const AddOrdinaryOrderPage(),
    ),
    GetPage(
      name: AppRoutes.AddRecurringOrderPage,
      page: () => const AddRecurringOrderPage(),
    ),
    GetPage(
      name: AppRoutes.ArchiveDetailsPage,
      page: () => const ArchiveDetailsPage(),
    ),
    GetPage(name: AppRoutes.ArchivePage, page: () => const ArchivePage()),
    GetPage(
      name: AppRoutes.CartArchivePage,
      page: () =>  CartArchivePage(),
    ),
    GetPage(name: AppRoutes.CartPage, page: () => const CartPage()),
    GetPage(
      name: AppRoutes.DepartmentHeadsAddNewOrderPage,
      page: () => DepartmentHeadsAddNewOrderPage(),
    ),
    GetPage(
      name: AppRoutes.DepartmentHeadsHomePage,
      page: () => DepartmentHeadsHomePage(),
    ),
    GetPage(
      name: AppRoutes.DepartmentHeadsInventoryPage,
      page: () => const DepartmentHeadsInventoryPage(),
    ),
    GetPage(
      name: AppRoutes.DepartmentOrdersPage,
      page: () => const DepartmentOrdersPage(),
      binding: DepartmentOrdersBinding(),
    ),
    GetPage(
      name: AppRoutes.OrdinaryConfirmPage,
      page: () => const OrdinaryConfirmPage(),
    ),
    GetPage(
      name: AppRoutes.RecurringConfirmPage,
      page: () => const RecurringConfirmPage(),
    ),
    GetPage(
      name: AppRoutes.PrescriptionArchivePage,
      page: () => PrescriptionArchivePage(),
    ),
    GetPage(
      name: AppRoutes.SendPrescriptionPage,
      page: () => const SendPrescriptionPage(),
    ),
    GetPage(
      name: AppRoutes.PrescriptionsPage,
      page: () =>  PrescriptionsPage(),
    ),
    GetPage(
      name: AppRoutes.NewPrescriptionPage,
      page: () => const NewPrescriptionPage(),
    ),
    GetPage(
      name: AppRoutes.ProcessedPrescriptionsPage,
      page: () => const ProcessedPrescriptionsPage(),
    ),
    GetPage(
      name: AppRoutes.NotificationPage,
      page: () => const NotificationPage(),
    ),
    GetPage(name: AppRoutes.ReportPage, page: () => const ReportPage()),
    GetPage(name: AppRoutes.SettingPage, page: () => const SettingPage()),
    GetPage(name: AppRoutes.MainPage, page: () => const MainPage()),
    GetPage(name: AppRoutes.SplashViewPage, page: () => SplashViewPage()),
    GetPage(name: AppRoutes.LoginPage, page: () => LoginPage()),
    GetPage(name: AppRoutes.ResetPasswordPage, page: () => ResetPasswordPage()),
    GetPage(
      name: AppRoutes.CompletedRequestPage,
      page: () => CompletedRequestPage(),
    ),
    GetPage(
      name: AppRoutes.UnderImplementationRequestPage,
      page: () => UnderImplementationRequestPage(),
    ),
    GetPage(
      name: AppRoutes.NesseryPurchasingRequestPage,
      page: () => const NesseryPurchasingRequestPage(),
    ),
    GetPage(
      name: AppRoutes.NesseryDepartmentRequestPage,
      page: () => const NesseryDepartmentRequestPage(),
    ),
    GetPage(
      name: AppRoutes.ElectronicInventoryPage,
      page: () => const ElectronicInventoryPage(),
    ),
    GetPage(
      name: AppRoutes.EntryAndExitReportPage,
      page: () => EntryAndExitReportPage(),
    ),
    GetPage(name: AppRoutes.SuppliersPage, page: () => SuppliersPage()),
    GetPage(
      name: AppRoutes.CreateEmployeeAccountPage,
      page: () => CreateEmployeeAccountPage(),
    ),

    GetPage(
      name: AppRoutes.DisplayPurchasingOrderPage,
      page: () => const DisplayPurchasingOrderPage(),
    ),
  ];
}
