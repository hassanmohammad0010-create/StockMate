// // ignore_for_file: file_names

// import 'package:flutter/material.dart';

// class RejectionBanner extends StatelessWidget {
//   final String reason;

//   const RejectionBanner({super.key, required this.reason});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: const Border(
//           right: BorderSide(color: Color(0xFFDC2626), width: 4),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           // العنوان
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: const [
//               Icon(Icons.cancel_outlined, color: Color(0xFFDC2626), size: 20),
//               SizedBox(width: 8),
//               Text(
//                 'سبب الرفض',
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFFDC2626),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),

//           // النص
//           Text(
//             reason,
//             textAlign: TextAlign.right,
//             style: const TextStyle(
//               fontSize: 13,
//               color: Color(0xFF4B5563),
//               height: 1.6,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class RejectionBanner extends StatelessWidget {
  const RejectionBanner({super.key, required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Align(
        alignment: AlignmentGeometry.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.08,
              height: MediaQuery.of(context).size.height * 0.12,
              decoration: BoxDecoration(
                color: constRed,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cancel_outlined, color: constRed),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text(
                      'سبب الرفض',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: constRed,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  child: Text(
                    reason,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
