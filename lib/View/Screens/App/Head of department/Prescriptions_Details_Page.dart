// // ignore_for_file: file_names, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/core/models/PrescriptionModel.dart';
// import 'package:stock_mate_project/core/models/Prescriptions_Model.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';

// class PrescriptionDetailsPage extends StatelessWidget {
//   const PrescriptionDetailsPage({super.key});

//   Color _statusColor(PrescriptionStatus s) {
//     switch (s) {
//       case PrescriptionStatus.newRx:
//         return constRed;
//       case PrescriptionStatus.processed:
//         return constGreen;
//     }
//   }

//   String _statusLabel(PrescriptionStatus s) {
//     switch (s) {
//       case PrescriptionStatus.newRx:
//         return 'جديدة';
//       case PrescriptionStatus.processed:
//         return 'مُصرَّفة';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Prescription rx = Get.arguments as Prescription;
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;
//     final statusColor = _statusColor(rx.status);

//     return Scaffold(
//       backgroundColor: constBackgroundColor,
//       body: Column(
//         children: [
//           CustomBackContainer(),
//           SizedBox(height: h * 0.01),
//           CustomHeadContainer(title: 'تفاصيل الوصفة', trailing: rx.id),
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(
//                 horizontal: w * 0.04,
//                 vertical: h * 0.015,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ── بطاقة معلومات الوصفة ──────────────────
//                   _InfoCard(
//                     child: Column(
//                       children: [
//                         _InfoRow(
//                           icon: Icons.person_outline,
//                           label: 'الطبيب',
//                           value: rx.doctorName,
//                         ),
//                         _Divider(),
//                         _InfoRow(
//                           icon: Icons.local_hospital_outlined,
//                           label: 'القسم',
//                           value: rx.department,
//                         ),
//                         _Divider(),
//                         _InfoRow(
//                           icon: Icons.personal_injury_outlined,
//                           label: 'المريض',
//                           value: rx.patientName,
//                         ),                        
//                         _Divider(),
//                         _InfoRow(
//                           icon: Icons.calendar_today_outlined,
//                           label: 'التاريخ',
//                           value:
//                               rx.date, // يمكنك تنسيق التاريخ حسب الحاجة
//                         ),
//                         _Divider(),
//                         _InfoRow(
//                           icon: Icons.info_outline,
//                           label: 'الحالة',
//                           value: _statusLabel(rx.status),
//                           valueColor: statusColor,
//                         ),
//                         if (rx.notes.isNotEmpty) ...[
//                           _Divider(),
//                           _InfoRow(
//                             icon: Icons.notes_outlined,
//                             label: 'ملاحظات',
//                             value: rx.notes,
//                             valueColor: constRed,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),

//                   SizedBox(height: h * 0.02),

//                   // ── عنوان قسم الأدوية ─────────────────────
//                   Padding(
//                     padding: EdgeInsets.only(right: w * 0.01, bottom: h * 0.01),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.medication_outlined,
//                           color: constBlue,
//                           size: 20,
//                         ),
//                         SizedBox(width: w * 0.02),
//                         Text(
//                           'الأدوية المطلوبة',
//                           style: TextStyle(
//                             fontFamily: cairo,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         SizedBox(width: w * 0.02),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: w * 0.025,
//                             vertical: h * 0.003,
//                           ),
//                           decoration: BoxDecoration(
//                             color: constLightBlue,
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Text(
//                             '${rx.medicines.length}',
//                             style: TextStyle(
//                               fontFamily: cairo,
//                               fontSize: 12,
//                               fontWeight: FontWeight.bold,
//                               color: constBlue,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // ── كاردات الأدوية ────────────────────────
//                   ...rx.medicines.asMap().entries.map((entry) {
//                     final index = entry.key;
//                     final med = entry.value;
//                     return _MedicineCard(index: index + 1, medicine: med);
//                   }),

//                   SizedBox(height: h * 0.02),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ─── Widgets مساعدة ───────────────────────────────────────────

// class _InfoCard extends StatelessWidget {
//   const _InfoCard({required this.child});
//   final Widget child;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.07),
//             blurRadius: 10,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: child,
//     );
//   }
// }

// class _InfoRow extends StatelessWidget {
//   const _InfoRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//     this.valueColor,
//   });
//   final IconData icon;
//   final String label;
//   final String value;
//   final Color? valueColor;

//   @override
//   Widget build(BuildContext context) {
//     final w = MediaQuery.of(context).size.width;
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: constBlue),
//           SizedBox(width: w * 0.025),
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: cairo,
//               fontSize: 13,
//               color: Colors.grey.shade600,
//             ),
//           ),
//           const Spacer(),
//           Flexible(
//             child: Text(
//               value,
//               textAlign: TextAlign.left,
//               style: TextStyle(
//                 fontFamily: cairo,
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//                 color: valueColor ?? Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _Divider extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) =>
//       Divider(height: 1, color: Colors.grey.shade100);
// }

// class _MedicineCard extends StatelessWidget {
//   const _MedicineCard({required this.index, required this.medicine});
//   final int index;
//   final String medicine;

//   @override
//   Widget build(BuildContext context) {
//     final h = MediaQuery.of(context).size.height;
//     final w = MediaQuery.of(context).size.width;

//     return Container(
//       margin: EdgeInsets.only(bottom: h * 0.012),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.06),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(w * 0.04),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // رقم الدواء
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: constLightBlue,
//                 shape: BoxShape.circle,
//               ),
//               child: Center(
//                 child: Text(
//                   '$index',
//                   style: TextStyle(
//                     fontFamily: cairo,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                     color: constBlue,
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(width: w * 0.03),

//             // تفاصيل الدواء
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     medicine,
//                     style: TextStyle(
//                       fontFamily: cairo,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 14,
//                       color: Colors.black87,
//                     ),
//                   ),
//                   SizedBox(height: h * 0.006),
//                   Row(
//                     children: [
//                       _Chip(
//                         label: '${medicine.quantity} ${medicine.unit}',
//                         icon: Icons.numbers,
//                       ),
//                       SizedBox(width: w * 0.02),
//                       _Chip(
//                         label: medicine.dosage,
//                         icon: Icons.schedule_outlined,
//                       ),
//                     ],
//                   ),
//                   if (notes.isNotEmpty) ...[
//                     SizedBox(height: h * 0.006),
//                     Text(
//                       nonts,
//                       style: TextStyle(
//                         fontFamily: cairo,
//                         fontSize: 11,
//                         color: Colors.grey.shade500,
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _Chip extends StatelessWidget {
//   const _Chip({required this.label, required this.icon});
//   final String label;
//   final IconData icon;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: const Color(0xFFF5F5F5),
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 11, color: Colors.grey.shade600),
//           const SizedBox(width: 4),
//           Text(
//             label,
//             style: TextStyle(
//               fontFamily: cairo,
//               fontSize: 11,
//               color: Colors.grey.shade700,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
