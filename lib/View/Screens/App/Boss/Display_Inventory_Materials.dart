import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Material_Info_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';

class DisplayInventoryMaterials extends StatelessWidget {
  const DisplayInventoryMaterials({super.key});
  final String pageName = '/DisplayInventoryMaterials';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 12, bottom: 12),
              itemCount: allMaterial.length,
              itemBuilder: (context, index) {
                return MaterialCard(
                  materialItem: allMaterial[index],
                  onTap: () {
                    Get.to(DisplayMaterialInfoPage(item: allMaterial[index]));
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
