import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/Shared_Widget/Custom_Back_Container.dart';

class DisplayConsumablePage extends StatelessWidget {
  const DisplayConsumablePage({super.key});
  final String pageName = '/DisplayConsumablePage';
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
                  status: 'مستهلكة',
                  expiryDate: '29/8/2006',
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
