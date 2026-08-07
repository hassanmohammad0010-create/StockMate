// ignore_for_file: file_names

import 'package:stock_mate_project/core/models/Order_Item.dart';

/// ─────────────────────────────────────────────────────────────
/// مودل تفاصيل الطلب — Get Refill Request By Id
/// GET /department-refills/requests/{id}
/// ─────────────────────────────────────────────────────────────

class OrderItemDetails {
  final String id;
  final String requestNumber;
  final String departmentId;
  final DetailDepartment? department;
  final String requestedById;
  final DetailRequestedBy? requestedBy;

  // ✅ Enums
  final OrderStatus status;
  final OrderPriority priority;
  final String requestType;
  final RecurringInterval? recurringInterval;
  final int? frequencyInterval;

  // ✅ حقول شرطية
  final String? notes;
  final String? rejectionReason;
  final String? hospitalRejectionReason;
  final DateTime? approvedAt;
  final DateTime? hospitalApprovedAt;

  final DateTime createdAt;
  final DateTime updatedAt;

  final List<DetailRequestItem> items;

  const OrderItemDetails({
    required this.id,
    required this.requestNumber,
    required this.departmentId,
    this.department,
    required this.requestedById,
    this.requestedBy,
    required this.status,
    required this.priority,
    required this.requestType,
    this.recurringInterval,
    this.frequencyInterval,
    this.notes,
    this.rejectionReason,
    this.hospitalRejectionReason,
    this.approvedAt,
    this.hospitalApprovedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory OrderItemDetails.fromJson(Map<String, dynamic> json) {
    final requestTypeStr = json['requestType']?.toString() ?? 'normal';

    return OrderItemDetails(
      id: json['id']?.toString() ?? '',
      requestNumber: json['requestNumber']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      department: json['department'] is Map
          ? DetailDepartment.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      requestedById: json['requestedById']?.toString() ?? '',
      requestedBy: json['requestedBy'] is Map
          ? DetailRequestedBy.fromJson(json['requestedBy'] as Map<String, dynamic>)
          : null,
      status: OrderStatus.fromString(json['status']?.toString() ?? 'draft'),
      priority: OrderPriority.fromString(json['priority']?.toString() ?? 'normal'),
      requestType: requestTypeStr,
      recurringInterval: RecurringInterval.fromString(requestTypeStr),
      frequencyInterval: json['frequencyInterval'] != null
          ? int.tryParse(json['frequencyInterval'].toString())
          : null,
      notes: json['notes']?.toString(),
      rejectionReason: json['rejectionReason']?.toString(),
      hospitalRejectionReason: json['hospitalRejectionReason']?.toString(),
      approvedAt: _parseDate(json['approvedAt']),
      hospitalApprovedAt: _parseDate(json['hospitalApprovedAt']),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updatedAt']) ?? DateTime.now(),
      items: (json['items'] as List? ?? [])
          .map((e) => DetailRequestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  // ─── Helpers للعرض ─────────────────────────────────────────────

  bool get isRecurring => recurringInterval != null;

  bool get isRejected =>
      status == OrderStatus.hospital_rejected ||
      status == OrderStatus.manager_rejected ||
      status == OrderStatus.cancelled;

  /// سبب الرفض (أياً كان مصدره)
  String? get activeRejectionReason => hospitalRejectionReason ?? rejectionReason;

  /// تاريخ الموافقة (أياً كان مصدره)
  DateTime? get activeApprovedAt => hospitalApprovedAt ?? approvedAt;

  String get formattedCreatedAt => _fmt(createdAt);

  String? get formattedApprovedAt =>
      activeApprovedAt == null ? null : _fmt(activeApprovedAt!);

  static String _fmt(DateTime d) {
    final local = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} • ${two(local.hour)}:${two(local.minute)}';
  }
}

// ─── القسم ────────────────────────────────────────────────────────
class DetailDepartment {
  final String id;
  final String name;
  final String type;

  const DetailDepartment({required this.id, required this.name, required this.type});

  factory DetailDepartment.fromJson(Map<String, dynamic> json) {
    return DetailDepartment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}

// ─── مقدم الطلب ───────────────────────────────────────────────────
class DetailRequestedBy {
  final String id;
  final String fullName;

  const DetailRequestedBy({required this.id, required this.fullName});

  factory DetailRequestedBy.fromJson(Map<String, dynamic> json) {
    return DetailRequestedBy(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}

// ─── عنصر الدواء ──────────────────────────────────────────────────
class DetailRequestItem {
  final String id;
  final String variantId;
  final int requestedQuantity;
  final int? approvedQuantity;
  final int? deliveredQuantity;
  final DetailVariant? variant;

  const DetailRequestItem({
    required this.id,
    required this.variantId,
    required this.requestedQuantity,
    this.approvedQuantity,
    this.deliveredQuantity,
    this.variant,
  });

  factory DetailRequestItem.fromJson(Map<String, dynamic> json) {
    return DetailRequestItem(
      id: json['id']?.toString() ?? '',
      variantId: json['variantId']?.toString() ?? '',
      // ✅ الأرقام تأتي كـ String من الباك اند
      requestedQuantity:
          int.tryParse(json['requestedQuantity']?.toString() ?? '') ?? 0,
      approvedQuantity: json['approvedQuantity'] != null
          ? int.tryParse(json['approvedQuantity'].toString())
          : null,
      deliveredQuantity: json['deliveredQuantity'] != null
          ? int.tryParse(json['deliveredQuantity'].toString())
          : null,
      variant: json['variant'] is Map
          ? DetailVariant.fromJson(json['variant'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ─── الـ Variant (التعبئة) ────────────────────────────────────────
class DetailVariant {
  final String id;
  final String variantName;
  final String sku;
  final DetailUnit? unit;
  final DetailProduct? product;

  const DetailVariant({
    required this.id,
    required this.variantName,
    required this.sku,
    this.unit,
    this.product,
  });

  factory DetailVariant.fromJson(Map<String, dynamic> json) {
    return DetailVariant(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      unit: json['unit'] is Map
          ? DetailUnit.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
      product: json['product'] is Map
          ? DetailProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DetailUnit {
  final String id;
  final String name;
  final String abbreviation;

  const DetailUnit({required this.id, required this.name, required this.abbreviation});

  factory DetailUnit.fromJson(Map<String, dynamic> json) {
    return DetailUnit(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      abbreviation: json['abbreviation']?.toString() ?? '',
    );
  }
}

class DetailProduct {
  final String id;
  final String name;
  final String materialType;
  final DetailCategory? category;

  const DetailProduct({
    required this.id,
    required this.name,
    required this.materialType,
    this.category,
  });

  factory DetailProduct.fromJson(Map<String, dynamic> json) {
    return DetailProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
      category: json['category'] is Map
          ? DetailCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DetailCategory {
  final String id;
  final String name;

  const DetailCategory({required this.id, required this.name});

  factory DetailCategory.fromJson(Map<String, dynamic> json) {
    return DetailCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}