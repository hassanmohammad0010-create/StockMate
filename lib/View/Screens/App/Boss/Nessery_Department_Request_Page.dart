import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Order_Details_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Request_Container.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

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
          CustomHeadContainer(title: 'طلبات الاقسام الضرورية'),
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
                      DisOrderDetailsPage(
                        order: Order(
                          medicineName: 'medicineName',
                          date: 'date',
                          quantity: 56,
                          status: OrderStatus.completed,
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
