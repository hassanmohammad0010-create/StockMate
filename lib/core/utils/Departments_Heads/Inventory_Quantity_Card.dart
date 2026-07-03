// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Quantity_Container.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class InventoryQuantityCard extends StatelessWidget {
  const InventoryQuantityCard({super.key, required this.item});

  final MaterialItem item;

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    return Obx(() {
      CartController.to.inventoryVersion.value;

      final ratio = item.maxQuantity == 0
          ? 0.0
          : item.totalQuantity / item.maxQuantity;

      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: w * 0.03),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.035,
                vertical: h * 0.01,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الكمية المتوفرة',
                        style: TextStyle(
                          fontSize: h * 0.019,
                          fontFamily: cairo,
                          color: constGray,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${item.totalQuantity}\\${item.maxQuantity}',
                        style: TextStyle(
                          fontSize: h * 0.019,
                          fontFamily: cairo,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * 0.015),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: h * 0.012,
                      backgroundColor: const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        ratio < 0.20 ? constRed : constBlue,
                      ),
                    ),
                  ),
                  SizedBox(height: h * 0.008),
                  // toStringAsFixed يمنع ظهور أرقام مثل 75.000000001
                  Text(
                    '${(ratio * 100).toStringAsFixed(1)} %',
                    style: TextStyle(fontSize: h * 0.016),
                  ),
                  SizedBox(height: h * 0.008),
                ],
              ),
            ),
          ),
          SizedBox(height: h * 0.01),
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
        ],
      );
    });
  }
}
