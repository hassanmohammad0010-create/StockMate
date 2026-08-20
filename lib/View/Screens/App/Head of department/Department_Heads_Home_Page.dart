// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/DepartmentHeadsMainTabController.dart';
import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Controller/Service/Get_Requests_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Refill_Deliveries_Page.dart';
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

  // ✅ نفس الـ tag المستخدم في DepartmentOrdersPage، حتى نقرأ من نفس
  // الـ instance ونفس البيانات (مش نسخة تانية منفصلة).
  static const String _ordersFilterTag = AppRoutes.DepartmentOrdersPage;

  /// ✅ يضمن وجود MyRequestsController وFilterController بنفس الـ tag
  /// حتى لو المستخدم لسه ما فتحش تاب "الطلبات" فعليًا.
  /// آمن للاستدعاء أكثر من مرة (isRegistered check).
  MyRequestsController _ensureOrdersController() {
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

    if (!Get.isRegistered<MyRequestsController>(tag: _ordersFilterTag)) {
      return Get.put(
        MyRequestsController(filterTag: _ordersFilterTag),
        tag: _ordersFilterTag,
      );
    }
    return Get.find<MyRequestsController>(tag: _ordersFilterTag);
  }

  /// ✅ تعيين الفلتر المناسب ثم الانتقال لتاب الطلبات (index 2).
  /// نستدعي _ensureOrdersController() هنا صراحةً (بدل الاعتماد فقط على
  /// استدعاء build) حتى نضمن أن FilterController موجود ومضبوط
  /// *قبل* أي محاولة قراءة له من CustomFilterBar عند الانتقال،
  /// بغض النظر عن توقيت rebuild الصفحة.
  void _goToOrdersTab(String filterValue) {
    final FilterController filterCtrl =
        Get.isRegistered<FilterController>(tag: _ordersFilterTag)
        ? Get.find<FilterController>(tag: _ordersFilterTag)
        : Get.put<FilterController>(
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

    filterCtrl.setFilter(filterValue);

    // ✅ ننتقل بعد فريم واحد لضمان أن أي Obx يقرأ selectedFilter
    // (مثل CustomFilterBar) يكون استلم القيمة الجديدة قبل ظهور التاب.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainTabController.tabController.animateTo(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final MyRequestsController ordersController = _ensureOrdersController();

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Obx(() {
        final String? name = getNameRollOfUserController.name.value;
        final String? role = getNameRollOfUserController.role.value;
        final String? departmentName =
            getNameRollOfUserController.departmentName.value;

        // ✅ قراءة الأعداد جوّه الـ Obx حتى تتحدث الكاردات تلقائيًا
        // بمجرد وصول بيانات الطلبات من الـ API.
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
                                title: 'طلبات قيد التنفيذ',
                                buttonColor: constBlue,
                                buttonTitle: 'عرض التفاصيل',
                                onTap: () => _goToOrdersTab('قيد التنفيذ'),
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
                                onTap: () => _goToOrdersTab('بانتظار الموافقة'),
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
                              CustomListTile(
                                backgroundColor: constLightBlue,
                                description: 'عرض تفاصيل (الطلبات الواصلة)',
                                icon: Icons.local_shipping_outlined,
                                iconColor: constBlue,
                                onTap: () {
                                  Get.to(() => const RefillDeliveriesPage());
                                },
                                title: 'الطلبات الواصلة',
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
