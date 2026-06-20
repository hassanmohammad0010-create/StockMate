// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Row.dart';

class InventoryInfoCard extends StatelessWidget {
  const InventoryInfoCard({super.key, required this.item});

  final MaterialItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            ),
          ],
        ),
        child: Column(
          children: [
            CustomRow(title: 'الاسم', iconData: Icons.label_outline, label: item.name),
            CustomRow(title: 'الماركة', iconData: Icons.badge_outlined, label: item.brand),
            CustomRow(title: 'النوع', iconData: Icons.layers_outlined, label: item.type),
            CustomRow(title: 'الصنف', iconData: Icons.dashboard_outlined, label: item.categoryLabel),
            CustomRow(title: 'موقع التخزين', iconData: Icons.place_outlined, label: item.storageLocation),
            CustomRow(
              title: 'الحدود',
              iconData: Icons.swap_vert,
              label: 'الادنى : ${item.minQuantity} | الاقصى : ${item.maxQuantity}',
            ),
          ],
        ),
      ),
    );
  }
}