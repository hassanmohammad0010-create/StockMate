import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

// ignore: must_be_immutable
class CustomSuppliersContainer extends StatelessWidget {
  CustomSuppliersContainer({super.key, required this.category});
  List<String> category = [
    'بارا سيتامول',
    'شاش',
    'قفازات',
    'بارا سيتامول',
    'انسولين',
  ];
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 8,
              offset: Offset(0, 0),
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business_center_outlined, size: 40),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Text(
                  'شركة فارما',
                  style: TextStyle(
                    fontFamily: cairo,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Text(
              'معلومات الاتصال : ',
              style: TextStyle(
                fontFamily: lateef,
                fontSize: 26,
                color: constGray,
              ),
            ),
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '0937417539',
                    style: TextStyle(
                      fontFamily: lateef,
                      fontSize: 26,
                      color: constGray,
                    ),
                  ),
                  Text(
                    'hasnamohammadew@gmail.com',
                    softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: lateef,
                      fontSize: 26,
                      color: constGray,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            Wrap(
              spacing: 8, // المسافة بين العناصر أفقياً
              runSpacing: 8, // المسافة بين الصفوف عامودياً
              textDirection: TextDirection.rtl, // ← من اليمين لليسار
              children: List.generate(
                category.length, // قائمة البيانات
                (index) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: constLightBlue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    category[index],
                    style: TextStyle(
                      color: constBlue,
                      fontFamily: lateef,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
