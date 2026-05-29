// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Add_New_Order_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Priority_Choose_Card.dart';

class AddOrdinaryOrderPage extends StatelessWidget {
  const AddOrdinaryOrderPage({super.key});

  final String pageName = "/AddOrdinaryOrderPage";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          CustomAddNewOrderCard(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          CustomPriorityChooseCard(),
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.04,
            ),
            child: Divider(),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
          CustomMainButtom(title: 'تأكيد'),
          SizedBox(height: MediaQuery.of(context).size.height * 0.002),
        ],
      ),
    );
  }
}
