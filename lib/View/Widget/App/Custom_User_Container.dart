// lib/View/Widget/App/Custom_User_Container.dart
import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';

// ignore: must_be_immutable
class CustomUserContainer extends StatelessWidget {
  CustomUserContainer({super.key, required this.userItem});
  UserItem userItem;

  @override
  Widget build(BuildContext context) {
    final bool isActive = userItem.status == UserStatus.active;

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
                    Stack(
                      clipBehavior: Clip.none,
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
                            Icons.person_outline_rounded,
                            size: context.screenHeight * 0.045,
                            color: constBlue,
                          ),
                        ),
                        // دائرة الحالة (نشط/غير نشط)
                        Positioned(
                          bottom: -2,
                          left: -2,
                          child: Container(
                            width: context.screenHeight * 0.016,
                            height: context.screenHeight * 0.016,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive ? Colors.green : Colors.red,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userItem.fullName,
                          style: TextStyle(
                            fontFamily: cairo,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          userItem.roleLabel,
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
                // شارة الحالة النصية
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.02,
                    vertical: context.screenHeight * 0.005,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    userItem.statusLabel,
                    style: TextStyle(
                      fontFamily: cairo,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (userItem.department != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          userItem.department!.name,
                          style: TextStyle(
                            color: constGray,
                            fontFamily: cairo,
                            fontSize: 16,
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
                            Icons.apartment_rounded,
                            size: context.screenHeight * 0.028,
                            color: constBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                  if (userItem.specialty != null &&
                      userItem.specialty!.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          userItem.specialty!,
                          style: TextStyle(
                            color: constGray,
                            fontFamily: cairo,
                            fontSize: 16,
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
                            Icons.medical_information_outlined,
                            size: context.screenHeight * 0.028,
                            color: constBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        userItem.email ?? '-------',
                        style: TextStyle(
                          color: constGray,
                          fontFamily: cairo,
                          fontSize: 16,
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
                          Icons.mark_email_read,
                          size: context.screenHeight * 0.028,
                          color: constBlue,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        userItem.phone ?? '-------',
                        style: TextStyle(
                          color: constGray,
                          fontFamily: cairo,
                          fontSize: 16,
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
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}
