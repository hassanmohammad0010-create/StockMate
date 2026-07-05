import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Find_Color.dart';
import 'package:stock_mate_project/core/models/Request_Model.dart';

// ignore: must_be_immutable
class CustomRequestContainer extends StatelessWidget {
  CustomRequestContainer({
    super.key,
    required this.onTap,
    required this.requestModel,
  });
  RequestModel requestModel;
  VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // لون الظل
                blurRadius: 2, // ضبابية الظل
                spreadRadius: 0.5, // انتشار الظل
                offset: Offset(0, 0), // اتجاه الظل (x, y)
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'طلب جديد',
                    style: TextStyle(
                      color: constColor,
                      fontFamily: lateef,
                      fontSize: 28,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: FindColor().findBackgroundColor(
                        word: requestModel.status.arabicLabel,
                      ),
                    ),
                    child: Text(
                      requestModel.status.arabicLabel,
                      style: TextStyle(
                        color: FindColor().findFontColorFunction(
                          word: requestModel.status.arabicLabel,
                        ),
                        fontFamily: lateef,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                'صاحب الطلب : ${requestModel.departmentName}',
                style: TextStyle(
                  color: constGray,
                  fontFamily: lateef,
                  fontSize: 22,
                ),
              ),
              Text(
                'التاريخ :${requestModel.date.year}-${requestModel.date.month}-${requestModel.date.day}',
                style: TextStyle(
                  color: constGray,
                  fontFamily: lateef,
                  fontSize: 22,
                ),
              ),
              Row(
                children: [
                  Text(
                    'الضرورة  :',
                    style: TextStyle(
                      color: constGray,
                      fontFamily: lateef,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: 32),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: FindColor().findBackgroundColor(
                        word: requestModel.requestType.arabicLabel,
                      ),
                    ),
                    child: Text(
                      requestModel.requestType.arabicLabel,
                      style: TextStyle(
                        color: FindColor().findFontColorFunction(
                          word: requestModel.requestType.arabicLabel,
                        ),
                        fontFamily: lateef,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
