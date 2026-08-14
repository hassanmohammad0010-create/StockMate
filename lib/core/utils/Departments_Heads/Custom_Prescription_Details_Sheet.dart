// // ignore_for_file: file_names, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Controller/Logic/PrescriptionController.dart';
// import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
// import 'package:stock_mate_project/core/models/PrescriptionModel.dart';

// void showPrescriptionDetails(
//   BuildContext context,
//   PrescriptionModel prescription,
// ) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (_) => _PrescriptionDetailsSheet(prescriptionId: prescription.id),
//   );
// }

// String _formatDate(DateTime date) {
//   final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
//   final period = date.hour >= 12 ? 'م' : 'ص';
//   final mm = date.month.toString().padLeft(2, '0');
//   final dd = date.day.toString().padLeft(2, '0');
//   final min = date.minute.toString().padLeft(2, '0');
//   return '${date.year}/$mm/$dd  ${hour.toString().padLeft(2, '0')}:$min $period';
// }

// class _PrescriptionDetailsSheet extends StatefulWidget {
//   final String prescriptionId;

//   const _PrescriptionDetailsSheet({required this.prescriptionId});

//   @override
//   State<_PrescriptionDetailsSheet> createState() =>
//       _PrescriptionDetailsSheetState();
// }

// class _PrescriptionDetailsSheetState extends State<_PrescriptionDetailsSheet> {
//   final Map<String, TextEditingController> _quantityControllers = {};
//   final Map<String, String?> _validationErrors = {}; // ← أخطاء التحقق
//   final List<MedicationItem> _medications = [];

//   @override
//   void dispose() {
//     for (var controller in _quantityControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _initMedications(PrescriptionModel prescription) {
//     if (_medications.isNotEmpty) return;

//     final meds = prescription.medications
//         .split('\n')
//         .where((m) => m.trim().isNotEmpty)
//         .map((m) => MedicationItem.fromText(m))
//         .toList();

//     _medications.addAll(meds);

//     for (var med in _medications) {
//       _quantityControllers[med.name] = TextEditingController();
//     }
//   }

//   /// التحقق من صحة القيمة المدخلة لدواء معين
//   String? _validateQuantity(String medicineName, String? value) {
//     if (value == null || value.trim().isEmpty) {
//       return null; // فارغ = سيتم إعطاء الكمية المطلوبة كاملة
//     }

//     final parsed = int.tryParse(value.trim());
//     if (parsed == null) {
//       return 'الرجاء إدخال رقم صحيح فقط';
//     }

//     if (parsed <= 0) {
//       return 'الكمية يجب أن تكون أكبر من الصفر';
//     }

//     final med = _medications.firstWhere((m) => m.name == medicineName);
//     if (parsed > med.requestedQuantity) {
//       return 'الكمية لا يمكن أن تتجاوز ${med.requestedQuantity} ${med.requestedQuantity == 1 ? 'قطعة' : 'قطع'}';
//     }

//     return null;
//   }

//   void _onQuantityChanged(String medicineName, String value) {
//     final error = _validateQuantity(medicineName, value);

//     setState(() {
//       _validationErrors[medicineName] = error;

//       // تحديث givenQuantity فقط إذا كانت القيمة صحيحة
//       if (error == null) {
//         final parsed = int.tryParse(value.trim());
//         final med = _medications.firstWhere((m) => m.name == medicineName);
//         med.givenQuantity = parsed;
//       }
//     });
//   }

//   Map<String, int> _getGivenQuantities() {
//     final quantities = <String, int>{};

//     for (var med in _medications) {
//       final controller = _quantityControllers[med.name];
//       final text = controller?.text.trim();

//       if (text != null && text.isNotEmpty) {
//         final parsed = int.tryParse(text);
//         if (parsed != null && parsed > 0) {
//           quantities[med.name] = parsed;
//         }
//       }
//     }

//     return quantities;
//   }

//   bool get _hasAnyValidationError {
//     return _validationErrors.values.any((error) => error != null);
//   }

//   bool get _hasAnyModifiedQuantity {
//     return _medications.any((med) {
//       final controller = _quantityControllers[med.name];
//       final text = controller?.text.trim();
//       if (text != null && text.isNotEmpty) {
//         final parsed = int.tryParse(text);
//         if (parsed != null && parsed != med.requestedQuantity) {
//           return true;
//         }
//       }
//       return false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<PrescriptionController>();

//     return Obx(() {
//       final prescription = controller.findById(widget.prescriptionId);

//       if (prescription == null) return const SizedBox.shrink();

//       _initMedications(prescription);

//       final bool isNew = prescription.status == PrescriptionStatus.newRx;
//       final Color accentColor = isNew ? constRed : constGreen;

