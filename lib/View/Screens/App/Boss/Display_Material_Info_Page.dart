import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Material_Info_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Quantity_Container.dart';
import 'package:stock_mate_project/core/models/New_MaterialItem.dart';

import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Row.dart';

// ignore: must_be_immutable
class DisplayMaterialInfoPage extends StatelessWidget {
  DisplayMaterialInfoPage({super.key, required this.item});
  MaterialItem item;
  final MaterialInfoController controller = Get.put(MaterialInfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.03,
                      vertical: context.screenHeight * 0.01,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.035,
                        vertical: context.screenHeight * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          CustomRow(
                            title: 'الاسم',
                            iconData: Icons.label_outline,
                            label: item.name,
                          ),
                          CustomRow(
                            title: 'اسم الصنف',
                            iconData: Icons.inventory_2_outlined,
                            label: item.variantName,
                          ),
                          CustomRow(
                            title: 'رمز الصنف (SKU)',
                            iconData: Icons.qr_code_2_outlined,
                            label: item.sku.isEmpty ? '---' : item.sku,
                          ),
                          CustomRow(
                            title: 'الصنف',
                            iconData: Icons.dashboard_outlined,
                            label: item.categoryLabel,
                          ),
                          if (item.subCategoryLabel != null)
                            CustomRow(
                              title: 'الفئة الفرعية',
                              iconData: Icons.category_outlined,
                              label: item.subCategoryLabel!,
                            ),
                          CustomRow(
                            title: 'الوحدة',
                            iconData: Icons.straighten_outlined,
                            label: item.unit?.name ?? '---',
                          ),
                          CustomRow(
                            title: 'الحدود ',
                            iconData: Icons.swap_vert,
                            label:
                                'الادنى : ${item.minQuantity} | الاقصى : ${item.maxQuantity}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.03,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.035,
                        vertical: context.screenHeight * 0.01,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الكمية المتوفرة',
                                style: TextStyle(
                                  fontSize: context.screenHeight * 0.019,
                                  fontFamily: cairo,
                                  color: constGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${item.totalQuantity}\\${item.maxQuantity} ${item.unit?.abbreviation ?? ''}',
                                style: TextStyle(
                                  fontSize: context.screenHeight * 0.019,
                                  fontFamily: cairo,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.screenHeight * 0.015),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: item.fillRatio,
                              minHeight: context.screenHeight * 0.012,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                item.isBelowMinimum ? constRed : constBlue,
                              ),
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.008),
                          Text(
                            '${(item.fillRatio * 100).toStringAsFixed(0)} %',
                            style: TextStyle(
                              fontSize: context.screenHeight * 0.016,
                            ),
                          ),
                          if (item.isBelowMinimum) ...[
                            SizedBox(height: context.screenHeight * 0.006),
                            Text(
                              'الكمية أقل من الحد الأدنى المسموح',
                              style: TextStyle(
                                fontSize: context.screenHeight * 0.015,
                                color: constRed,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          SizedBox(height: context.screenHeight * 0.008),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CustomQuantityContainer(
                        bg: constLightGreen,
                        label: 'صالحة',
                        textColor: constGreen,
                        value: '${item.validQuantity}',
                      ),
                      CustomQuantityContainer(
                        bg: constLightRed,
                        label: 'تنتهي قريبا',
                        textColor: constRed,
                        value: '${item.expiringSoonQuantity}',
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.screenWidth * 0.02,
                      context.screenHeight * 0.01,
                      context.screenWidth * 0.02,
                      context.screenHeight * 0.02,
                    ),
                    child: _buildBatchesCard(context, item),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchesCard(BuildContext context, MaterialItem mat) {
    return _card(
      context: context,
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.toggleBatches,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: context.screenHeight * 0.028,
                      color: constGray,
                    ),
                    SizedBox(width: context.screenWidth * 0.015),
                    Text(
                      'توزيع الكمية حسب الصلاحية',
                      style: TextStyle(
                        fontSize: context.screenHeight * 0.019,
                        fontFamily: cairo,
                        color: constGray,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => AnimatedRotation(
                    turns: controller.showBatches.value ? 0 : 0.5,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size: context.screenHeight * 0.026,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            if (!controller.showBatches.value) return const SizedBox.shrink();
            if (mat.batches.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: context.screenHeight * 0.015),
                child: Text(
                  'لا توجد دفعات مسجلة',
                  style: TextStyle(color: Colors.grey.shade500),
                ),
              );
            }
            return Column(
              children: [
                SizedBox(height: context.screenHeight * 0.015),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الكمية',
                        style: TextStyle(
                          fontSize: context.screenHeight * 0.013,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'تاريخ الانتهاء',
                        style: TextStyle(
                          fontSize: context.screenHeight * 0.013,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.screenHeight * 0.008),
                ...mat.batches.map((batch) => _buildBatchRow(context, batch)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBatchRow(BuildContext context, MaterialBatch batch) {
    final (bg, textColor) = switch (batch.status) {
      BatchStatus.valid => (constLightGreen, constGreen),
      BatchStatus.expiringSoon => (constLightRed, constRed),
      BatchStatus.expired => (constLightOrange, constOrange),
    };

    final dateStr =
        '${batch.expiryDate.year}-${batch.expiryDate.month.toString().padLeft(2, '0')}-${batch.expiryDate.day.toString().padLeft(2, '0')}';

    return Container(
      margin: EdgeInsets.only(bottom: context.screenHeight * 0.01),
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.03,
        vertical: context.screenHeight * 0.012,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _fmt(batch.quantity),
                    style: TextStyle(
                      fontSize: context.screenHeight * 0.017,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: context.screenWidth * 0.02),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.025,
                      vertical: context.screenHeight * 0.004,
                    ),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      batch.statusLabel,
                      style: TextStyle(
                        fontSize: context.screenHeight * 0.013,
                        color: textColor,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: context.screenHeight * 0.014,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (batch.batchNumber.isNotEmpty) ...[
            SizedBox(height: context.screenHeight * 0.004),
            Text(
              'رقم الدفعة: ${batch.batchNumber}',
              style: TextStyle(
                fontSize: context.screenHeight * 0.012,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _card({required BuildContext context, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: Offset(0, 0),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: child,
    );
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
