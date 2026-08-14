// lib/View/Widget/App/Custom_Purchasing_Item_Card.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Row.dart';

class CustomPurchasingItemCard extends StatelessWidget {
  const CustomPurchasingItemCard({super.key, required this.item});

  final PurchaseDetailItem item;

  @override
  Widget build(BuildContext context) {
    final String materialName =
        item.variant?.product?.name ?? item.variant?.variantName ?? '-';
    final String unitAbbreviation = item.variant?.unit?.abbreviation ?? '';

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.screenWidth * 0.04,
        vertical: context.screenHeight * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
            title: 'المادة',
            iconData: Icons.design_services_outlined,
            label: materialName,
          ),
          CustomRow(
            title: 'الكمية المطلوبة',
            iconData: Icons.inventory_2_outlined,
            label: '${item.requestedQuantity} $unitAbbreviation',
          ),
          CustomRow(
            title: 'السعر المتوقع',
            iconData: Icons.attach_money,
            label: '${item.estimatedPrice}\$',
          ),
          // ← الكمية المعتمدة/المستلمة تظهر فقط لو متوفرة
          if (item.approvedQuantity != null)
            CustomRow(
              title: 'الكمية المعتمدة',
              iconData: Icons.check_circle_outline,
              label: '${item.approvedQuantity} $unitAbbreviation',
            ),
          if (item.receivedQuantity > 0)
            CustomRow(
              title: 'الكمية المستلمة',
              iconData: Icons.move_to_inbox_outlined,
              label: '${item.receivedQuantity} $unitAbbreviation',
            ),
        ],
      ),
    );
  }
}
