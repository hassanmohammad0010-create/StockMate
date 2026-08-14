import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Departments_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Stock_Material_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Create_Department_BottomSheet.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class InventoryPage extends StatelessWidget {
  InventoryPage({super.key});

  GetDepartmentsController getDepartmentsController = Get.put(
    GetDepartmentsController(),
  );

  // ← يفتح شيت إنشاء القسم من الأسفل
  void _openCreateDepartmentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // ← رفعت ارتفاع الشيت (75% من الشاشة) عشان يصير في مساحة كافية
      // تحت حقل الـ dropdown ليظهر العنصر الثالث كامل بدون ما ينقص
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.75,
        child: CreateDepartmentBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constBlue,
        elevation: 8,
        shape: const CircleBorder(),
        onPressed: () => _openCreateDepartmentSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: GetBuilder<GetDepartmentsController>(
        builder: (controller) {
          return controller.department == null
              ? CustomLoadingIndicator()
              : controller.department!.isEmpty
              ? CustomEmptyState(tital: 'لا يوجد اقسام لعرضها')
              : ListView.builder(
                  padding: EdgeInsets.only(
                    top: context.screenHeight * 0.01,
                    bottom: context.screenHeight * 0.01,
                  ),
                  itemCount: controller.department!.length,
                  itemBuilder: (context, index) {
                    return CustomListTile(
                      backgroundColor: constLightBlue,
                      description:
                          controller.department![index].managerName ??
                          'لا يوجد رئيس للقسم',
                      icon: Icons.category,
                      iconColor: constBlue,
                      onTap: () {
                        Get.to(
                          () => DisplayStockMaterialPage(
                            departmentId:
                                controller.department![index].id, // ✅ اتصلحت
                          ),
                        );
                      },
                      title: controller.department![index].name,
                    );
                  },
                );
        },
      ),
    );
  }
}
