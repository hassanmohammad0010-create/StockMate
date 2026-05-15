import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomNameContainer extends StatelessWidget {
  const CustomNameContainer({
    super.key,
    required this.empName,
    required this.specializationName,
  });
  final String empName, specializationName;
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
                  Text(
                    specializationName,
                    style: TextStyle(
                      color: constGray,
                      fontFamily: lateef,
                      fontSize: 22,
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


// Card(
//         elevation: 5,
//         child: Stack(
//           children: [
//             Container(
//               alignment: Alignment.centerRight,
//               // width: MediaQuery.of(context).size.width,
//               // height: MediaQuery.of(context).size.height * 0.09,
//               decoration: BoxDecoration(),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40),
//                 child: Column(
//                   children: [
//                     Text(
//                       empName,
//                       style: TextStyle(
//                         color: constColor,
//                         fontFamily: cairo,
//                         fontSize: 22,
//                       ),
//                     ),
//                     Text(
//                       specializationName,
//                       style: TextStyle(
//                         color: constGray,
//                         fontFamily: lateef,
//                         fontSize: 26,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Align(
//               alignment: AlignmentGeometry.centerRight,
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.08,
//                 height: MediaQuery.of(context).size.height * 0.09,
//                 decoration: BoxDecoration(
//                   color: constDarkBlue,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),