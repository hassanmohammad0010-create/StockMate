// lib/core/models/Approve_Purchase_Item_Input.dart
// ignore_for_file: file_names

/// موديل الإدخال لكل صنف عند موافقة المدير على طلب شراء
class ApprovePurchaseItemInput {
  final String purchaseRequestItemId;
  final int approvedQuantity;

  const ApprovePurchaseItemInput({
    required this.purchaseRequestItemId,
    required this.approvedQuantity,
  });

  Map<String, dynamic> toJson() => {
    'purchaseRequestItemId': purchaseRequestItemId,
    'approvedQuantity': approvedQuantity,
  };
}
