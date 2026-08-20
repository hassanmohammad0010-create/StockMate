// lib/View/Widget/App/Custom_Purchase_Receipt_Card.dart
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/models/Purchase_Receipts_Page_Data_Model.dart';

class CustomPurchaseReceiptCard extends StatelessWidget {
  const CustomPurchaseReceiptCard({
    super.key,
    required this.receipt,
    required this.onTap,
  });

  final PurchaseReceiptItem receipt;
  final VoidCallback onTap;

  String get _statusLabel => receipt.status.arabicLabel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.02,
          vertical: context.screenHeight * 0.005,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.screenWidth * 0.04,
          vertical: context.screenHeight * 0.015,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(context.screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: constLightBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: constBlue,
                    size: context.screenHeight * 0.026,
                  ),
                ),
                SizedBox(width: context.screenWidth * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.type.arabicLabel,
                      style: TextStyle(
                        fontFamily: cairo,
                        fontWeight: FontWeight.w600,
                        fontSize: context.screenHeight * 0.018,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      receipt.formattedReceivingDate,
                      style: TextStyle(
                        fontFamily: cairo,
                        color: constGray,
                        fontSize: context.screenHeight * 0.015,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.03,
                    vertical: context.screenHeight * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: FindColor().findBackgroundColor(word: _statusLabel),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontFamily: cairo,
                      fontSize: context.screenHeight * 0.015,
                      color: FindColor().findFontColorFunction(
                        word: _statusLabel,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.screenWidth * 0.01),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: context.screenHeight * 0.016,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
