// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Quantity_Container.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class BatchStatusRow extends StatelessWidget {
  final MaterialItem item;
  const BatchStatusRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CartController.to.inventoryVersion.value;
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.03,
          vertical: context.screenHeight * 0.01,
        ),
        child: Row(
          children: [
            CustomQuantityContainer(
              bg: constlightGreen,
              label: 'صالحة',
              textColor: constGreen,
              value: '${item.validQuantity}',
            ),
            SizedBox(width: context.screenWidth * 0.02),
            CustomQuantityContainer(
              bg: constLightRed,
              label: 'تنتهي قريبا',
              textColor: constRed,
              value: '${item.expiringSoonQuantity}',
            ),
          ],
        ),
      );
    });
  }
}