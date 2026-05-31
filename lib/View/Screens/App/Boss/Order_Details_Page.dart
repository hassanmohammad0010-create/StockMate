import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Find_Color.dart';
import 'package:stock_mate_project/Function/Shared/Find_Priority.dart';
import 'package:stock_mate_project/Function/Shared/Find_Status.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Details_Recurring_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

// ignore: must_be_immutable
class DisOrderDetailsPage extends StatelessWidget {
  DisOrderDetailsPage({super.key, required this.order});
  Order order;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.15,
        height: MediaQuery.of(context).size.height * 0.1,
        child: FloatingActionButton(
          backgroundColor: constBlue,
          elevation: 8,

          shape: const CircleBorder(),
          onPressed: () {
            showConfirmDialog(onConfirm: () {});
          },
          child: Icon(Icons.check, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'تفاصيل الطلب'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 8,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.grid_view_outlined,
                                    size: 24,
                                    color: constGray,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text(
                                    'النوع',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'اعتيادي',
                                style: TextStyle(
                                  fontFamily: cairo,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Divider(indent: 16, endIndent: 16, thickness: 0.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size: 24,
                                    color: constGray,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text(
                                    'التاريخ',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '26/05/2025',
                                style: TextStyle(
                                  fontFamily: cairo,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Divider(indent: 16, endIndent: 16, thickness: 0.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.bolt_outlined,
                                    size: 24,
                                    color: constGray,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text(
                                    'الاولوية',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: FindColor()
                                      .findBackgroundPriorityColor(
                                        orderPriority: order.priority,
                                      ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  FindOrderPriority().findOrderPriority(
                                    orderPriority: order.priority,
                                  ),
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: FindColor()
                                        .findFontColorPriorityFunction(
                                          orderPriority: order.priority,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Divider(indent: 16, endIndent: 16, thickness: 0.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.list_alt_outlined,
                                    size: 24,
                                    color: constGray,
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Text(
                                    'الحالة',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: FindColor().findBackgroundStausColor(
                                    orderStatus: order.status,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  FindOrderStatus().findOrderStatus(
                                    orderStatus: order.status,
                                  ),
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: FindColor()
                                        .findFontColorStausFunction(
                                          orderStatus: order.status,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(top: 0),
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: CustomRecurringDetailsCard(order: order),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
