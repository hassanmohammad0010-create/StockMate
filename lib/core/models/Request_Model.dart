class Supplier {
  final int id;
  final String name;

  Supplier({required this.id, required this.name});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(id: json['id'] as int, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class RequestModel {
  final int id;
  final String departmentName;
  final String status;
  final String requestType;
  final DateTime date;
  final List<RequestItemModel> items;

  RequestModel({
    required this.id,
    required this.departmentName,
    required this.status,
    required this.requestType,
    required this.date,
    required this.items,
  });

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'] as int,
      departmentName: json['department_name'] ?? '',
      status: json['status'] ?? '',
      requestType: json['request_type'] ?? '',
      date: DateTime.parse(json['created_at']),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => RequestItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'department_name': departmentName,
      'status': status,
      'request_type': requestType,
      'created_at': date.toIso8601String(),
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class RequestItemModel {
  final int productId;
  final String productName;
  final String? brand;
  final List<Supplier> suppliers;
  final int quantity;
  final int? approvedQuantity;

  RequestItemModel({
    required this.productId,
    required this.productName,
    this.brand,
    required this.suppliers,
    required this.quantity,
    this.approvedQuantity,
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
      approvedQuantity: json['approved_quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'brand': brand,
      'suppliers': suppliers.map((e) => e.toJson()).toList(),
      'quantity': quantity,
      'approved_quantity': approvedQuantity,
    };
  }
}
