import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Get_Material_Reletedto_Supplier_Controller.dart';
import 'package:stock_mate_project/core/models/Supplier_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/custom_Head_Card.dart';

class DisplaySuppliersDetailsPage extends StatelessWidget {
  DisplaySuppliersDetailsPage({super.key, required this.supplierModel});

  final SupplierModel supplierModel;

  @override
  Widget build(BuildContext context) {
    final GetSupplierMaterialsController controller = Get.put(
      GetSupplierMaterialsController(supplierId: supplierModel.id),
      tag: supplierModel.id, // حتى ما يتعارض مع مورد تاني لو فتحتي أكتر من صفحة
    );

    return Scaffold(
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'تفاصيل المورد'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.screenWidth * 0.01,
                              vertical: context.screenWidth * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.business_center_outlined,
                              size: context.screenHeight * 0.045,
                              color: constBlue,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.05,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                supplierModel.name,
                                style: TextStyle(
                                  fontFamily: cairo,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                supplierModel.address ?? '-------',
                                style: TextStyle(
                                  fontFamily: lateef,
                                  fontSize: 20,
                                  color: constGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            supplierModel.email ?? '-------',
                            style: TextStyle(
                              color: constGray,
                              fontFamily: cairo,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.screenWidth * 0.01,
                              vertical: context.screenWidth * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.mark_email_read,
                              size: context.screenHeight * 0.028,
                              color: constBlue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            supplierModel.phone,
                            style: TextStyle(
                              color: constGray,
                              fontFamily: cairo,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              horizontal: context.screenWidth * 0.01,
                              vertical: context.screenWidth * 0.01,
                            ),
                            decoration: BoxDecoration(
                              color: constLightBlue,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.phone,
                              size: context.screenHeight * 0.028,
                              color: constBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                ],
              ),
            ),
          ),
          Divider(endIndent: 32, indent: 32),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 12, vertical: 4),
            child: Align(
              alignment: AlignmentGeometry.centerRight,
              child: Text(
                'المواد المرتبطة',
                style: TextStyle(fontFamily: cairo, fontSize: 24),
              ),
            ),
          ),
          // عرض المواد الخاصة بالمورد
          GetBuilder<GetSupplierMaterialsController>(
            tag: supplierModel.id,
            builder: (controller) {
              return controller.materials == null
                  ? Expanded(child: Center(child: CustomLoadingIndicator()))
                  : controller.materials!.isEmpty
                  ? Expanded(
                      child: CustomEmptyState(
                        tital: 'لا يوجد مواد لهذا المورد',
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.02,
                          vertical: context.screenHeight * 0.01,
                        ),
                        itemCount: controller.materials!.length,
                        itemBuilder: (context, index) {
                          final material = controller.materials![index];
                          return Container(
                            margin: EdgeInsets.only(
                              bottom: context.screenHeight * 0.01,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: context.screenWidth * 0.04,
                              vertical: context.screenHeight * 0.015,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  material.unitName,
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: 16,
                                    color: constGray,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      material.materialName,
                                      style: TextStyle(
                                        fontFamily: cairo,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      material.materialType,
                                      style: TextStyle(
                                        fontFamily: lateef,
                                        fontSize: 18,
                                        color: constGray,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
