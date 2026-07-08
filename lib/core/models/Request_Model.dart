enum RequestStatus {
  pending,
  in_progress,
  ready_for_delivery,
  deliveried,
  rejected,
}

extension RequestStatusX on RequestStatus {
  String get arabicLabel {
    switch (this) {
      case RequestStatus.pending:
        return 'بأنتظار موافقتك';
      case RequestStatus.in_progress:
        return 'قيد التنفيذ';
      case RequestStatus.ready_for_delivery:
        return 'جاهز للتسليم';
      case RequestStatus.deliveried:
        return 'تم التسليم';
      case RequestStatus.rejected:
        return 'مرفوضة';
    }
  }

  static RequestStatus fromApiValue(String? value) {
    switch (value) {
      case 'pending':
        return RequestStatus.pending;
      case 'in_progress':
        return RequestStatus.in_progress;
      case 'ready_for_delivery':
        return RequestStatus.ready_for_delivery;
      case 'deliveried':
        return RequestStatus.deliveried;
      case 'rejected':
        return RequestStatus.rejected;
      default:
        return RequestStatus.pending; // fallback آمن بدل ما يرمي exception
    }
  }
}

enum RequestPriority { normal, urgent }

extension RequestPriorityX on RequestPriority {
  String get arabicLabel {
    switch (this) {
      case RequestPriority.normal:
        return 'عادي';
      case RequestPriority.urgent:
        return 'ضروري';
    }
  }

  static RequestPriority fromApiValue(String? value) {
    switch (value) {
      case 'urgent':
        return RequestPriority.urgent;
      case 'normal':
      default:
        return RequestPriority.normal;
    }
  }
}

enum RequestFrequency { normal, daily, weekly, monthly }

extension RequestFrequencyX on RequestFrequency {
  String get arabicLabel {
    switch (this) {
      case RequestFrequency.normal:
        return 'اعتيادي';
      case RequestFrequency.daily:
        return 'يومي';
      case RequestFrequency.weekly:
        return 'أسبوعي';
      case RequestFrequency.monthly:
        return 'شهري';
    }
  }

  static RequestFrequency fromApiValue(String? value) {
    switch (value) {
      case 'daily':
        return RequestFrequency.daily;
      case 'weekly':
        return RequestFrequency.weekly;
      case 'monthly':
        return RequestFrequency.monthly;
      case 'normal':
      default:
        return RequestFrequency.normal;
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

class RequestModel {
  final int id;
  final String departmentName;
  final RequestStatus status;
  final RequestPriority requestType;
  final RequestFrequency requestFrequency;
  final DateTime date;
  final List<RequestItemModel> items;

  RequestModel({
    required this.id,
    required this.departmentName,
    required this.status,
    required this.requestType,
    required this.date,
    required this.items,
    required this.requestFrequency,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as int,
      departmentName: json['department_name'] ?? '',
      status: RequestStatusX.fromApiValue(json['status']),
      requestType: RequestPriorityX.fromApiValue(json['request_type']),
      requestFrequency: RequestFrequencyX.fromApiValue(
        json['request_frequency'],
      ),
      date: DateTime.parse(json['created_at']),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => RequestItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RequestItemModel {
  final int productId;
  final String productName;
  final String? brand;
  final List<Supplier>? suppliers;
  final int quantity;

  RequestItemModel({
    required this.productId,
    required this.productName,
    this.brand,
    required this.suppliers,
    required this.quantity,
  });

  factory RequestItemModel.fromJson(Map<String, dynamic> json) {
    return RequestItemModel(
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
