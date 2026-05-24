import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class DisplayFixedAssetsPage extends StatelessWidget {
  const DisplayFixedAssetsPage({super.key});
  final String pageName = '/DisplayFixedAssetsPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              itemCount: specialties.length,
              itemBuilder: (context, index) {
                return MedicineCard(
                  medicineName: 'باراسيتامول 500 مج',
                  status: 'ثابتة',
                  expiryDate: '8/6/2065',
                  unit: 'وحدة',
                  currentQuantity: 65,
                  totalQuantity: 500,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
