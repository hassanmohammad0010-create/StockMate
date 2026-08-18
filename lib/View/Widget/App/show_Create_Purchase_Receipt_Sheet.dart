// lib/View/Widget/App/Create_Purchase_Receipt_Sheet.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_All_Suppliers_Controller.dart';
import 'package:stock_mate_project/Controller/App/Receipt_Item_Form_Data.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

void showCreatePurchaseReceiptSheet({
  required BuildContext context,
  required String purchaseRequestId,
  required List<PurchaseDetailItem> requestItems,
}) {
  final CreatePurchaseReceiptController controller = Get.put(
    CreatePurchaseReceiptController(
      purchaseRequestId: purchaseRequestId,
      requestItems: requestItems,
    ),
  );

  final GetAllSuppliersController suppliersController = Get.put(
    GetAllSuppliersController(),
  );

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                  vertical: context.screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        alignment: Alignment.center,
                        width: context.screenWidth * 0.4,
                        height: context.screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: constLightBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'إنشاء إيصال استلام',
                          style: TextStyle(
                            color: constBlue,
                            fontFamily: cairo,
                            fontSize: context.screenHeight * 0.022,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.02),

                    // ─── المورد ─────────────────────────────
                    Text(
                      'المورد',
                      style: TextStyle(
                        fontFamily: cairo,
                        fontSize: context.screenHeight * 0.018,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.005),
                    GetBuilder<GetAllSuppliersController>(
                      builder: (sc) {
                        if (sc.suppliers == null) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }
                        return Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.supplierId.value,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: sc.suppliers!
                                .map(
                                  (s) => DropdownMenuItem<String>(
                                    value: s.id,
                                    child: Text(
                                      s.name,
                                      style: TextStyle(fontFamily: cairo),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              controller.supplierId.value = value;
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: context.screenHeight * 0.02),

                    // ─── تاريخ الاستلام ──────────────────────
                    Text(
                      'تاريخ الاستلام',
                      style: TextStyle(
                        fontFamily: cairo,
                        fontSize: context.screenHeight * 0.018,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.005),
                    Obx(
                      () => InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                controller.receivingDate.value ??
                                DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            controller.receivingDate.value = picked;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            controller.receivingDate.value == null
                                ? 'اختر التاريخ'
                                : '${controller.receivingDate.value!.year}-${controller.receivingDate.value!.month.toString().padLeft(2, '0')}-${controller.receivingDate.value!.day.toString().padLeft(2, '0')}',
                            style: TextStyle(fontFamily: cairo),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.02),

                    // ─── نوع الدفعة ──────────────────────────
                    Text(
                      'نوع الدفعة',
                      style: TextStyle(
                        fontFamily: cairo,
                        fontSize: context.screenHeight * 0.018,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.005),
                    Obx(
                      () => DropdownButtonFormField<String>(
                        value: controller.type.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'batch', child: Text('دفعة')),
                          DropdownMenuItem(
                            value: 'final_batch',
                            child: Text('دفعة أخيرة'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) controller.type.value = value;
                        },
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.02),

                    // ─── الملاحظات ───────────────────────────
                    Text(
                      'ملاحظات',
                      style: TextStyle(
                        fontFamily: cairo,
                        fontSize: context.screenHeight * 0.018,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.005),
                    TextFormField(
                      controller: controller.notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        hintText: 'ملاحظات إضافية (اختياري)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.02),

                    // ─── الأصناف ──────────────────────────────
                    Text(
                      'بيانات الأصناف',
                      style: TextStyle(
                        fontFamily: cairo,
                        fontSize: context.screenHeight * 0.02,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.01),
                    ...controller.itemsFormData.map(
                      (formData) => _ItemFormCard(formData: formData),
                    ),
                    SizedBox(height: context.screenHeight * 0.02),

                    // ─── صور الإيصال ─────────────────────────
                    Text(
                      'صور الإيصال',
                      style: TextStyle(
                        fontFamily: cairo,
                        fontSize: context.screenHeight * 0.018,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.01),
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ...controller.receiptImages.asMap().entries.map(
                            (entry) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    entry.value,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: -6,
                                  right: -6,
                                  child: GestureDetector(
                                    onTap: () =>
                                        controller.removeImage(entry.key),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.red,
                                      child: Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                _showImageSourceSheet(context, controller),
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: const Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.03),

                    // ─── زر الحفظ ────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: constBlue,
                          padding: EdgeInsets.symmetric(
                            vertical: context.screenHeight * 0.018,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final success = await controller.submit();
                          if (success) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                        child: Text(
                          'حفظ الإيصال',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: cairo,
                            fontSize: context.screenHeight * 0.02,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.screenHeight * 0.02),
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  ).whenComplete(() {
    Get.delete<CreatePurchaseReceiptController>();
  });
}

void _showImageSourceSheet(
  BuildContext context,
  CreatePurchaseReceiptController controller,
) {
  showModalBottomSheet(
    context: context,
    builder: (_) => SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('اختيار من المعرض'),
            onTap: () {
              Navigator.pop(context);
              controller.pickImageFromGallery();
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt_outlined),
            title: const Text('التقاط صورة'),
            onTap: () {
              Navigator.pop(context);
              controller.pickImageFromCamera();
            },
          ),
        ],
      ),
    ),
  );
}

class _ItemFormCard extends StatelessWidget {
  const _ItemFormCard({required this.formData});

  final ReceiptItemFormData formData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: context.screenHeight * 0.015),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formData.item.variant?.variantName ?? 'صنف غير معروف',
            style: TextStyle(
              fontFamily: cairo,
              fontWeight: FontWeight.w700,
              fontSize: context.screenHeight * 0.018,
            ),
          ),
          SizedBox(height: context.screenHeight * 0.01),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: formData.quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'الكمية المستلمة',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: formData.purchasePriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'سعر الشراء',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.screenHeight * 0.01),
          TextFormField(
            controller: formData.batchNumberController,
            decoration: InputDecoration(
              labelText: 'رقم الدفعة (Batch Number)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: context.screenHeight * 0.01),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            formData.manufacturingDate.value ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        formData.manufacturingDate.value = picked;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        formData.manufacturingDate.value == null
                            ? 'تاريخ الإنتاج'
                            : '${formData.manufacturingDate.value!.year}-${formData.manufacturingDate.value!.month.toString().padLeft(2, '0')}-${formData.manufacturingDate.value!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(fontFamily: cairo, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Obx(
                  () => InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            formData.expirationDate.value ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        formData.expirationDate.value = picked;
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        formData.expirationDate.value == null
                            ? 'تاريخ الانتهاء'
                            : '${formData.expirationDate.value!.year}-${formData.expirationDate.value!.month.toString().padLeft(2, '0')}-${formData.expirationDate.value!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(fontFamily: cairo, fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
