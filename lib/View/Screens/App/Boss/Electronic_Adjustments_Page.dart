// lib/View/Screens/App/Boss/Electronic_Adjustments_Page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Catalog_Variants_Controller.dart';
import 'package:stock_mate_project/Controller/App/Get_Departments_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/DatePicker_Controller.dart';
import 'package:stock_mate_project/Service/Boss/Excel_Report_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_Adjustments_Report_Service.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Date_Field.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/models/Adjustment_Type_Option_Model.dart';
import 'package:stock_mate_project/core/models/Catalog_Variants_Page_Data_Model.dart';
import 'package:stock_mate_project/core/models/Department_Model.dart';
import 'package:stock_mate_project/core/models/Group_By_Option_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

class ElectronicAdjustmentsPage extends StatelessWidget {
  ElectronicAdjustmentsPage({super.key});
  final String pageName = '/ElectronicAdjustmentsPage';

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ✅ نفس الكنترولرات المشتركة تمامًا مع صفحة جرد المخزون
  // (GetX بترجع نفس الـ instance تلقائياً لو مسجلة أصلاً، فمفيش تكرار طلبات)
  final DatePickerController controller = Get.put(DatePickerController());
  final GetDepartmentsController departmentsController = Get.put(
    GetDepartmentsController(),
  );
  final GetCatalogVariantsController variantsController = Get.put(
    GetCatalogVariantsController(),
  );
  final GetAdjustmentsReportService reportService =
      GetAdjustmentsReportService();

  final Rxn<DepartmentModel> selectedDepartment = Rxn<DepartmentModel>();
  final Rxn<CatalogVariant> selectedVariant = Rxn<CatalogVariant>();
  final Rx<AdjustmentTypeOption> selectedAdjustmentType =
      AdjustmentTypeOption.all.first.obs; // "الكل" افتراضيًا
  final Rx<GroupByOption> selectedGroupBy = GroupByOption.all.first.obs;

  Future<void> _onConfirm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (controller.fromDate.value == null || controller.toDate.value == null) {
      customSnackBar(
        title: 'خطأ',
        message: 'الرجاء اختيار الفترة الزمنية بالكامل',
        color: constRed,
        messageColor: constLightRed,
      );
      return;
    }

    if (controller.toDate.value!.isBefore(controller.fromDate.value!)) {
      customSnackBar(
        title: 'خطأ',
        message: 'تاريخ النهاية يجب أن يكون بعد تاريخ البداية',
        color: constRed,
        messageColor: constLightRed,
      );
      return;
    }

    showLoadingDialog();

    final report = await reportService.getReport(
      from: controller.formatDate(controller.fromDate.value),
      to: controller.formatDate(controller.toDate.value),
      departmentId: selectedDepartment.value?.id,
      variantId: selectedVariant.value?.id,
      adjustmentType: selectedAdjustmentType.value.value,
      groupBy: selectedGroupBy.value.value ?? 'day',
    );

    if (report == null) {
      hideLoadingDialog();
      // ❌ في حال الفشل: ApiErrorHandler بيعرض الرسالة المناسبة تلقائياً
      return;
    }

