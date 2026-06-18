// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/Cart_Controller.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Dialog.dart';

class BatchRowItem extends StatelessWidget {
  const BatchRowItem({super.key, required this.batch, required this.material});

  final MaterialBatch batch;
  final MaterialItem material;

  static String _fmt(int n) => n.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      );

  @override
  Widget build(BuildContext context) {
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
                _fmt(batch.quantity),
                style: TextStyle(
                  fontSize: context.screenHeight * 0.017,
                  fontWeight: FontWeight.w500,
                ),
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
                  style: TextStyle(
                    fontSize: context.screenHeight * 0.013,
                    color: textColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dateStr,
                style: TextStyle(
                  fontSize: context.screenHeight * 0.014,
                  color: Colors.grey,
                ),
              ),
              if (batch.status == BatchStatus.expired) ...[
                SizedBox(width: context.screenWidth * 0.025),
                _DeleteBatchButton(batch: batch, material: material),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DeleteBatchButton extends StatelessWidget {
  const _DeleteBatchButton({required this.batch, required this.material});

  final MaterialBatch batch;
  final MaterialItem material;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => CustomDialog.show(
        type: DialogType.danger,
        title: 'حذف الدفعة',
        message: 'سيتم حذف هذه الدفعة المنتهية نهائياً من المخزون.',
        confirmText: 'حذف',
        onConfirm: () {
          CartController.to.deleteExpiredBatch(material, batch);
          Get.back();
        },
      ),
      child: Container(
        padding: EdgeInsets.all(context.screenHeight * 0.005),
        decoration: BoxDecoration(
          color: constLightRed,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.delete_outline,
          size: context.screenHeight * 0.02,
          color: constRed,
        ),
      ),
    );
  }
}