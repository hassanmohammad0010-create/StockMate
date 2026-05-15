import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Find_Color.dart';

// ignore: must_be_immutable
class CustomRequestContainer extends StatelessWidget {
  CustomRequestContainer({
    super.key,
    required this.title,
    required this.state,
    required this.department,
    required this.date,
    required this.amount,
    required this.necessity,
  });
  String title, date, amount, department, state, necessity;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // لون الظل
              blurRadius: 8, // ضبابية الظل
              spreadRadius: 1, // انتشار الظل
              offset: Offset(0, 0), // اتجاه الظل (x, y)
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: constColor,
                    fontFamily: lateef,
                    fontSize: 26,
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: FindColor().findBackgroundColor(word: state),
                  ),
                  child: Text(
                    state,
                    style: TextStyle(
                      color: FindColor().findFontColorFunction(word: state),
                      fontFamily: lateef,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              'صاحب الطلب : $department',
              style: TextStyle(
                color: constGray,
                fontFamily: lateef,
                fontSize: 22,
              ),
            ),
            Text(
              'التاريخ :$date',
              style: TextStyle(
                color: constGray,
                fontFamily: lateef,
                fontSize: 22,
              ),
            ),
            Row(
              children: [
                Text(
                  'الكمية :$amount',
                  style: TextStyle(
                    color: constGray,
                    fontFamily: lateef,
                    fontSize: 22,
                  ),
                ),
                SizedBox(width: 32),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: FindColor().findBackgroundColor(word: necessity),
                  ),
                  child: Text(
                    necessity,
                    style: TextStyle(
                      color: FindColor().findFontColorFunction(word: necessity),
                      fontFamily: lateef,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