    try {
      final filePath = await ExcelReportService.generateAdjustmentsExcel(
        report: report,
        fromDate: controller.formatDate(controller.fromDate.value),
        toDate: controller.formatDate(controller.toDate.value),
      );

      hideLoadingDialog();

      final isDownloads =
          filePath.contains('Download') || filePath.contains('Downloads');
      final nameOfFile = filePath.split(RegExp(r'[/\\]')).last;

      customSnackBar(
        title: 'تم بنجاح',
        message: isDownloads
            ? 'تم حفظ التقرير في مجلد التنزيلات (Downloads) باسم:\n$nameOfFile'
            : 'تم توليد التقرير بنجاح وحفظه في مجلد التطبيق',
        color: constGreen,
        messageColor: constLightGreen,
      );

      await ExcelReportService.openFile(filePath);
    } catch (e) {
      hideLoadingDialog();
      customSnackBar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء توليد ملف التقرير',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'تقرير التسويات'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.03,
                  vertical: context.screenHeight * 0.005,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: context.screenHeight * 0.015,
                    horizontal: context.screenWidth * 0.03,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 8,
                        offset: Offset(0, 0),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── القسم / المستودع ─────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.02,
                            vertical: context.screenHeight * 0.01,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: context.screenWidth * 0.28,
                            height: context.screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'القسم / المستودع',
                              style: TextStyle(
                                color: constBlue,
                                fontFamily: lateef,
                                fontSize: context.screenHeight * 0.024,
                              ),
                            ),
                          ),
                        ),
                        GetBuilder<GetDepartmentsController>(
                          builder: (dController) {
                            return Obx(
                              () => CustomDropdown<DepartmentModel>(
                                items: dController.department ?? [],
                                labelBuilder: (d) => d.name,
                                label: 'اختر القسم (اختياري)',
                                hint: 'اختر القسم',
                                icon: Icons.apartment_outlined,
                                isLoading: dController.department == null,
                                value: selectedDepartment.value,
                                onChanged: (data) {
                                  selectedDepartment.value = data;
                                },
                              ),
                            );
                          },
                        ),
                        SizedBox(height: context.screenHeight * 0.01),

                        // ─── الصنف ─────────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.02,
                            vertical: context.screenHeight * 0.01,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: context.screenWidth * 0.22,
                            height: context.screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'الصنف',
                              style: TextStyle(
                                color: constBlue,
                                fontFamily: lateef,
                                fontSize: context.screenHeight * 0.024,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => CustomDropdown<CatalogVariant>(
                            items: variantsController.variants,
                            labelBuilder: (v) => v.displayName,
                            label: 'اختر الصنف (اختياري)',
                            hint: 'اختر الصنف',
                            icon: Icons.inventory_2_outlined,
                            searchable: true,
                            isLoading: variantsController.isLoading.value,
                            value: selectedVariant.value,
                            onChanged: (data) {
                              selectedVariant.value = data;
                            },
                          ),
                        ),
                        SizedBox(height: context.screenHeight * 0.01),

                        // ─── نوع التسوية ────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.02,
                            vertical: context.screenHeight * 0.01,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: context.screenWidth * 0.25,
                            height: context.screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'نوع التسوية',
                              style: TextStyle(
                                color: constBlue,
                                fontFamily: lateef,
                                fontSize: context.screenHeight * 0.024,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => CustomDropdown<AdjustmentTypeOption>(
                            items: AdjustmentTypeOption.all,
                            labelBuilder: (t) => t.label,
                            label: 'نوع التسوية',
                            hint: 'اختر نوع التسوية',
                            icon: Icons.build_outlined,
                            clearable: false,
                            value: selectedAdjustmentType.value,
                            onChanged: (data) {
                              if (data != null) {
                                selectedAdjustmentType.value = data;
                              }
                            },
                          ),
                        ),
                        SizedBox(height: context.screenHeight * 0.01),

                        // ─── التجميع (Group By) ─────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.02,
                            vertical: context.screenHeight * 0.01,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: context.screenWidth * 0.25,
                            height: context.screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'التجميع',
                              style: TextStyle(
                                color: constBlue,
                                fontFamily: lateef,
                                fontSize: context.screenHeight * 0.024,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => CustomDropdown<GroupByOption>(
                            items: GroupByOption.all,
                            labelBuilder: (g) => g.label,
                            label: 'التجميع',
                            hint: 'اختر طريقة التجميع',
                            icon: Icons.calendar_view_month_outlined,
                            clearable: false,
                            value: selectedGroupBy.value,
                            onChanged: (data) {
                              if (data != null) {
                                selectedGroupBy.value = data;
                              }
                            },
                          ),
                        ),

                        // ─── من تاريخ ─────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.02,
                            vertical: context.screenHeight * 0.01,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: context.screenWidth * 0.25,
                            height: context.screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'من تاريخ',
                              style: TextStyle(
                                color: constBlue,
                                fontFamily: lateef,
                                fontSize: context.screenHeight * 0.026,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => CustomDateField(
                            label: 'اختيار تاريخ البداية',
                            value: controller.fromDate.value,
                            formattedValue: controller.hasFromDate
                                ? controller.formatDate(
                                    controller.fromDate.value,
                                  )
                                : null,
                            onTap: () => controller.pickFromDate(context),
                            onClear: controller.clearFromDate,
                          ),
                        ),
                        // ─── الى تاريخ ────────────────────────
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.02,
                            vertical: context.screenHeight * 0.01,
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            width: context.screenWidth * 0.25,
                            height: context.screenHeight * 0.05,
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'الى تاريخ',
                              style: TextStyle(
                                color: constBlue,
                                fontFamily: lateef,
                                fontSize: context.screenHeight * 0.028,
                              ),
                            ),
                          ),
                        ),
                        Obx(
                          () => CustomDateField(
                            label: 'اختيار تاريخ النهاية',
                            value: controller.toDate.value,
                            formattedValue: controller.hasToDate
                                ? controller.formatDate(controller.toDate.value)
                                : null,
                            onTap: () => controller.pickToDate(context),
                            onClear: controller.clearToDate,
                          ),
                        ),
                        SizedBox(height: context.screenHeight * 0.01),
                        Align(
                          alignment: AlignmentGeometry.center,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.screenWidth * 0.04,
                              vertical: context.screenHeight * 0.02,
                            ),
                            child: CustomButtom(
                              tital: 'تأكيد',
                              onTap: () => _onConfirm(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
