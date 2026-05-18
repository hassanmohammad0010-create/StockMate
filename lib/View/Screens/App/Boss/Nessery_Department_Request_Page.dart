import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Order_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/View/Widget/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';

class NesseryDepartmentRequestPage extends StatelessWidget {
  const NesseryDepartmentRequestPage({super.key});
  final String pageName = '/NesseryDepartmentRequestPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomBackContainer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: CustomHeadContainer(empName: 'طلبات الاقسام الضرورية'),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: 5,
              itemBuilder: (context, index) {
                return CustomRequestContainer(
                  title: 'بارا سيتامول 500 mg ',
                  state: 'بأنتظار موافقتك',
                  department: 'باطنية',
                  date: '19-03-2025',
                  amount: '600',
                  necessity: 'ضروري',
                  onTap: () {
                    Get.to(
                      OrderDetailsPage(
                        order: Order(
                          medicineName: 'medicineName',
                          date: 'date',
                          quantity: 48,
                          status: OrderStatus.suspended,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
