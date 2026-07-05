import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Consunble_Inventory_Material_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Material_Info_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

// ignore: must_be_immutable
class DisplayConsunbleInventoryMaterials extends StatelessWidget {
  DisplayConsunbleInventoryMaterials({super.key});
  final String pageName = '/DisplayConsunbleInventoryMaterials';
  GetConsunbleInventoryMaterialController controller = Get.put(
    GetConsunbleInventoryMaterialController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          GetBuilder<GetConsunbleInventoryMaterialController>(
            builder: (controller) {
              return controller.consunble == null
                  ? Expanded(child: Center(child: CustomLoadingIndicator()))
                  : controller.consunble!.isEmpty
                  ? Expanded(
                      child: CustomEmptyState(tital: 'لا يوجد مواد لعرضهم....'),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        itemCount: controller.consunble!.length,
                        itemBuilder: (context, index) {
                          return MaterialCard(
                            materialItem: controller.consunble![index],
                            onTap: () {
                              Get.to(
                                DisplayMaterialInfoPage(
                                  item: controller.consunble![index],
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
