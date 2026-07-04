import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_All_Suppliers_Controller.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_Suppliers_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';

class SuppliersPage extends StatelessWidget {
  SuppliersPage({super.key});
  final String pageName = '/SuppliersPage';
  GetAllSuppliersController getAllSuppliersController = Get.put(
    GetAllSuppliersController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'الموردين'),
          GetBuilder<GetAllSuppliersController>(
            builder: (controller) {
              return controller.suppliers == null
                  ? Expanded(child: Center(child: CustomLoadingIndicator()))
                  : controller.suppliers!.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Text(
                          'لا يوجد موردين لعرضهم....',
                          style: TextStyle(fontFamily: cairo, fontSize: 24),
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0, bottom: 16),
                        itemCount: controller.suppliers!.length,
                        itemBuilder: (context, index) {
                          return CustomSuppliersContainer(
                            supplierModel: controller.suppliers![index],
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
