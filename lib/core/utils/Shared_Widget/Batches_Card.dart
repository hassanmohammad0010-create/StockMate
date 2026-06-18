// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Material_Info_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/Function/Utilities.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class BatchesCard extends StatelessWidget {
  final MaterialItem item;
  final MaterialInfoController controller;

  const BatchesCard({super.key, required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    return CardWrapper(
      child: Obx(() {
        CartController.to.inventoryVersion.value;
        return Column(
          children: [
            _buildHeader(context),
            if (controller.showBatches.value) ...[
              SizedBox(height: context.screenHeight * 0.015),
              _buildBatchesList(context),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: controller.toggleBatches,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, size: context.screenHeight * 0.028, color: constGray),
              SizedBox(width: context.screenWidth * 0.015),
              Text(
                'توزيع الكمية حسب الصلاحية',
                style: TextStyle(fontSize: context.screenHeight * 0.019, fontFamily: cairo, color: constGray),
              ),
            ],
          ),
          AnimatedRotation(
            turns: controller.showBatches.value ? 0 : 0.5,
            duration: const Duration(milliseconds: 250),
            child: Icon(Icons.keyboard_arrow_up, size: context.screenHeight * 0.026),
          ),
        ],
      ),
    );
  }

  Widget _buildBatchesList(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الكمية', style: TextStyle(fontSize: context.screenHeight * 0.013, color: Colors.grey)),
              Text('تاريخ الانتهاء', style: TextStyle(fontSize: context.screenHeight * 0.013, color: Colors.grey)),
            ],
          ),
        ),
        SizedBox(height: context.screenHeight * 0.008),
        ...item.batches.map((batch) => _buildBatchRow(context, batch)),
      ],
    );
  }

  Widget _buildBatchRow(BuildContext context, MaterialBatch batch) {
    final (bg, textColor) = switch (batch.status) {
      BatchStatus.valid => (constlightGreen, constGreen),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                FormatUtils.formatNumber(batch.quantity),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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
                  style: TextStyle(fontSize: context.screenHeight * 0.013, color: textColor),
                ),
              ),
            ],
          ),
          Text(
            dateStr,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