//       return _buildContent(
//         context,
//         controller,
//         prescription,
//         isNew,
//         accentColor,
//       );
//     });
//   }

//   Widget _buildContent(
//     BuildContext context,
//     PrescriptionController controller,
//     PrescriptionModel prescription,
//     bool isNew,
//     Color accentColor,
//   ) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     return GestureDetector(
//       onTap: () => FocusScope.of(
//         context,
//       ).unfocus(), // إخفاء لوحة المفاتيح عند النقر خارج الحقول
//       child: Container(
//         constraints: BoxConstraints(maxHeight: h * 0.9),
//         padding: EdgeInsets.only(
//           bottom: MediaQuery.of(context).viewInsets.bottom,
//         ),
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         child: SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // ── مقبض السحب ──
//               Padding(
//                 padding: EdgeInsets.only(top: h * 0.012),
//                 child: Container(
//                   width: w * 0.15,
//                   height: h * 0.005,
//                   decoration: BoxDecoration(
//                     color: constGray.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),

//               // ── المحتوى القابل للتمرير ──
//               Flexible(
//                 child: SingleChildScrollView(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: w * 0.05,
//                     vertical: h * 0.02,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // ── اسم المريض + الحالة ──
//                       Row(
//                         children: [
//                           Container(
//                             width: h * 0.045,
//                             height: h * 0.045,
//                             decoration: BoxDecoration(
//                               color: accentColor.withOpacity(0.1),
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               isNew
//                                   ? Icons.fiber_new_rounded
//                                   : Icons.check_circle_rounded,
//                               size: h * 0.024,
//                               color: accentColor,
//                             ),
//                           ),
//                           SizedBox(width: w * 0.03),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   prescription.patientName,
//                                   style: const TextStyle(
//                                     fontSize: 19,
//                                     fontWeight: FontWeight.w800,
//                                     color: Color(0xFF111827),
//                                   ),
//                                 ),
//                                 SizedBox(height: h * 0.003),
//                                 Text(
//                                   _formatDate(prescription.date),
//                                   style: const TextStyle(
//                                     fontSize: 12.5,
//                                     color: Color(0xFF9CA3AF),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: w * 0.025,
//                               vertical: h * 0.007,
//                             ),
//                             decoration: BoxDecoration(
//                               color: accentColor.withOpacity(0.12),
//                               borderRadius: BorderRadius.circular(20),
//                               border: Border.all(
//                                 color: accentColor.withOpacity(0.3),
//                                 width: 0.8,
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   isNew
//                                       ? Icons.schedule_rounded
//                                       : Icons.verified_rounded,
//                                   size: 13,
//                                   color: accentColor,
//                                 ),
//                                 SizedBox(width: w * 0.01),
//                                 Text(
//                                   isNew ? 'جديدة' : 'تمت المعالجة',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                     color: accentColor,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),

//                       SizedBox(height: h * 0.02),
//                       Divider(height: 1, color: Colors.grey.shade200),
//                       SizedBox(height: h * 0.02),

//                       // ── الطبيب المعالج ──
//                       _DetailRow(
//                         icon: Icons.person_outline,
//                         label: 'الطبيب المعالج',
//                         value: prescription.doctorName ?? '---',
//                         accentColor: accentColor,
//                       ),
//                       SizedBox(height: h * 0.02),

//                       // ── الأدوية الموصوفة ──
//                       _MedicationsSection(
//                         medications: _medications,
//                         accentColor: accentColor,
//                         isNew: isNew,
//                         quantityControllers: _quantityControllers,
//                         validationErrors: _validationErrors,
//                         onQuantityChanged: _onQuantityChanged,
//                       ),

//                       // ── الملاحظات ──
//                       if (prescription.notes != null &&
//                           prescription.notes!.trim().isNotEmpty) ...[
//                         SizedBox(height: h * 0.02),
//                         _DetailRow(
//                           icon: Icons.notes_outlined,
//                           label: 'ملاحظات',
//                           value: prescription.notes!,
//                           accentColor: accentColor,
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//               ),

//               // ── زر الصرف (ثابت أسفل) ──
//               Padding(
//                 padding: EdgeInsets.only(
//                   right: w * 0.05,
//                   left: w * 0.05,
//                   bottom: h * 0.015,
//                 ),
//                 child: isNew
//                     ? SizedBox(
//                         width: double.infinity,
//                         height: h * 0.056,
//                         child: ElevatedButton.icon(
//                           onPressed: _hasAnyValidationError
//                               ? null // تعطيل الزر إذا كان هناك أخطاء
//                               : () {
//                                   final givenQuantities = _getGivenQuantities();

