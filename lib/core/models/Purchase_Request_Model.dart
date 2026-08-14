// lib/core/models/Purchase_Request_Models.dart
// ignore_for_file: file_names

import 'package:stock_mate_project/core/models/Order_Item.dart'
    show OrderStatus, OrderPriority;

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة طلبات الشراء — List Purchase Requests
/// GET /purchasing/requests
/// ─────────────────────────────────────────────────────────────

class PurchaseRequestsPageData {
  final List<PurchaseRequestListItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PurchaseRequestsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PurchaseRequestsPageData.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (e) => PurchaseRequestListItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── مودل الطلب الواحد (ملخص) ──────────────────────────────────────

class PurchaseRequestListItem {
  final String id;
  final String requestNumber;
  final OrderStatus status;
  final OrderPriority priority;
  final PurchaseRequestedBy? requestedBy;
  final DateTime createdAt;

  const PurchaseRequestListItem({
    required this.id,
    required this.requestNumber,
    required this.status,
    required this.priority,
    this.requestedBy,
    required this.createdAt,
  });

  factory PurchaseRequestListItem.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestListItem(
      id: json['id'] as String? ?? '',
      requestNumber: json['requestNumber'] as String? ?? '',
      status: OrderStatus.fromString(json['status'] as String? ?? 'draft'),
      priority: OrderPriority.fromString(
        json['priority'] as String? ?? 'normal',
      ),
      requestedBy: json['requestedBy'] != null
          ? PurchaseRequestedBy.fromJson(
              json['requestedBy'] as Map<String, dynamic>,
            )
          : null,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  // ─── تسميات عربية للعرض (نفس تصنيف statusLabel بتاع OrderStatus) ──
  String get statusLabel {
    switch (status) {
      case OrderStatus.draft:
        return 'معلق';
      case OrderStatus.pending_hospital_approval:
        return 'بأنتظار موافقتك';
      case OrderStatus.pending_manager_approval:
      case OrderStatus.preparing:
        return 'قيد التنفيذ';
      case OrderStatus.hospital_rejected:
      case OrderStatus.manager_rejected:
      case OrderStatus.cancelled:
        return 'مرفوض';
      case OrderStatus.partially_complete:
      case OrderStatus.complete:
        return 'مستلم';
    }
  }

  String get priorityLabel =>
      priority == OrderPriority.urgent ? 'ضروري' : 'عادي';

  String get formattedCreatedAt {
    final d = createdAt.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }
}

// ─── مقدم الطلب ───────────────────────────────────────────────────

class PurchaseRequestedBy {
  final String id;
  final String fullName;

  const PurchaseRequestedBy({required this.id, required this.fullName});

