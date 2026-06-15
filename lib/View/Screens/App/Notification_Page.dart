// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/NotificationController.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Notification_Card.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  final String pageName = '/NotificationPage';

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: constBackgroundColor,
      body: Column(
        children: [
          CustomBackContainer(),
          SizedBox(height: h * 0.01),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.02),
                child: Column(
                  children: [
                    CustomHeadContainer(title: 'الاشعارات'),
                    SizedBox(height: h * 0.01),
                    ...controller.notifications.map((notification) {
                      return CustomNotificationCard(
                        title: notification.title,
                        subtitle: notification.subtitle,
                        statusColor: notification.statusColor,
                        onTap: () {},
                      );
                    }),
                    SizedBox(height: h * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}