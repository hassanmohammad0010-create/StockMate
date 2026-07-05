import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/Function/Find_Priority.dart';
import 'package:stock_mate_project/core/Function/Find_Status.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Version_Custom_Recurring_Details_Card.dart';

// ignore: must_be_immutable
class DisOrderDetailsPage extends StatelessWidget {
  DisOrderDetailsPage({super.key, required this.requestModel});
  // Order order;
  RequestModel requestModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: requestModel.status == RequestStatus.pending
          ? SizedBox(
              width: context.screenWidth * 0.15,
              height: context.screenHeight * 0.1,
              child: FloatingActionButton(
                backgroundColor: constBlue,
                elevation: 8,
                shape: const CircleBorder(),
                onPressed: () {
                  showConfirmDialog(onConfirm: () {}, sub: '', tital: '');
                },
                child: Icon(Icons.check, color: Colors.white),
              ),
            )
          : null,
      body: Column(
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'تفاصيل الطلب'),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.screenWidth * 0.02,
                      vertical: context.screenHeight * 0.003,
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.04,
                        vertical: context.screenHeight * 0.015,
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
                          SizedBox(height: context.screenHeight * 0.01),
                          // ─── النوع ───────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: context.screenHeight * 0.028,
                                    color: constGray,
                                  ),
                                  SizedBox(width: context.screenWidth * 0.02),
                                  Text(
                                    ' القسم',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                requestModel.departmentName,
                                style: TextStyle(
                                  fontFamily: cairo,
                                  fontSize: context.screenHeight * 0.019,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.screenHeight * 0.01),
                          Divider(indent: 16, endIndent: 16, thickness: 0.5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.grid_view_outlined,
                                    size: context.screenHeight * 0.028,
                                    color: constGray,
                                  ),
                                  SizedBox(width: context.screenWidth * 0.02),
                                  Text(
                                    'النوع',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                requestModel.requestFrequency.arabicLabel,

                                style: TextStyle(
                                  fontFamily: cairo,
                                  fontSize: context.screenHeight * 0.019,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.screenHeight * 0.01),
                          Divider(indent: 16, endIndent: 16, thickness: 0.5),
                          // ─── التاريخ ──────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.date_range,
                                    size: context.screenHeight * 0.028,
                                    color: constGray,
                                  ),
                                  SizedBox(width: context.screenWidth * 0.02),
                                  Text(
                                    'التاريخ',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${requestModel.date.year}-${requestModel.date.month}-${requestModel.date.day}',
                                style: TextStyle(
                                  fontFamily: cairo,
                                  fontSize: context.screenHeight * 0.019,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.screenHeight * 0.01),
                          Divider(indent: 16, endIndent: 16, thickness: 0.5),
                          // ─── الأولوية ─────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.bolt_outlined,
                                    size: context.screenHeight * 0.028,
                                    color: constGray,
                                  ),
                                  SizedBox(width: context.screenWidth * 0.02),
                                  Text(
                                    'الاولوية',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.screenWidth * 0.04,
                                  vertical: context.screenHeight * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: FindColor()
                                      .findBackgroundPriorityColor(
                                        requestPriority:
                                            requestModel.requestType,
                                      ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  FindRequestPriority().findRequestPriority(
                                    requestPriority: requestModel.requestType,
                                  ),
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: context.screenHeight * 0.019,
                                    fontWeight: FontWeight.w600,
                                    color: FindColor()
                                        .findFontColorPriorityFunction(
                                          requestPriority:
                                              requestModel.requestType,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: context.screenHeight * 0.01),
                          Divider(indent: 16, endIndent: 16, thickness: 0.5),
                          // ─── الحالة ───────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.list_alt_outlined,
                                    size: context.screenHeight * 0.028,
                                    color: constGray,
                                  ),
                                  SizedBox(width: context.screenWidth * 0.02),
                                  Text(
                                    'الحالة',
                                    style: TextStyle(
                                      color: constGray,
                                      fontFamily: cairo,
                                      fontSize: context.screenHeight * 0.019,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.screenWidth * 0.04,
                                  vertical: context.screenHeight * 0.005,
                                ),
                                decoration: BoxDecoration(
                                  color: FindColor().findBackgroundStausColor(
                                    requestStatus: requestModel.status,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  FindREquestStatus().findRequestStatus(
                                    requestStatus: requestModel.status,
                                  ),
                                  style: TextStyle(
                                    fontFamily: cairo,
                                    fontSize: context.screenHeight * 0.019,
                                    fontWeight: FontWeight.w600,
                                    color: FindColor()
                                        .findFontColorStausFunction(
                                          requestStatus: requestModel.status,
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
                    itemCount: requestModel.items.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.screenWidth * 0.02,
                          vertical: context.screenHeight * 0.005,
                        ),
                        child: VersionCustomRecurringDetailsCard(
                          requestItemModel: requestModel.items[index],
                        ),
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
