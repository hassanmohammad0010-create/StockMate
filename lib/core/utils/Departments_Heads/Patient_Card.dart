// // // ignore_for_file: file_names, deprecated_member_use

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:stock_mate_project/Constant/Const.dart';
// // import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Patients_Details_Page.dart';
// // import 'package:stock_mate_project/core/models/Patient_Model.dart';

// // class PatientCard extends StatelessWidget {
// //   final PatientModel patient;
// //   final int queueNumber; // ترتيب المريض في الطابور

// //   const PatientCard({
// //     super.key,
// //     required this.patient,
// //     required this.queueNumber,
// //   });

// //   // لون شارة مدة الانتظار حسب طولها (تنبيه بصري لمن انتظر طويلًا)
// //   Color _waitColor() {
// //     final minutes = patient.waitingDuration.inMinutes;
// //     if (minutes >= 60) return constRed;
// //     if (minutes >= 30) return constOrange;
// //     return constGreen;
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final h = context.screenHeight;
// //     final w = context.screenWidth;

// //     final waitColor = _waitColor();

// //     return InkWell(
// //       onTap: () {
// //         Get.to(() => PatientsDetailsPage(patient: patient));
// //       },
// //       child: Container(
// //         margin: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.007),
// //         padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.015),
// //         decoration: BoxDecoration(
// //           color: Colors.white,
// //           borderRadius: BorderRadius.circular(16),
// //           boxShadow: [
// //             BoxShadow(
// //               color: Colors.black.withOpacity(0.06),
// //               blurRadius: 10,
// //               offset: const Offset(0, 4),
// //             ),
// //           ],
// //         ),
// //         child: Row(
// //           children: [
// //             // رقم دور المريض
// //             Container(
// //               width: w * 0.1,
// //               height: h * 0.05,
// //               alignment: Alignment.center,
// //               decoration: BoxDecoration(
// //                 color: constLightBlue,
// //                 shape: BoxShape.circle,
// //               ),
// //               child: Text(
// //                 '#$queueNumber',
// //                 style: const TextStyle(
// //                   fontWeight: FontWeight.bold,
// //                   color: constBlue,
// //                   fontSize: 12,
// //                 ),
// //               ),
// //             ),
// //             SizedBox(width: w * 0.03),

// //             // اسم المريض والرقم الوطني
// //             Expanded(
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     patient.name,
// //                     style: const TextStyle(
// //                       fontSize: 16,
// //                       fontWeight: FontWeight.bold,
// //                       color: constColor,
// //                     ),
// //                     overflow: TextOverflow.ellipsis,
// //                   ),
// //                   SizedBox(height: h * 0.002),
// //                   Text(
// //                     'الرقم الوطني: ${patient.nationalNumber}',
// //                     style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
// //                   ),
// //                 ],
// //               ),
// //             ),

// //             SizedBox(width: w * 0.03),

// //             // شارة مدة الانتظار
// //             Container(
// //               padding: EdgeInsets.symmetric(
// //                 horizontal: w * 0.02,
// //                 vertical: h * 0.005,
// //               ),
// //               decoration: BoxDecoration(
// //                 color: waitColor.withOpacity(0.1),
// //                 borderRadius: BorderRadius.circular(20),
// //                 border: Border.all(color: waitColor.withOpacity(0.4)),
// //               ),
// //               child: Row(
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Icon(Icons.access_time, size: 14, color: waitColor),
// //                   SizedBox(width: w * 0.01),
// //                   Text(
// //                     patient.waitingDurationText,
// //                     style: TextStyle(
// //                       fontSize: 12,
// //                       fontWeight: FontWeight.bold,
// //                       color: waitColor,
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // ignore_for_file: file_names, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Test/PatientListItem.dart';
// import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Patients_Details_Page.dart';

// class PatientCard extends StatelessWidget {
//   final PatientListItem patient;
//   final int queueNumber;

//   const PatientCard({
//     super.key,
//     required this.patient,
//     required this.queueNumber,
//   });

//   // لون شارة مدة الانتظار حسب طولها
//   Color _waitColor() {
//     final minutes = patient.waitingDuration.inMinutes;
//     if (minutes >= 60) return constRed;
//     if (minutes >= 30) return constOrange;
//     return constGreen;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     final waitColor = _waitColor();

//     return InkWell(
//       onTap: () {
//         Get.to(() => PatientsDetailsPage(patient: patient));
//       },
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.007),
//         padding: EdgeInsets.symmetric(
//           horizontal: w * 0.03,
//           vertical: h * 0.015,
//         ),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.06),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // رقم دور المريض
//             Container(
//               width: w * 0.1,
//               height: h * 0.05,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: constLightBlue,
//                 shape: BoxShape.circle,
//               ),
//               child: Text(
//                 '#$queueNumber',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: constBlue,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//             SizedBox(width: w * 0.03),

//             // اسم المريض والرقم الوطني
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     patient.name,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: constColor,
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: h * 0.002),
//                   Directionality(
//                     textDirection: TextDirection.ltr,
//                     child: Text(
//                       patient.nationalNumber,
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade600,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             SizedBox(width: w * 0.03),

//             // شارة مدة الانتظار
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: w * 0.02,
//                 vertical: h * 0.005,
//               ),
//               decoration: BoxDecoration(
//                 color: waitColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: waitColor.withOpacity(0.4)),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(Icons.access_time, size: 14, color: waitColor),
//                   SizedBox(width: w * 0.01),
//                   Text(
//                     patient.waitingDurationText,
//                     style: TextStyle(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: waitColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Patients_Details_Page.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';

class PatientCard extends StatelessWidget {
  final PatientListItem patient; // ✅ النوع الجديد (بدل PatientModel القديم)
  final int queueNumber; // ترتيب المريض في الطابور

  const PatientCard({
    super.key,
    required this.patient,
    required this.queueNumber,
  });

  // لون شارة مدة الانتظار حسب طولها (تنبيه بصري لمن انتظر طويلًا)
  Color _waitColor() {
    final minutes = patient.waitingDuration.inMinutes;
    if (minutes >= 60) return constRed;
    if (minutes >= 30) return constOrange;
    return constGreen;
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    final waitColor = _waitColor();

    return InkWell(
      onTap: () {
        Get.to(
          () => PatientsDetailsPage(patient: patient),
          transition: Transition.rightToLeft,
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.007),
        padding: EdgeInsets.symmetric(
          horizontal: w * 0.03,
          vertical: h * 0.015,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // رقم دور المريض
            Container(
              width: w * 0.1,
              height: h * 0.05,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: constLightBlue,
                shape: BoxShape.circle,
              ),
              child: Text(
                '#$queueNumber',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: constBlue,
                  fontSize: 12,
                ),
              ),
            ),
            SizedBox(width: w * 0.03),

            // اسم المريض والرقم
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: constColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: h * 0.002),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      patient.nationalNumber,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: w * 0.03),

            // شارة مدة الانتظار
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: w * 0.02,
                vertical: h * 0.005,
              ),
              decoration: BoxDecoration(
                color: waitColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: waitColor.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_time, size: 14, color: waitColor),
                  SizedBox(width: w * 0.01),
                  Text(
                    patient.waitingDurationText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: waitColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}