// ignore_for_file: file_names

class BatchDeduction {
  final String batchId;
  final int quantity;
  final DateTime expiryDate;

  BatchDeduction({
    required this.batchId,
    required this.quantity,
    required this.expiryDate,
  });
}

class CartItem {
  final String id;
  final String materialId;
  final String materialName;
  int quantity;
  final List<BatchDeduction> deductions;

  CartItem({
    required this.id,
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.deductions,
  });
}