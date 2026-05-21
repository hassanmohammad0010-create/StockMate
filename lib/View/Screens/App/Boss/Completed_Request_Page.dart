import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:stock_mate_project/Controller/Logic/Toggle_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Order_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/core/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/Shared_Widget/Custom_Toggle_Buttom.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class CompletedRequestPage extends StatelessWidget {
  CompletedRequestPage({super.key});
  final String pageName = '/CompletedRequestPage';
  final ToggleController controller = Get.put(
    ToggleController(),
    tag: 'CompletedRequestPage',
  );
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Get.delete<ToggleController>(
            tag: 'CompletedRequestPage',
          ); // ← احذفه عند الخروج
        }
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomBackContainer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: AlignmentGeometry.centerRight,
                child: CustomToggleButtom(
                  first: 'اقسام',
                  second: 'شراء',
                  controller: controller,
                ),
              ),
            ),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: controller.pageController,
                onPageChanged: (index) =>
                    controller.selectedIndex.value = index,
                children: [
                  ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return CustomRequestContainer(
                        title: 'بارا سيتامول 500 mg ',
                        state: 'تم الانجاز',
                        department: 'باطنية',
                        date: '19-03-2025',
                        amount: '600',
                        necessity: 'عادي',
                        onTap: () {
                          Get.to(
                            OrderDetailsPage(
                              order: Order(
                                medicineName: 'medicineName',
                                date: 'date',
                                quantity: 48,
                                status: OrderStatus.completed,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return CustomRequestContainer(
                        title: 'بارا سيتامول 500 mg ',
                        state: 'تم الانجاز',
                        department: 'باطنية',
                        date: '19-03-2025',
                        amount: '700',
                        necessity: 'عادي',
                        onTap: () {
                          Get.to(
                            OrderDetailsPage(
                              order: Order(
                                medicineName: 'medicineName',
                                date: 'date',
                                quantity: 48,
                                status: OrderStatus.completed,
                              ),
                            ),
                          );
                        },
                      );
                    },
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
