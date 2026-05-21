import 'package:flutter/material.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Suppliers_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class SuppliersPage extends StatelessWidget {
  SuppliersPage({super.key});
  final String pageName = '/SuppliersPage';
  final List<String> category = [
    'بارا سيتامول',
    'شاش',
    'قفازات',
    'بارا سيتامول',
    'انسولين',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'الموردين'),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0, bottom: 16),
              itemCount: 6,
              itemBuilder: (context, index) {
                return CustomSuppliersContainer(category: category);
              },
            ),
          ),
        ],
      ),
    );
  }
}
