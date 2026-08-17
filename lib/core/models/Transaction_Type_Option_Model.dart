// ignore_for_file: file_names

/// خيار بسيط يمثل نوع حركة المخزون، يُستخدم مع CustomDropdown<TransactionTypeOption>
class TransactionTypeOption {
  final String? value; // null = بدون فلتر (الكل)
  final String label;

  const TransactionTypeOption({required this.value, required this.label});

  static const List<TransactionTypeOption> all = [
    TransactionTypeOption(value: null, label: 'الكل'),
    TransactionTypeOption(value: 'purchase_receipt', label: 'استلام مشتريات'),
    TransactionTypeOption(
      value: 'department_transfer_out',
      label: 'تحويل صادر لقسم',
    ),
    TransactionTypeOption(
      value: 'department_transfer_in',
      label: 'تحويل وارد لقسم',
    ),
    TransactionTypeOption(
      value: 'prescription_dispense',
      label: 'صرف وصفة طبية',
    ),
    TransactionTypeOption(
      value: 'department_consumption',
      label: 'استهلاك القسم',
    ),
    TransactionTypeOption(value: 'adjustment_damaged', label: 'تسوية - تالف'),
    TransactionTypeOption(
      value: 'adjustment_expired',
      label: 'تسوية - منتهي الصلاحية',
    ),
    TransactionTypeOption(value: 'adjustment_shrinkage', label: 'تسوية - عجز'),
    TransactionTypeOption(value: 'adjustment_found', label: 'تسوية - زيادة'),
  ];
}
