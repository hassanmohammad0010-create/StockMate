import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Find_Color.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Row.dart';

class CustomPurchasingContainer extends StatelessWidget {
  const CustomPurchasingContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),

        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 0),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            CustomRow(
              title: 'المادة المطلوبة',
              iconData: Icons.design_services_outlined,
              label: 'شاش طبي 250',
            ),
            CustomRow(
              title: 'الكمية',
              iconData: Icons.inventory_2_outlined,
              label: '250 وحدة',
            ),
            CustomRow(
              title: 'التاريخ',
              iconData: Icons.calendar_month_outlined,
              label: '20-8-2026',
            ),
            CustomRow(
              title: 'صاحب الطلب',
              iconData: Icons.person_outline,
              label: 'مدير المستودع',
            ),
            CustomRow(
              title: 'المورد',
              iconData: Icons.person_outline,
              label: 'شركة فارما',
            ),
            CustomRow(
              title: 'الميزانية المتوقعة',
              iconData: Icons.attach_money,
              label: r'1258$',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.bolt_outlined, size: 30, color: constGray),
                      const SizedBox(width: 6),
                      Text(
                        'الاولوية  ',
                        style: TextStyle(
                          color: constGray,
                          fontFamily: lateef,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: FindColor().findBackgroundColor(word: 'ضروري'),
                    ),
                    child: Text(
                      'ضروري',
                      style: TextStyle(
                        color: FindColor().findFontColorFunction(word: 'ضروري'),
                        fontFamily: lateef,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(endIndent: 16, indent: 16, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.sync_outlined, size: 30, color: constGray),
                      const SizedBox(width: 6),
                      Text(
                        'حالة الطلب',
                        style: TextStyle(
                          color: constGray,
                          fontFamily: lateef,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: FindColor().findBackgroundColor(
                        word: 'بأنتظار موافقتك',
                      ),
                    ),
                    child: Text(
                      'بأنتظار موافقتك',
                      style: TextStyle(
                        color: FindColor().findFontColorFunction(
                          word: 'بأنتظار موافقتك',
                        ),
                        fontFamily: lateef,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
