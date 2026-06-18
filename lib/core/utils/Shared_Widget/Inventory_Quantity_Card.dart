// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class InventoryQuantityCard extends StatelessWidget {
  final MaterialItem item;
  const InventoryQuantityCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CartController.to.inventoryVersion.value; 
      final ratio = item.maxQuantity == 0 ? 0.0 : item.totalQuantity / item.maxQuantity;
      
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.03),
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
                offset: const Offset(0, 0),
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
                    '${item.totalQuantity}\\${item.maxQuantity}',
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
                  value: ratio,
                  minHeight: context.screenHeight * 0.012,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    ratio < 0.20 ? constRed : constBlue,
                  ),
                ),
              ),
              SizedBox(height: context.screenHeight * 0.008),
              Text(
                '${(ratio * 100).toStringAsFixed(1)} %', 
                style: TextStyle(
                  fontSize: context.screenHeight * 0.016,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: context.screenHeight * 0.008),
            ],
          ),
        ),
      );
    });
  }
}