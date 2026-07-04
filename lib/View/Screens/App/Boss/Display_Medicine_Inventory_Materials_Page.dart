import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Consunble_Inventory_Material_Controller.dart';
import 'package:stock_mate_project/Controller/Service/Get_Medicine_Inventory_Material_Controller.dart';
import 'package:stock_mate_project/View/Screens/App/Boss/Display_Material_Info_Page.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Material_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

// ignore: must_be_immutable
class DisplayMedicineInventoryMaterials extends StatelessWidget {
  DisplayMedicineInventoryMaterials({super.key});
  final String pageName = '/DisplayMedicineInventoryMaterials';
  GetMedicineInventoryMaterialController controller = Get.put(
    GetMedicineInventoryMaterialController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          GetBuilder<GetMedicineInventoryMaterialController>(
            builder: (controller) {
              return controller.medicine == null
                  ? Expanded(child: Center(child: CustomLoadingIndicator()))
                  : controller.medicine!.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'لا يوجد مواد لعرضهم....',
                          style: TextStyle(fontFamily: cairo, fontSize: 24),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 12, bottom: 12),
                        itemCount: controller.medicine!.length,
                        itemBuilder: (context, index) {
                          return MaterialCard(
                            materialItem: controller.medicine![index],
                            onTap: () {
                              Get.to(
                                DisplayMaterialInfoPage(
                                  item: controller.medicine![index],
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
