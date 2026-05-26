import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Function/Shared/Find_Color.dart';
import 'package:stock_mate_project/Function/Shared/Find_Status.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog.dart';
import 'package:stock_mate_project/core/models/Order_Models.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Details_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

// ignore: must_be_immutable
class DisOrderDetailsPage extends StatelessWidget {
  DisOrderDetailsPage({super.key, required this.order});
  Order order;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.1,
        child: FloatingActionButton(
          backgroundColor: constColor,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
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
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            'النوع',
                            style: TextStyle(
                              color: constGray,
                              fontFamily: lateef,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'اعتيادي',
                        style: TextStyle(fontFamily: lateef, fontSize: 24),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bolt_outlined, size: 24, color: constGray),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text(
                            'الاولوية',
                            style: TextStyle(
                              color: constGray,
                              fontFamily: lateef,
                              fontSize: 24,
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
                          color: FindColor().findBackgroundPriorityColor(
                            orderPriority: order.priority,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          FindStatus().findOrderPriority(
                            orderPriority: order.priority,
                          ),
                          style: TextStyle(
                            fontFamily: lateef,
                            fontSize: 24,
                            color: FindColor().findFontColorPriorityFunction(
                              orderPriority: order.priority,
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
          Expanded(
            child: ListView.builder(
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
          ),
        ],
      ),
    );
  }
}
