// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentHeadsMainTabController.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Controller/Service/Unified_Requests_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Name_Container.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class DepartmentHeadsHomePage extends StatelessWidget {
  DepartmentHeadsHomePage({super.key});

  final GetNameRollOfUserController getNameRollOfUserController = Get.find();

  final DepartmentHeadsMainTabController mainTabController =
      Get.find<DepartmentHeadsMainTabController>();

  static const String _ordersFilterTag = AppRoutes.DepartmentOrdersPage;

  UnifiedRequestsController _ensureOrdersController() {
    if (!Get.isRegistered<FilterController>(tag: _ordersFilterTag)) {
      Get.put<FilterController>(
        FilterController()..initFilters([
          'الكل',
          'معلق',
          'منجز',
          'طلبات مستلمة',
          'بانتظار الموافقة',
          'قيد التنفيذ',
          'الطلبات الدورية',
          'مرفوض',
        ]),
        tag: _ordersFilterTag,
      );
    }

    if (!Get.isRegistered<UnifiedRequestsController>(tag: _ordersFilterTag)) {
      return Get.put(
        UnifiedRequestsController(filterTag: _ordersFilterTag),
        tag: _ordersFilterTag,
      );
    }
    return Get.find<UnifiedRequestsController>(tag: _ordersFilterTag);
  }

  void _goToOrdersTab(String filterValue) {
    final FilterController filterCtrl =
        Get.isRegistered<FilterController>(tag: _ordersFilterTag)
        ? Get.find<FilterController>(tag: _ordersFilterTag)
        : Get.put<FilterController>(
            FilterController()..initFilters([
              'الكل',
              'بانتظار التأكيد',
              'بانتظار موافقة المشفى',
              'بانتظار موافقة المدير',
              'قيد التحضير',
              'منجز جزئي',
              'منجز',
              'مرفوض',
              'ملغي',
              'الطلبات الدورية',
            ]),
            tag: _ordersFilterTag,
          );

    filterCtrl.setFilter(filterValue);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainTabController.tabController.animateTo(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final UnifiedRequestsController ordersController =
        _ensureOrdersController();

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Obx(() {
        final String? name = getNameRollOfUserController.name.value;
        final String? role = getNameRollOfUserController.role.value;
        final String? departmentName =
            getNameRollOfUserController.departmentName.value;

        final int completedCount = ordersController.completedCount;
        final int inProgressCount = ordersController.inProgressCount;
        final int pendingApprovalCount = ordersController.pendingApprovalCount;
        final int rejectedCount = ordersController.rejectedCount;

        return (name == null || departmentName == null)
            ? CustomLoadingIndicator()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    CustomNameContainer(
                      empName: 'د. $name',
                      specializationName: 'رئيس قسم $departmentName',
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: w * 0.02),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CustomCard(
                                icon: Icon(
                                  Icons.check,
                                  size: 30,
                                  color: constGreen,
                                ),
                                iconBackgroundColor: constLightGreen,
                                number: '$completedCount',
                                title: 'طلبات منجزة',
                                buttonColor: constGreen,
                                buttonTitle: 'عرض التفاصيل',
                                onTap: () => _goToOrdersTab('منجز'),
                              ),
                              CustomCard(
                                icon: Icon(
                                  Icons.more_time,
                                  size: 30,
                                  color: constBlue,
                                ),
                                iconBackgroundColor: constLightBlue,
                                number: '$inProgressCount',
                                title: 'طلبات قيد التحضير',
                                buttonColor: constBlue,
                                buttonTitle: 'عرض التفاصيل',
                                onTap: () => _goToOrdersTab('قيد التحضير'),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CustomCard(
                                icon: Icon(
                                  Icons.warning_amber_rounded,
                                  size: 30,
                                  color: constOrange,
                                ),
                                iconBackgroundColor: constLightOrange,
                                number: '$pendingApprovalCount',
                                title: 'بانتظار الموافقة',
                                buttonColor: constOrange,
                                buttonTitle: 'عرض التفاصيل',
                                onTap: () =>
                                    _goToOrdersTab('بانتظار موافقة المشفى'),
                              ),
                              CustomCard(
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  size: 30,
                                  color: constRed,
                                ),
                                iconBackgroundColor: constLightRed,
                                number: '$rejectedCount',
                                title: 'طلبات مرفوضة',
                                buttonColor: constRed,
                                buttonTitle: 'عرض التفاصيل',
                                onTap: () => _goToOrdersTab('مرفوض'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: h * 0.01),
                    Divider(
                      endIndent: w * 0.03,
                      indent: w * 0.03,
                      color: constGray,
                    ),
                    role == 'department_manager'
                        ? Column(
                            children: [
                              Align(
                                alignment: AlignmentGeometry.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: w * 0.05),
                                  child: Text(
                                    'المرضى / السلة',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: cairo,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: h * 0.01),
                              CustomListTile(
                                backgroundColor: constLightBlue,
                                description: 'معاينة المرضى',
                                icon: Icons.person_outline,
                                iconColor: constBlue,
                                onTap: () {
                                  Get.toNamed(AppRoutes.PatientsPage);
                                },
                                title: 'المرضى',
                              ),
                              CustomListTile(
                                backgroundColor: constLightBlue,
                                description:
                                    'عرض تفاصيل المواد اليومية المطلوبة',
                                icon: Icons.shopping_cart,
                                iconColor: constBlue,
                                onTap: () {
                                  Get.toNamed(AppRoutes.CartPage);
                                },
                                title: 'السلة',
                              ),
                              CustomListTile(
                                backgroundColor: constLightBlue,
                                description:
                                    'عرض تفاصيل المتلفات (التسويات والإتلاف)',
                                icon: Icons.inventory_2_outlined,
                                iconColor: constBlue,
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.InventoryAdjustmentsPage,
                                  );
                                },
                                title: 'المتلفات',
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              Align(
                                alignment: AlignmentGeometry.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: w * 0.05),
                                  child: Text(
                                    'الوصفات الطبية',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: cairo,
                                      fontSize: 28,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: h * 0.01),
                              CustomListTile(
                                backgroundColor: constLightBlue,
                                description:
                                    'الوصفات الطبية الجديدة المرسلة من الأطباء',
                                icon: Icons.description_outlined,
                                iconColor: constBlue,
                                onTap: () {
                                  Get.toNamed(AppRoutes.PrescriptionsPage);
                                },
                                title: 'الوصفات الطبية الجديدة',
                              ),
                              CustomListTile(
                                backgroundColor: constLightBlue,
                                description:
                                    'عرض تفاصيل المتلفات (التسويات والإتلاف)',
                                icon: Icons.inventory_2_outlined,
                                iconColor: constBlue,
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.InventoryAdjustmentsPage,
                                  );
                                },
                                title: 'المتلفات',
                              ),
                            ],
                          ),
                    SizedBox(height: h * 0.01),
                  ],
                ),
              );
      }),
    );
  }
}
