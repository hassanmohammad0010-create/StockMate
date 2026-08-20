// lib/View/Widget/App/Custom_Adjustment_Container.dart
import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';

class CustomAdjustmentContainer extends StatelessWidget {
  const CustomAdjustmentContainer({
    super.key,
    required this.variantName,
    required this.departmentName,
    required this.quantity,
    required this.typeLabel,
    required this.date,
    required this.reportedByName,
  });

  final String variantName;
  final String departmentName;
  final int quantity;
  final String typeLabel;
  final String date;
  final String reportedByName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              spreadRadius: 0.5,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    variantName,
                    style: TextStyle(
                      color: constColor,
                      fontFamily: lateef,
                      fontSize: 24,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: FindColor().findBackgroundColor(word: typeLabel),
                  ),
                  child: Text(
                    typeLabel,
                    style: TextStyle(
                      color: FindColor().findFontColorFunction(word: typeLabel),
                      fontFamily: lateef,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'القسم: $departmentName',
              style: TextStyle(
                color: constGray,
                fontFamily: lateef,
                fontSize: 20,
              ),
            ),
            Text(
              'الكمية: $quantity',
              style: TextStyle(
                color: constGray,
                fontFamily: lateef,
                fontSize: 20,
              ),
            ),
            Text(
              'بواسطة: $reportedByName',
              style: TextStyle(
                color: constGray,
                fontFamily: lateef,
                fontSize: 20,
              ),
            ),
            Text(
              'التاريخ: $date',
              style: TextStyle(
                color: constGray,
                fontFamily: lateef,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
