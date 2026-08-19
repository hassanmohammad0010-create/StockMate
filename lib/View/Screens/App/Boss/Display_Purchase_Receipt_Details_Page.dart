// lib/View/Screens/App/Boss/Display_Purchase_Receipt_Details_Page.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Purchase_Receipt_Details_Controller.dart';
import 'package:stock_mate_project/Controller/App/Purchase_Receipt_Images_Controller.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/models/Purchase_Receipt_Details_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DisplayPurchaseReceiptDetailsPage extends StatelessWidget {
  DisplayPurchaseReceiptDetailsPage({super.key, required this.receiptId})
    : detailsController = Get.put(
        PurchaseReceiptDetailsController(receiptId: receiptId),
        tag: receiptId,
      ),
      imagesController = Get.put(
        PurchaseReceiptImagesController(receiptId: receiptId),
        tag: receiptId,
      );

  final String receiptId;
  final PurchaseReceiptDetailsController detailsController;
  final PurchaseReceiptImagesController imagesController;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<PurchaseReceiptDetailsController>(tag: receiptId);
          Get.delete<PurchaseReceiptImagesController>(tag: receiptId);
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            CustomBackContainer(),
            CustomHeadContainer(title: 'تفاصيل إيصال الاستلام'),
            Expanded(
              child: Obx(() {
                if (detailsController.isLoading.value) {
                  return const Center(child: CustomLoadingIndicator());
                }

                final PurchaseReceiptDetails? d =
                    detailsController.details.value;

                if (detailsController.hasError.value || d == null) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomEmptyState(tital: 'تعذر تحميل تفاصيل الإيصال'),
                      TextButton(
                        onPressed: detailsController.fetchDetails,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  );
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      // ─── معلومات الإيصال العامة ─────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.02,
                          vertical: context.screenHeight * 0.003,
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.screenWidth * 0.04,
                            vertical: context.screenHeight * 0.015,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 3,
                                blurRadius: 8,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: context.screenHeight * 0.01),
                              _row(
                                context,
                                icon: Icons.business_outlined,
                                title: 'المورّد',
                                value: d.supplier?.name ?? '-',
                              ),
                              _divider(),
                              _row(
                                context,
                                icon: Icons.person_outline,
                                title: 'استلم بواسطة',
                                value: d.receivedBy?.fullName ?? '-',
                              ),
                              _divider(),
                              _row(
                                context,
                                icon: Icons.date_range,
                                title: 'تاريخ الاستلام',
                                value: d.formattedReceivingDate,
                              ),
                              _divider(),
                              _row(
                                context,
                                icon: Icons.category_outlined,
                                title: 'نوع الدفعة',
                                value: d.type.arabicLabel,
                              ),
                              _divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.list_alt_outlined,
                                        size: context.screenHeight * 0.028,
                                        color: constGray,
                                      ),
                                      SizedBox(
                                        width: context.screenWidth * 0.02,
                                      ),
                                      Text(
                                        'الحالة',
                                        style: TextStyle(
                                          color: constGray,
                                          fontFamily: cairo,
                                          fontSize:
                                              context.screenHeight * 0.019,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.screenWidth * 0.04,
                                      vertical: context.screenHeight * 0.005,
                                    ),
                                    decoration: BoxDecoration(
                                      color: FindColor().findBackgroundColor(
                                        word: d.status.arabicLabel,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      d.status.arabicLabel,
                                      style: TextStyle(
                                        fontFamily: cairo,
                                        fontSize: context.screenHeight * 0.019,
                                        fontWeight: FontWeight.w600,
                                        color: FindColor()
                                            .findFontColorFunction(
                                              word: d.status.arabicLabel,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (d.confirmedBy != null) ...[
                                _divider(),
                                _row(
                                  context,
                                  icon: Icons.verified_outlined,
                                  title: 'أكّد بواسطة',
                                  value: d.confirmedBy!.fullName,
                                ),
                              ],
                              if (d.notes != null && d.notes!.isNotEmpty) ...[
                                _divider(),
                                _row(
                                  context,
                                  icon: Icons.note_outlined,
                                  title: 'ملاحظات',
                                  value: d.notes!,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      // ─── الصور المرفقة ───────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.02,
                          vertical: context.screenHeight * 0.01,
                        ),
                        child: _buildImagesCard(context),
                      ),

                      // ─── أصناف الإيصال ────────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.02,
                          vertical: context.screenHeight * 0.01,
                        ),
                        child: _buildItemsCard(context, d),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ─── بطاقة الصور ────────────────────────────────────────────────
  Widget _buildImagesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.image_outlined,
                size: context.screenHeight * 0.026,
                color: constGray,
              ),
              SizedBox(width: context.screenWidth * 0.02),
              Text(
                'الصور المرفقة',
                style: TextStyle(
                  fontFamily: cairo,
                  color: constGray,
                  fontSize: context.screenHeight * 0.019,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: context.screenHeight * 0.015),
          Obx(() {
            if (imagesController.isLoading.value) {
              return const Center(child: CustomLoadingIndicator());
            }

            if (imagesController.hasError.value ||
                imagesController.images.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.screenHeight * 0.01,
                ),
                child: Text(
                  'لا توجد صور مرفقة',
                  style: TextStyle(
                    fontFamily: cairo,
                    color: Colors.grey.shade500,
                  ),
                ),
              );
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: imagesController.images.length,
              itemBuilder: (context, index) {
                final img = imagesController.images[index];
                return GestureDetector(
                  onTap: () =>
                      _openImageViewer(context, imagesController.images, index),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      img.url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return const Center(child: CustomLoadingIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  void _openImageViewer(BuildContext context, List images, int initialIndex) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            PageView.builder(
              controller: PageController(initialPage: initialIndex),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  child: Image.network(
                    images[index].url,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image_outlined,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Get.back(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── بطاقة الأصناف ──────────────────────────────────────────────
  Widget _buildItemsCard(BuildContext context, PurchaseReceiptDetails d) {
    if (d.items.isEmpty) {
      return CustomEmptyState(tital: 'لا توجد أصناف بهذا الإيصال');
    }

    return Column(
      children: d.items.map((item) {
        return Container(
          margin: EdgeInsets.only(bottom: context.screenHeight * 0.01),
          padding: EdgeInsets.all(context.screenWidth * 0.04),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 8,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.variant?.product?.name ?? item.variant?.variantName ?? '-',
                style: TextStyle(
                  fontFamily: cairo,
                  fontWeight: FontWeight.bold,
                  fontSize: context.screenHeight * 0.018,
                ),
              ),
              SizedBox(height: context.screenHeight * 0.008),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الكمية المستلمة',
                    style: TextStyle(fontFamily: cairo, color: constGray),
                  ),
                  Text(
                    '${item.quantity} ${item.variant?.unit?.abbreviation ?? ''}',
                    style: TextStyle(fontFamily: cairo),
                  ),
                ],
              ),
              if (item.hasDiscrepancy) ...[
                SizedBox(height: context.screenHeight * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الفرق عن المتوقع',
                      style: TextStyle(fontFamily: cairo, color: constGray),
                    ),
                    Text(
                      '${item.quantityDiscrepancy}',
                      style: TextStyle(
                        fontFamily: cairo,
                        color: constRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              if (item.batchNumber != null) ...[
                SizedBox(height: context.screenHeight * 0.005),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'رقم الدفعة',
                      style: TextStyle(fontFamily: cairo, color: constGray),
                    ),
                    Text(
                      item.batchNumber!,
                      style: TextStyle(fontFamily: cairo),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _row(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: context.screenHeight * 0.028, color: constGray),
            SizedBox(width: context.screenWidth * 0.02),
            Text(
              title,
              style: TextStyle(
                color: constGray,
                fontFamily: cairo,
                fontSize: context.screenHeight * 0.019,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: cairo,
              fontSize: context.screenHeight * 0.019,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider() => Divider(indent: 16, endIndent: 16, thickness: 0.5);
}
