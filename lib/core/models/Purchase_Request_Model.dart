enum RequestPriority { urgent, normal, low }

enum RequestStatus { pendingApproval, approved, rejected, inProgress, done }

class PurchaseRequest {
  final int id;
  final String materialName; // المادة المطلوبة
  final int quantity; // الكمية
  final String unit; // وحدة القياس
  final DateTime date; // التاريخ
  final String requesterName; // صاحب الطلب
  final String supplierName; // المورد
  final double expectedBudget; // الميزانية المتوقعة
  final RequestPriority priority; // الأولوية
  final RequestStatus status; // الحالة

  const PurchaseRequest({
    required this.id,
    required this.materialName,
    required this.quantity,
    required this.unit,
    required this.date,
    required this.requesterName,
    required this.supplierName,
    required this.expectedBudget,
    required this.priority,
    required this.status,
  });

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) {
    return PurchaseRequest(
      id: json['id'] as int,
      materialName: json['material_name'] as String,
      quantity: json['quantity'] as int,
      unit: json['unit'] as String,
      date: DateTime.parse(json['date'] as String),
      requesterName: json['requester_name'] as String,
      supplierName: json['supplier_name'] as String,
      expectedBudget: (json['expected_budget'] as num).toDouble(),
      priority: RequestPriority.values.firstWhere(
        (e) => e.name == json['priority'],
        orElse: () => RequestPriority.normal,
      ),
      status: RequestStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => RequestStatus.pendingApproval,
      ),
    );
  }
}
