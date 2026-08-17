// lib/core/models/Create_Purchase_Receipt_Item_Input.dart
// ignore_for_file: file_names

class CreatePurchaseReceiptItemInput {
  final String purchaseRequestItemId;
  final int quantity;
  final String batchNumber;
  final DateTime manufacturingDate;
  final DateTime expirationDate;
  final double purchasePrice;

  const CreatePurchaseReceiptItemInput({
    required this.purchaseRequestItemId,
    required this.quantity,
    required this.batchNumber,
    required this.manufacturingDate,
    required this.expirationDate,
    required this.purchasePrice,
  });

  Map<String, dynamic> toJson() => {
    'purchaseRequestItemId': purchaseRequestItemId,
    'quantity': quantity,
    'batchNumber': batchNumber,
    'manufacturingDate': _fmtDate(manufacturingDate),
    'expirationDate': _fmtDate(expirationDate),
    'purchasePrice': purchasePrice,
  };

  static String _fmtDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}
