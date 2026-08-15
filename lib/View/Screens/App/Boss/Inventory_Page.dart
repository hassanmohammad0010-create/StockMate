import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Departments_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Stock_Material_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Create_Department_BottomSheet.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_ListTile.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

// ignore: must_be_immutable
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
          if (controller.department == null) {
            return CustomLoadingIndicator();
          }

          // ← RefreshIndicator يلف CustomScrollView كامل بدل ما يلف
          // ListView لحاله، هيك السحب للتحديث يشتغل من أي مكان بالصفحة
          // وحتى لو القائمة فاضية
          return RefreshIndicator(
            onRefresh: controller.fetchDepartments,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (controller.department!.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: CustomEmptyState(tital: 'لا يوجد اقسام لعرضها'),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.only(
                      top: context.screenHeight * 0.01,
                      bottom: context.screenHeight * 0.01,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
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
                                departmentId: controller.department![index].id,
                              ),
                            );
                          },
                          title: controller.department![index].name,
                        );
                      }, childCount: controller.department!.length),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