//                                   Get.back();

//                                   controller.updatePrescriptionQuantities(
//                                     prescription.id,
//                                     givenQuantities,
//                                   );

//                                   customSnackBar(
//                                     title: 'نجاح العملية',
//                                     message: givenQuantities.isEmpty
//                                         ? 'تم صرف وصفة ${prescription.patientName} بالكامل'
//                                         : 'تم صرف وصفة ${prescription.patientName} (مع تعديلات على الكميات)',
//                                     messageColor: Colors.white,
//                                     color: constGreen,
//                                   );
//                                 },
//                           icon: Icon(
//                             _hasAnyModifiedQuantity && !_hasAnyValidationError
//                                 ? Icons.edit_note
//                                 : Icons.check_circle_outline,
//                           ),
//                           label: Text(
//                             _hasAnyModifiedQuantity && !_hasAnyValidationError
//                                 ? 'صرف الوصفة (مع تعديلات)'
//                                 : 'صرف الوصفة',
//                             style: const TextStyle(
//                               fontSize: 15,
//                               fontWeight: FontWeight.w700,
//                             ),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: _hasAnyValidationError
//                                 ? Colors.grey.shade400
//                                 : constGreen,
//                             foregroundColor: Colors.white,
//                             elevation: 0,
//                             shadowColor: constGreen.withOpacity(0.3),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(14),
//                             ),
//                           ),
//                         ),
//                       )
//                     : Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.symmetric(vertical: h * 0.018),
//                         decoration: BoxDecoration(
//                           color: constGreen.withOpacity(0.08),
//                           borderRadius: BorderRadius.circular(14),
//                           border: Border.all(
//                             color: constGreen.withOpacity(0.25),
//                             width: 1,
//                           ),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.check_circle_rounded,
//                               size: h * 0.022,
//                               color: constGreen,
//                             ),
//                             SizedBox(width: w * 0.02),
//                             const Text(
//                               'هذه الوصفة تمت صرفها بالفعل',
//                               style: TextStyle(
//                                 fontSize: 13.5,
//                                 fontWeight: FontWeight.w600,
//                                 color: constGreen,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────
// //  قسم الأدوية مع حقول الكمية والتحقق
// // ─────────────────────────────────────────────────────────
// class _MedicationsSection extends StatelessWidget {
//   final List<MedicationItem> medications;
//   final Color accentColor;
//   final bool isNew;
//   final Map<String, TextEditingController> quantityControllers;
//   final Map<String, String?> validationErrors;
//   final Function(String, String) onQuantityChanged;

//   const _MedicationsSection({
//     required this.medications,
//     required this.accentColor,
//     required this.isNew,
//     required this.quantityControllers,
//     required this.validationErrors,
//     required this.onQuantityChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // ── العنوان مع العدد ──
//         Row(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: w * 0.02,
//                 vertical: h * 0.01,
//               ),
//               decoration: BoxDecoration(
//                 color: accentColor.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 Icons.medication_outlined,
//                 size: 18,
//                 color: accentColor.withOpacity(0.8),
//               ),
//             ),
//             SizedBox(width: w * 0.03),
//             const Text(
//               'الأدوية الموصوفة',
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Color(0xFF9CA3AF),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const Spacer(),
//             Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: w * 0.022,
//                 vertical: h * 0.005,
//               ),
//               decoration: BoxDecoration(
//                 color: accentColor.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: accentColor.withOpacity(0.2),
//                   width: 0.5,
//                 ),
//               ),
//               child: Text(
//                 '${medications.length} ${medications.length == 1 ? 'دواء' : 'أدوية'}',
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w700,
//                   color: accentColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: h * 0.012),

//         // ── قائمة الأدوية ──
//         ...medications.asMap().entries.map((entry) {
//           final index = entry.key;
//           final med = entry.value;
//           final error = validationErrors[med.name];

