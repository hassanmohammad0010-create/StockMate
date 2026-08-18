// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/BatchDeletionPage.dart';
// import 'package:stock_mate_project/core/models/Material_Model.dart';

// class BatchRowItem extends StatelessWidget {
//   const BatchRowItem({super.key, required this.batch, required this.material});

//   final MaterialBatch batch;
//   final MaterialItem material;

//   static String _fmt(int n) => n.toString().replaceAllMapped(
//     RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
//     (m) => '${m[1]},',
//   );

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     final (bg, textColor) = switch (batch.status) {
//       BatchStatus.valid => (constLightGreen, constGreen),
//       BatchStatus.expiringSoon => (constLightRed, constRed),
//       BatchStatus.expired => (constLightOrange, constOrange),
//     };

//     final dateStr =
//         '${batch.expiryDate.year}-${batch.expiryDate.month.toString().padLeft(2, '0')}-${batch.expiryDate.day.toString().padLeft(2, '0')}';

//     return Container(
//       margin: EdgeInsets.only(bottom: h * 0.01),
//       padding: EdgeInsets.symmetric(horizontal: w * 0.03, vertical: h * 0.012),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade200, width: 0.5),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Text(
//                 _fmt(batch.quantity),
//                 style: TextStyle(
//                   fontSize: h * 0.017,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               SizedBox(width: w * 0.02),
//               Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: w * 0.025,
//                   vertical: h * 0.004,
//                 ),
//                 decoration: BoxDecoration(
//                   color: bg,
//                   borderRadius: BorderRadius.circular(99),
//                 ),
//                 child: Text(
//                   batch.statusLabel,
//                   style: TextStyle(fontSize: h * 0.013, color: textColor),
//                 ),
//               ),
//             ],
//           ),
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 dateStr,
//                 style: TextStyle(fontSize: h * 0.014, color: Colors.grey),
//               ),
//               // زر الحذف يظهر الآن لجميع الدفعات بغض النظر عن حالتها
//               SizedBox(width: w * 0.025),
//               _DeleteBatchButton(batch: batch, material: material),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DeleteBatchButton extends StatelessWidget {
//   const _DeleteBatchButton({required this.batch, required this.material});

//   final MaterialBatch batch;
//   final MaterialItem material;

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     return GestureDetector(
//       onTap: () => Get.to(
//         () => BatchDeletionPage(material: material, batch: batch),
//       ),
//       child: Container(
//         padding: EdgeInsets.symmetric(
//           horizontal: w * 0.012,
//           vertical: h * 0.006,
//         ),
//         decoration: BoxDecoration(
//           color: constLightRed,
//           borderRadius: BorderRadius.circular(6),
//         ),
//         child: Icon(Icons.delete_outline, size: 20, color: constRed),
//       ),
//     );
//   }
// }