  factory PurchaseRequestedBy.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestedBy(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// مودل تفاصيل طلب الشراء — Get Purchase Request By Id
/// GET /purchasing/requests/{id}
/// ─────────────────────────────────────────────────────────────

class PurchaseRequestDetails {
  final String id;
  final String requestNumber;
  final String requestedById;
  final OrderStatus status;
  final OrderPriority priority;

  final String? hospitalApprovedById;
  final DateTime? hospitalApprovedAt;
  final String? hospitalRejectionReason;

  final String? approvedById;
  final DateTime? approvedAt;
  final String? rejectionReason;

  final String? notes;

  final DateTime createdAt;
  final DateTime updatedAt;

  final PurchaseRequestedBy? requestedBy;
  final PurchaseRequestedBy? approvedBy;

  final List<PurchaseDetailItem> items;

  const PurchaseRequestDetails({
    required this.id,
    required this.requestNumber,
    required this.requestedById,
    required this.status,
    required this.priority,
    this.hospitalApprovedById,
    this.hospitalApprovedAt,
    this.hospitalRejectionReason,
    this.approvedById,
    this.approvedAt,
    this.rejectionReason,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.requestedBy,
    this.approvedBy,
    required this.items,
  });

  factory PurchaseRequestDetails.fromJson(Map<String, dynamic> json) {
    return PurchaseRequestDetails(
      id: json['id']?.toString() ?? '',
      requestNumber: json['requestNumber']?.toString() ?? '',
      requestedById: json['requestedById']?.toString() ?? '',
      status: OrderStatus.fromString(json['status']?.toString() ?? 'draft'),
      priority: OrderPriority.fromString(
        json['priority']?.toString() ?? 'normal',
      ),
      hospitalApprovedById: json['hospitalApprovedById']?.toString(),
      hospitalApprovedAt: _parseDate(json['hospitalApprovedAt']),
      hospitalRejectionReason: json['hospitalRejectionReason']?.toString(),
      approvedById: json['approvedById']?.toString(),
      approvedAt: _parseDate(json['approvedAt']),
      rejectionReason: json['rejectionReason']?.toString(),
      notes: json['notes']?.toString(),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updatedAt']) ?? DateTime.now(),
      requestedBy: json['requestedBy'] is Map
          ? PurchaseRequestedBy.fromJson(
              json['requestedBy'] as Map<String, dynamic>,
            )
          : null,
      approvedBy: json['approvedBy'] is Map
          ? PurchaseRequestedBy.fromJson(
              json['approvedBy'] as Map<String, dynamic>,
            )
          : null,
      items: (json['items'] as List? ?? [])
          .map((e) => PurchaseDetailItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  // ─── Helpers ─────────────────────────────────────────────────

  bool get isRejected =>
      status == OrderStatus.hospital_rejected ||
      status == OrderStatus.manager_rejected ||
      status == OrderStatus.cancelled;

  String? get activeRejectionReason =>
      hospitalRejectionReason ?? rejectionReason;

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

// ─── عنصر الطلب (Item) ─────────────────────────────────────────────

class PurchaseDetailItem {
  final String id;
  final String variantId;
  final int requestedQuantity;
  final double estimatedPrice;
  final int? approvedQuantity;
  final int receivedQuantity;
  final int quantityDiscrepancy;
  final String? notes;
  final PurchaseVariant? variant;

  const PurchaseDetailItem({
    required this.id,
    required this.variantId,
    required this.requestedQuantity,
    required this.estimatedPrice,
    this.approvedQuantity,
    required this.receivedQuantity,
    required this.quantityDiscrepancy,
    this.notes,
    this.variant,
  });

  factory PurchaseDetailItem.fromJson(Map<String, dynamic> json) {
    return PurchaseDetailItem(
      id: json['id']?.toString() ?? '',
      variantId: json['variantId']?.toString() ?? '',
      requestedQuantity:
          int.tryParse(json['requestedQuantity']?.toString() ?? '') ?? 0,
      estimatedPrice:
          double.tryParse(json['estimatedPrice']?.toString() ?? '') ?? 0,
      approvedQuantity: json['approvedQuantity'] != null
          ? int.tryParse(json['approvedQuantity'].toString())
          : null,
      receivedQuantity:
          int.tryParse(json['receivedQuantity']?.toString() ?? '') ?? 0,
      quantityDiscrepancy:
          int.tryParse(json['quantityDiscrepancy']?.toString() ?? '') ?? 0,
      notes: json['notes']?.toString(),
      variant: json['variant'] is Map
          ? PurchaseVariant.fromJson(json['variant'] as Map<String, dynamic>)
          : null,
    );
  }
}

// ─── الـ Variant (التعبئة) ────────────────────────────────────────

class PurchaseVariant {
  final String id;
  final String variantName;
  final String sku;
  final PurchaseUnit? unit;
  final PurchaseProduct? product;

  const PurchaseVariant({
    required this.id,
    required this.variantName,
    required this.sku,
    this.unit,
    this.product,
  });

  factory PurchaseVariant.fromJson(Map<String, dynamic> json) {
    return PurchaseVariant(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      unit: json['unit'] is Map
          ? PurchaseUnit.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
      product: json['product'] is Map
          ? PurchaseProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PurchaseUnit {
  final String id;
  final String name;
  final String abbreviation;

  const PurchaseUnit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory PurchaseUnit.fromJson(Map<String, dynamic> json) {
    return PurchaseUnit(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      abbreviation: json['abbreviation']?.toString() ?? '',
    );
  }
}

class PurchaseProduct {
  final String id;
  final String name;
  final String materialType;
  final PurchaseCategory? category;

  const PurchaseProduct({
    required this.id,
    required this.name,
    required this.materialType,
    this.category,
  });

  factory PurchaseProduct.fromJson(Map<String, dynamic> json) {
    return PurchaseProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
      category: json['category'] is Map
          ? PurchaseCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PurchaseCategory {
  final String id;
  final String name;

  const PurchaseCategory({required this.id, required this.name});

  factory PurchaseCategory.fromJson(Map<String, dynamic> json) {
    return PurchaseCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
