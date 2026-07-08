enum PurchaseRequestStatus {
  pending,
  in_progress,
  ready_for_delivery,
  deliveried,
  rejected,
}

extension PurchaseRequestStatusX on PurchaseRequestStatus {
  String get arabicLabel {
    switch (this) {
      case PurchaseRequestStatus.pending:
        return 'بأنتظار موافقتك';
      case PurchaseRequestStatus.in_progress:
        return 'قيد التنفيذ';
      case PurchaseRequestStatus.ready_for_delivery:
        return 'جاهز للتسليم';
      case PurchaseRequestStatus.deliveried:
        return 'تم التسليم';
      case PurchaseRequestStatus.rejected:
        return 'مرفوضة';
    }
  }

  static PurchaseRequestStatus fromApiValue(String? value) {
    switch (value) {
      case 'pending':
        return PurchaseRequestStatus.pending;
      case 'in_progress':
        return PurchaseRequestStatus.in_progress;
      case 'ready_for_delivery':
        return PurchaseRequestStatus.ready_for_delivery;
      case 'deliveried':
        return PurchaseRequestStatus.deliveried;
      case 'rejected':
        return PurchaseRequestStatus.rejected;
      default:
        return PurchaseRequestStatus
            .pending; // fallback آمن بدل ما يرمي exception
    }
  }
}

enum PurchaseRequestPriority { normal, urgent }

extension RequestPriorityX on PurchaseRequestPriority {
  String get arabicLabel {
    switch (this) {
      case PurchaseRequestPriority.normal:
        return 'عادي';
      case PurchaseRequestPriority.urgent:
        return 'ضروري';
    }
  }

  static PurchaseRequestPriority fromApiValue(String? value) {
    switch (value) {
      case 'urgent':
        return PurchaseRequestPriority.urgent;
      case 'normal':
      default:
        return PurchaseRequestPriority.normal;
    }
  }
}

enum PurchaseRequestFrequency { normal, daily, weekly, monthly }

extension RequestFrequencyX on PurchaseRequestFrequency {
  String get arabicLabel {
    switch (this) {
      case PurchaseRequestFrequency.normal:
        return 'اعتيادي';
      case PurchaseRequestFrequency.daily:
        return 'يومي';
      case PurchaseRequestFrequency.weekly:
        return 'أسبوعي';
      case PurchaseRequestFrequency.monthly:
        return 'شهري';
    }
  }

  static PurchaseRequestFrequency fromApiValue(String? value) {
    switch (value) {
      case 'daily':
        return PurchaseRequestFrequency.daily;
      case 'weekly':
        return PurchaseRequestFrequency.weekly;
      case 'monthly':
        return PurchaseRequestFrequency.monthly;
      case 'normal':
      default:
        return PurchaseRequestFrequency.normal;
    }
  }
}

class Supplier {
  final String name;

  Supplier({required this.name});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class PurchaseRequest {
  final int id;
  final String departmentName;
  final PurchaseRequestStatus status;
  final PurchaseRequestPriority requestType;
  final PurchaseRequestFrequency requestFrequency;
  final DateTime date;
  final List<PurchaseRequestItemModel> items;
  final double expectedBudget;
  final String? reason;
  const PurchaseRequest({
    required this.id,
    required this.expectedBudget,
    required this.departmentName,
    required this.status,
    required this.requestType,
    required this.date,
    required this.items,
    required this.requestFrequency,

    this.reason,
  });

  factory PurchaseRequest.fromJson(Map<String, dynamic> json) {
    return PurchaseRequest(
      id: json['id'] as int,
      departmentName: json['department_name'] ?? '',
      status: PurchaseRequestStatusX.fromApiValue(json['status']),
      requestType: RequestPriorityX.fromApiValue(json['request_type']),
      requestFrequency: RequestFrequencyX.fromApiValue(
        json['request_frequency'],
      ),
      expectedBudget: json['expected_budget'],
      reason: json['reason'],
      date: DateTime.parse(json['created_at']),
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (e) => PurchaseRequestItemModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class PurchaseRequestItemModel {
  final int productId;
  final String productName;
  final String? brand;
  final List<Supplier>? suppliers;
  final int quantity;

  PurchaseRequestItemModel({
    required this.productId,
    required this.productName,
    this.brand,
    required this.suppliers,
    required this.quantity,
  });

  factory PurchaseRequestItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestItemModel(
      productId: json['product_id'] as int,
      productName: json['product_name'] ?? '',
      brand: json['brand'],
      suppliers: (json['suppliers'] as List<dynamic>? ?? [])
          .map((e) => Supplier.fromJson(e as Map<String, dynamic>))
          .toList(),
      quantity: json['quantity'] as int,
    );
  }
}
