import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Material_Info_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Quantity_Container.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
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
                            title: 'الماركة',
                            iconData: Icons.badge_outlined,
                            label: item.brand,
                          ),
                          CustomRow(
                            title: 'النوع',
                            iconData: Icons.layers_outlined,
                            label: item.type,
                          ),
                          CustomRow(
                            title: 'الصنف',
                            iconData: Icons.dashboard_outlined,
                            label: item.categoryLabel,
                          ),
                          CustomRow(
                            title: 'موقع التخزين',
                            iconData: Icons.place_outlined,
                            label: item.storageLocation,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            // ignore: deprecated_member_use
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
                                  fontSize: 16,
                                  fontFamily: cairo,
                                  color: constGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${item.totalQuantity}\\${item.maxQuantity}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: cairo,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: item.totalQuantity / item.maxQuantity,
                              minHeight: 10,
                              backgroundColor: const Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                item.totalQuantity / item.maxQuantity < 0.20
                                    ? constRed // أحمر إذا أقل من 20%
                                    : constBlue, // أزرق إذا 20% أو أكثر
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${(item.totalQuantity / item.maxQuantity) * 100} %',
                          ),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
                  // _fmt(mat.validQuantity), 'صالحة', _validBg, _validText
                  Row(
                    children: [
                      CustomQuantityContainer(
                        bg: constlightGreen,
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
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    child: _buildBatchesCard(item),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Batches Card ─────────────────────────
  Widget _buildBatchesCard(MaterialItem mat) {
    return _card(
      child: Column(
        children: [
          GestureDetector(
            onTap: controller.toggleBatches,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.inventory_2_outlined,
                      size: 24,
                      color: constGray,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'توزيع الكمية حسب الصلاحية',
                      style: TextStyle(
                        fontSize: 16,
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
                    child: const Icon(Icons.keyboard_arrow_up, size: 22),
                  ),
                ),
              ],
            ),
          ),

          // Batch list
          Obx(() {
            if (!controller.showBatches.value) return const SizedBox.shrink();
            return Column(
              children: [
                const SizedBox(height: 12),
                // Column labels
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'الكمية',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                      Text(
                        'تاريخ الانتهاء',
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                ...mat.batches.map((batch) => _buildBatchRow(batch)),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBatchRow(MaterialBatch batch) {
    final (bg, textColor) = switch (batch.status) {
      BatchStatus.valid => (constlightGreen, constGreen),
      BatchStatus.expiringSoon => (constLightRed, constRed),
      BatchStatus.expired => (constLightOrange, constOrange),
    };

    final dateStr =
        '${batch.expiryDate.year}-${batch.expiryDate.month.toString().padLeft(2, '0')}-${batch.expiryDate.day.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Quantity + badge
          Row(
            children: [
              Text(
                _fmt(batch.quantity),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  batch.statusLabel,
                  style: TextStyle(fontSize: 11, color: textColor),
                ),
              ),
            ],
          ),
          // Date
          Text(
            dateStr,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ── Helpers ──────────────────────────────
  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
