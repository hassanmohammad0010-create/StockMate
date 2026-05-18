import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomNameContainer extends StatelessWidget {
  const CustomNameContainer({
    super.key,
    required this.empName,
    this.specializationName,
  });
  final String empName;
  final String? specializationName;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // لون الظل
              blurRadius: 8, // ضبابية الظل
              spreadRadius: 2, // انتشار الظل
              offset: Offset(0, 0), // اتجاه الظل (x, y)
            ),
          ],
        ),
        child: Align(
          alignment: AlignmentGeometry.centerRight,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.09,
                height: MediaQuery.of(context).size.height * 0.09,
                decoration: BoxDecoration(
                  color: constBlue,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // لون الظل
                      blurRadius: 8, // ضبابية الظل
                      spreadRadius: 2, // انتشار الظل
                      offset: Offset(0, 0), // اتجاه الظل (x, y)
                    ),
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.02),
              Column(
                children: [
                  Text(
                    empName,
                    style: TextStyle(
                      color: constColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: cairo,
                      fontSize: 18,
                    ),
                  ),
                  Visibility(
                    visible: specializationName == null ? false : true,
                    child: Text(
                      specializationName!,
                      style: TextStyle(
                        color: constGray,
                        fontFamily: lateef,
                        fontSize: 22,
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
