// lib/core/models/Adjustment_Type_Option_Model.dart
// ignore_for_file: file_names

class AdjustmentTypeOption {
  final String? value; // null = "الكل" (بدون فلترة)
  final String label;

  const AdjustmentTypeOption({this.value, required this.label});

  static const AdjustmentTypeOption allOption = AdjustmentTypeOption(
    value: null,
    label: 'الكل',
  );
  static const AdjustmentTypeOption damaged = AdjustmentTypeOption(
    value: 'damaged',
    label: 'تالف',
  );
  static const AdjustmentTypeOption expired = AdjustmentTypeOption(
    value: 'expired',
    label: 'منتهي الصلاحية',
  );
  static const AdjustmentTypeOption shrinkage = AdjustmentTypeOption(
    value: 'shrinkage',
    label: 'نقص/فقدان',
  );
  static const AdjustmentTypeOption found = AdjustmentTypeOption(
    value: 'found',
    label: 'موجود (إضافة)',
  );

  static List<AdjustmentTypeOption> get all => [
    allOption,
    damaged,
    expired,
    shrinkage,
    found,
  ];

  @override
  bool operator ==(Object other) =>
      other is AdjustmentTypeOption && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
