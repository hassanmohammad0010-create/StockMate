import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Consunble_Inventory_Material_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Fixed_Inventory_Material_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Material_Info_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

// ignore: must_be_immutable
class DisplayFixedInventoryMaterials extends StatelessWidget {
  DisplayFixedInventoryMaterials({super.key});
  final String pageName = '/DisplayFixedInventoryMaterials';
  GetFixedInventoryMaterialController controller = Get.put(
    GetFixedInventoryMaterialController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          GetBuilder<GetFixedInventoryMaterialController>(
            builder: (controller) {
              return controller.fixed == null
                  ? Expanded(child: Center(child: CustomLoadingIndicator()))
                  : controller.fixed!.isEmpty
                  ? Expanded(
                      child: CustomEmptyState(tital: 'لا يوجد مواد لعرضهم....'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        itemCount: controller.fixed!.length,
                        itemBuilder: (context, index) {
                          return MaterialCard(
                            materialItem: controller.fixed![index],
                            onTap: () {
                              Get.to(
                                DisplayMaterialInfoPage(
                                  item: controller.fixed![index],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