//           return Container(
//             width: double.infinity,
//             margin: EdgeInsets.only(bottom: h * 0.012),
//             padding: EdgeInsets.symmetric(
//               horizontal: w * 0.03,
//               vertical: h * 0.015,
//             ),
//             decoration: BoxDecoration(
//               color: error != null
//                   ? constRed.withOpacity(0.05)
//                   : accentColor.withOpacity(0.04),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: error != null
//                     ? constRed.withOpacity(0.3)
//                     : accentColor.withOpacity(0.12),
//                 width: error != null ? 1.5 : 0.7,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // ── صف اسم الدواء ──
//                 Row(
//                   children: [
//                     Container(
//                       width: h * 0.027,
//                       height: h * 0.027,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [accentColor, accentColor.withOpacity(0.7)],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                         shape: BoxShape.circle,
//                         boxShadow: [
//                           BoxShadow(
//                             color: accentColor.withOpacity(0.25),
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: Center(
//                         child: Text(
//                           '${index + 1}',
//                           style: TextStyle(
//                             fontSize: h * 0.011,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: w * 0.025),
//                     Expanded(
//                       child: Text(
//                         med.name,
//                         style: const TextStyle(
//                           fontSize: 14,
//                           color: Color(0xFF1F2937),
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 SizedBox(height: h * 0.012),

//                 // ── صف الكمية المطلوبة ──
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.inventory_2_outlined,
//                       size: 16,
//                       color: Colors.grey.shade600,
//                     ),
//                     SizedBox(width: w * 0.02),
//                     Text(
//                       isNew ? 'الكمية المطلوبة:' : 'الكمية المعطاة:',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: Colors.grey.shade600,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     SizedBox(width: w * 0.02),
//                     Container(
//                       padding: EdgeInsets.symmetric(
//                         horizontal: w * 0.025,
//                         vertical: h * 0.005,
//                       ),
//                       decoration: BoxDecoration(
//                         color: accentColor.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: accentColor.withOpacity(0.3),
//                           width: 0.5,
//                         ),
//                       ),
//                       child: Text(
//                         '${med.requestedQuantity} ${med.requestedQuantity == 1 ? 'قطعة' : 'قطع'}',
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w700,
//                           color: accentColor,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 // ── حقل إدخال الكمية المعطاة (فقط للوصفات الجديدة) ──
//                 if (isNew) ...[
//                   SizedBox(height: h * 0.012),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.edit_outlined,
//                         size: 16,
//                         color: Colors.grey.shade600,
//                       ),
//                       SizedBox(width: w * 0.02),
//                       Text(
//                         'الكمية المعطاة:',
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       SizedBox(width: w * 0.02),
//                       Expanded(
//                         child: Container(
//                           height: h * 0.04,
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(8),
//                             border: Border.all(
//                               color: error != null
//                                   ? constRed
//                                   : Colors.grey.shade300,
//                               width: error != null ? 1.5 : 1,
//                             ),
//                           ),
//                           child: TextFormField(
//                             controller: quantityControllers[med.name],
//                             keyboardType: TextInputType.number,
//                             inputFormatters: [
//                               FilteringTextInputFormatter
//                                   .digitsOnly, // فقط أرقام
//                               LengthLimitingTextInputFormatter(
//                                 3,
//                               ), // حد أقصى 3 أرقام
//                             ],
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                               color: error != null
//                                   ? constRed
//                                   : const Color(0xFF1F2937),
//                             ),
//                             decoration: InputDecoration(
//                               hintText: '${med.requestedQuantity} (افتراضي)',
//                               hintStyle: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey.shade400,
//                                 fontStyle: FontStyle.italic,
//                               ),
//                               border: InputBorder.none,
//                               contentPadding: EdgeInsets.symmetric(
//                                 horizontal: w * 0.02,
//                                 vertical: h * 0.005,
//                               ),
//                             ),
//                             onChanged: (value) =>
//                                 onQuantityChanged(med.name, value),
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: w * 0.02),
//                       Text(
//                         'قطعة',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey.shade500,
//                         ),
//                       ),
//                     ],
//                   ),

//                   // ── رسالة الخطأ ──
//                   if (error != null) ...[
//                     SizedBox(height: h * 0.008),
//                     Row(
//                       children: [
//                         Icon(Icons.error_outline, size: 14, color: constRed),
//                         SizedBox(width: w * 0.015),
//                         Expanded(
//                           child: Text(
//                             error,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: constRed,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ] else ...[
//                     SizedBox(height: h * 0.0001),
//                   ],
//                 ],
//               ],
//             ),
//           );
//         }),
//       ],
//     );
//   }
// }

// // ─────────────────────────────────────────────────────────
// //  صف تفصيل عادي (طبيب، ملاحظات)
// // ─────────────────────────────────────────────────────────
// class _DetailRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final Color accentColor;

//   const _DetailRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.accentColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: w * 0.02,
//             vertical: h * 0.01,
//           ),
//           decoration: BoxDecoration(
//             color: accentColor.withOpacity(0.07),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(icon, size: 18, color: accentColor.withOpacity(0.7)),
//         ),
//         SizedBox(width: w * 0.03),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label,
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Color(0xFF9CA3AF),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(height: h * 0.002),
//               Text(
//                 value,
//                 style: const TextStyle(
//                   fontSize: 14.5,
//                   color: Color(0xFF1F2937),
//                   height: 1.4,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
