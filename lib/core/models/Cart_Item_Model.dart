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

  factory BatchDeduction.fromJson(Map<String, dynamic> json) => BatchDeduction(
        batchId: json['batchId'] as String,
        quantity: json['quantity'] as int,
        expiryDate: DateTime.parse(json['expiryDate'] as String),
      );

  Map<String, dynamic> toJson() => {
        'batchId': batchId,
        'quantity': quantity,
        'expiryDate': expiryDate.toIso8601String(),
      };
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

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as String,
        materialId: json['materialId'] as String,
        materialName: json['materialName'] as String,
        quantity: json['quantity'] as int,
        deductions: (json['deductions'] as List<dynamic>)
            .map((d) => BatchDeduction.fromJson(d as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'materialId': materialId,
        'materialName': materialName,
        'quantity': quantity,
        'deductions': deductions.map((d) => d.toJson()).toList(),
      };
}