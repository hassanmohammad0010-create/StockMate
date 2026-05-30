// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Add_New_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Recurring_Choose_Card.dart';

class AddRecurringOrderPage extends StatelessWidget {
  const AddRecurringOrderPage({super.key});

  final String pageName = "/AddRecurringOrderPage";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          CustomAddNewOrderCard(order: OrderItem()), // ← مرر order جديد
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          CustomRecurringChooseCard(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Divider(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          CustomMainButtom(title: 'تأكيد',color: constBlue,fontcolor: Colors.white, onPressed: (){}),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
        ],
      ),
    );
  }
}
