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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.01,
                        vertical: context.screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.business_center_outlined,
                        size: context.screenHeight * 0.045,
                        color: constBlue,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'شركة فارما',
                          style: TextStyle(
                            fontFamily: cairo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'معلومات الاتصال  ',
                          style: TextStyle(
                            fontFamily: lateef,
                            fontSize: 20,
                            color: constGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.01,
                        vertical: context.screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.mark_email_read,
                        size: context.screenHeight * 0.028,
                        color: constBlue,
                      ),
                    ),
                    SizedBox(width: 8),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.01,
                        vertical: context.screenWidth * 0.01,
                      ),
                      decoration: BoxDecoration(
                        color: constLightBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.phone,
                        size: context.screenHeight * 0.028,
                        color: constBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

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
                      fontSize: 18,
                      color: constGray,
                    ),
                  ),
                  Text(
                    'hasnamohammadew@gmail.com',
                    softWrap: true,
                    // overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: lateef,
                      fontSize: 18,
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
