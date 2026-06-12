import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Purchasing_Container.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DisplayPurchasingOrderPage extends StatelessWidget {
  const DisplayPurchasingOrderPage({super.key});
  final String pageName = '/DisplayPurchasingOrderPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: constBlue,
        elevation: 8,
        shape: const CircleBorder(),
        onPressed: () {
          showConfirmDialog(onConfirm: () {});
        },
        child: Icon(Icons.check, color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'معلومات الطلب'),
          CustomPurchasingContainer(),
        ],
      ),
    );
  }
}
