// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Material_Info_Controller.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Batch_Row_Item.dart';

class InventoryBatchesCard extends StatelessWidget {
  const InventoryBatchesCard({
    super.key,
    required this.item,
    required this.controller,
  });

  final MaterialItem item;
  final MaterialInfoController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 8,
          ),
        ],
      ),
      child: Obx(() {
        CartController.to.inventoryVersion.value;

        return Column(
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
                  AnimatedRotation(
                    turns: controller.showBatches.value ? 0 : 0.5,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_up,
                      size: context.screenHeight * 0.026,
                    ),
                  ),
                ],
              ),
            ),
            if (controller.showBatches.value) ...[
              SizedBox(height: context.screenHeight * 0.015),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.01),
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
              ...item.batches.map(
                (batch) => BatchRowItem(batch: batch, material: item),
              ),
            ],
          ],
        );
      }),
    );
  }
}