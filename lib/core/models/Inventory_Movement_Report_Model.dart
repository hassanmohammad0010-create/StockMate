// lib/core/models/Inventory_Movement_Report_Model.dart
// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل تقرير حركة المخزون — Inventory Movement Report
/// GET /reports/inventory-movement
/// ─────────────────────────────────────────────────────────────

class InventoryMovementReport {
  final MovementSummary summary;
  final List<DepartmentMovementSummary> byDepartment;
  final List<MovementSeriesPoint> series;
  final MovementRowsPageData rows;
  final String groupBy;

  const InventoryMovementReport({
    required this.summary,
    required this.byDepartment,
    required this.series,
    required this.rows,
    required this.groupBy,
  });

  factory InventoryMovementReport.fromJson(Map<String, dynamic> json) {
    return InventoryMovementReport(
      summary: MovementSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      byDepartment: (json['byDepartment'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                DepartmentMovementSummary.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      series: (json['series'] as List<dynamic>? ?? [])
          .map((e) => MovementSeriesPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      rows: MovementRowsPageData.fromJson(
        json['rows'] as Map<String, dynamic>? ?? {},
      ),
      groupBy: json['groupBy'] as String? ?? 'day',
    );
  }
}

// ─── الملخص العام ────────────────────────────────────────────────

class MovementSummary {
  final int totalTransactions;
  final int totalQuantityIn;
  final int totalQuantityOut;
  final int netQuantity;
  final List<TransactionTypeSummary> byTransactionType;

  const MovementSummary({
    required this.totalTransactions,
    required this.totalQuantityIn,
    required this.totalQuantityOut,
    required this.netQuantity,
    required this.byTransactionType,
  });

  factory MovementSummary.fromJson(Map<String, dynamic> json) {
    return MovementSummary(
      totalTransactions: json['totalTransactions'] as int? ?? 0,
      totalQuantityIn: json['totalQuantityIn'] as int? ?? 0,
      totalQuantityOut: json['totalQuantityOut'] as int? ?? 0,
      netQuantity: json['netQuantity'] as int? ?? 0,
      byTransactionType: (json['byTransactionType'] as List<dynamic>? ?? [])
          .map(
            (e) => TransactionTypeSummary.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class TransactionTypeSummary {
  final String transactionType;
  final int count;
  final int totalQuantity;

  const TransactionTypeSummary({
    required this.transactionType,
    required this.count,
    required this.totalQuantity,
  });

  factory TransactionTypeSummary.fromJson(Map<String, dynamic> json) {
    return TransactionTypeSummary(
      transactionType: json['transactionType'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      totalQuantity: json['totalQuantity'] as int? ?? 0,
    );
  }

  /// تسمية عربية لنوع الحركة
  String get arabicLabel {
    const map = {
      'purchase_receipt': 'استلام مشتريات',
      'department_transfer_out': 'تحويل صادر لقسم',
      'department_transfer_in': 'تحويل وارد لقسم',
      'prescription_dispense': 'صرف وصفة طبية',
      'department_consumption': 'استهلاك القسم',
      'adjustment_damaged': 'تسوية - تالف',
      'adjustment_expired': 'تسوية - منتهي الصلاحية',
      'adjustment_shrinkage': 'تسوية - عجز',
      'adjustment_found': 'تسوية - زيادة',
    };
    return map[transactionType] ?? transactionType;
  }
}

// ─── حسب القسم ──────────────────────────────────────────────────

class DepartmentMovementSummary {
  final String departmentId;
  final String departmentName;
  final int count;
  final int quantityIn;
  final int quantityOut;

  const DepartmentMovementSummary({
    required this.departmentId,
    required this.departmentName,
    required this.count,
    required this.quantityIn,
    required this.quantityOut,
  });

  factory DepartmentMovementSummary.fromJson(Map<String, dynamic> json) {
    return DepartmentMovementSummary(
      departmentId: json['departmentId'] as String? ?? '',
      departmentName: json['departmentName'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      quantityIn: json['quantityIn'] as int? ?? 0,
      quantityOut: json['quantityOut'] as int? ?? 0,
    );
  }

  int get net => quantityIn - quantityOut;
}

// ─── السلسلة الزمنية ─────────────────────────────────────────────

class MovementSeriesPoint {
  final String bucket;
  final int quantityIn;
  final int quantityOut;

  const MovementSeriesPoint({
    required this.bucket,
    required this.quantityIn,
    required this.quantityOut,
  });

  factory MovementSeriesPoint.fromJson(Map<String, dynamic> json) {
    return MovementSeriesPoint(
      bucket: json['bucket'] as String? ?? '',
      quantityIn: json['quantityIn'] as int? ?? 0,
      quantityOut: json['quantityOut'] as int? ?? 0,
    );
  }

  int get net => quantityIn - quantityOut;
}

// ─── صفحة الصفوف التفصيلية ──────────────────────────────────────

class MovementRowsPageData {
  final List<MovementRow> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const MovementRowsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory MovementRowsPageData.fromJson(Map<String, dynamic> json) {
    return MovementRowsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => MovementRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 0,
    );
  }
}

class MovementRow {
  final String id;
  final String transactionType;
  final int quantity;
  final int balanceAfter;
  final DateTime transactionDate;
  final String? notes;
  final MovementVariantInfo? variant;
  final MovementBatchInfo? batch;
  final MovementDepartmentInfo? department;
  final MovementUserInfo? performedBy;

  const MovementRow({
    required this.id,
    required this.transactionType,
    required this.quantity,
    required this.balanceAfter,
    required this.transactionDate,
    this.notes,
    this.variant,
    this.batch,
    this.department,
    this.performedBy,
  });

  factory MovementRow.fromJson(Map<String, dynamic> json) {
    return MovementRow(
      id: json['id']?.toString() ?? '',
      transactionType: json['transactionType']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      balanceAfter: int.tryParse(json['balanceAfter']?.toString() ?? '') ?? 0,
      transactionDate:
          DateTime.tryParse(json['transactionDate']?.toString() ?? '') ??
          DateTime.now(),
      notes: json['notes']?.toString(),
      variant: json['variant'] is Map
          ? MovementVariantInfo.fromJson(
              json['variant'] as Map<String, dynamic>,
            )
          : null,
      batch: json['batch'] is Map
          ? MovementBatchInfo.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map
          ? MovementDepartmentInfo.fromJson(
              json['department'] as Map<String, dynamic>,
            )
          : null,
      performedBy: json['performedBy'] is Map
          ? MovementUserInfo.fromJson(
              json['performedBy'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  String get arabicTypeLabel {
    const map = {
      'purchase_receipt': 'استلام مشتريات',
      'department_transfer_out': 'تحويل صادر لقسم',
      'department_transfer_in': 'تحويل وارد لقسم',
      'prescription_dispense': 'صرف وصفة طبية',
      'department_consumption': 'استهلاك القسم',
      'adjustment_damaged': 'تسوية - تالف',
      'adjustment_expired': 'تسوية - منتهي الصلاحية',
      'adjustment_shrinkage': 'تسوية - عجز',
      'adjustment_found': 'تسوية - زيادة',
    };
    return map[transactionType] ?? transactionType;
  }
}

class MovementVariantInfo {
  final String id;
  final String variantName;
  final String sku;

  const MovementVariantInfo({
    required this.id,
    required this.variantName,
    required this.sku,
  });

  factory MovementVariantInfo.fromJson(Map<String, dynamic> json) {
    return MovementVariantInfo(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
    );
  }
}

class MovementBatchInfo {
  final String id;
  final String batchNumber;

  const MovementBatchInfo({required this.id, required this.batchNumber});

  factory MovementBatchInfo.fromJson(Map<String, dynamic> json) {
    return MovementBatchInfo(
      id: json['id']?.toString() ?? '',
      batchNumber: json['batchNumber']?.toString() ?? '',
    );
  }
}

class MovementDepartmentInfo {
  final String id;
  final String name;

  const MovementDepartmentInfo({required this.id, required this.name});

  factory MovementDepartmentInfo.fromJson(Map<String, dynamic> json) {
    return MovementDepartmentInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class MovementUserInfo {
  final String id;
  final String fullName;

  const MovementUserInfo({required this.id, required this.fullName});

  factory MovementUserInfo.fromJson(Map<String, dynamic> json) {
    return MovementUserInfo(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}
