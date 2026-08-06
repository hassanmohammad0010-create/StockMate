// ignore_for_file: file_names

import 'package:stock_mate_project/core/models/Medicine_Model.dart';

/// يمثل حالة "كارد طلب واحدة" بالواجهة (قبل الإرسال)
/// يحمل MedicineModel كامل (مش بس اسم نصي) حتى نقدر نستخرج variantId عند الإرسال
class OrderFormEntry {
  final MedicineModel? selectedMedicine;
  final String quantity;
  final String priority;

  const OrderFormEntry({
    this.selectedMedicine,
    this.quantity = '',
    this.priority = 'normal',
  });

  bool get isValid => selectedMedicine != null && quantity.trim().isNotEmpty;

  OrderFormEntry copyWith({
    MedicineModel? selectedMedicine,
    String? quantity,
    String? priority,
    bool clearMedicine = false, // للسماح بإرجاع القيمة لـ null صراحةً
  }) {
    return OrderFormEntry(
      selectedMedicine:
          clearMedicine ? null : (selectedMedicine ?? this.selectedMedicine),
      quantity: quantity ?? this.quantity,
      priority: priority ?? this.priority,
    );
  }
}