// lib/core/models/Adjustments_Report_Model.dart
// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// نوع التسوية (Adjustment Type)
/// ─────────────────────────────────────────────────────────────

enum AdjustmentType {
  damaged,
  expired,
  shrinkage,
  found;

  static AdjustmentType fromString(String value) {
    return AdjustmentType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => AdjustmentType.damaged,
    );
  }
}

extension AdjustmentTypeX on AdjustmentType {
  String get arabicLabel {
    switch (this) {
      case AdjustmentType.damaged:
        return 'تالف';
      case AdjustmentType.expired:
        return 'منتهي الصلاحية';
      case AdjustmentType.shrinkage:
        return 'نقص/فقدان';
      case AdjustmentType.found:
        return 'موجود (إضافة)';
    }
  }
}

/// ─────────────────────────────────────────────────────────────
/// الملخص العام
/// ─────────────────────────────────────────────────────────────

class AdjustmentTypeSummary {
  final AdjustmentType adjustmentType;
  final int count;
  final int totalQuantity;

  const AdjustmentTypeSummary({
    required this.adjustmentType,
    required this.count,
    required this.totalQuantity,
  });

  factory AdjustmentTypeSummary.fromJson(Map<String, dynamic> json) {
    return AdjustmentTypeSummary(
      adjustmentType: AdjustmentType.fromString(
        json['adjustmentType'] as String? ?? 'damaged',
      ),
      count: json['count'] as int? ?? 0,
      totalQuantity: json['totalQuantity'] as int? ?? 0,
    );
  }

  String get arabicLabel => adjustmentType.arabicLabel;
}

class AdjustmentsSummary {
  final int totalAdjustments;
  final int totalQuantity;
  final List<AdjustmentTypeSummary> byAdjustmentType;

  const AdjustmentsSummary({
    required this.totalAdjustments,
    required this.totalQuantity,
    required this.byAdjustmentType,
  });

  factory AdjustmentsSummary.fromJson(Map<String, dynamic> json) {
    return AdjustmentsSummary(
      totalAdjustments: json['totalAdjustments'] as int? ?? 0,
      totalQuantity: json['totalQuantity'] as int? ?? 0,
      byAdjustmentType: (json['byAdjustmentType'] as List<dynamic>? ?? [])
          .map((e) => AdjustmentTypeSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// التوزيع حسب القسم
/// ─────────────────────────────────────────────────────────────

class AdjustmentDepartmentSummary {
  final String departmentId;
  final String departmentName;
  final int count;
  final int quantityIncreased;
  final int quantityDecreased;

  const AdjustmentDepartmentSummary({
    required this.departmentId,
    required this.departmentName,
    required this.count,
    required this.quantityIncreased,
    required this.quantityDecreased,
  });

  factory AdjustmentDepartmentSummary.fromJson(Map<String, dynamic> json) {
    return AdjustmentDepartmentSummary(
      departmentId: json['departmentId'] as String? ?? '',
      departmentName: json['departmentName'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      quantityIncreased: json['quantityIncreased'] as int? ?? 0,
      quantityDecreased: json['quantityDecreased'] as int? ?? 0,
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// السلسلة الزمنية
/// ─────────────────────────────────────────────────────────────

class AdjustmentSeriesPoint {
  final String bucket;
  final int quantityIncreased;
  final int quantityDecreased;

  const AdjustmentSeriesPoint({
    required this.bucket,
    required this.quantityIncreased,
    required this.quantityDecreased,
  });

  factory AdjustmentSeriesPoint.fromJson(Map<String, dynamic> json) {
    return AdjustmentSeriesPoint(
      bucket: json['bucket'] as String? ?? '',
      quantityIncreased: json['quantityIncreased'] as int? ?? 0,
      quantityDecreased: json['quantityDecreased'] as int? ?? 0,
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// عناصر مساعدة (Variant / Batch / Department / User)
/// ─────────────────────────────────────────────────────────────

class AdjustmentVariantInfo {
  final String id;
  final String variantName;
  final String sku;

  const AdjustmentVariantInfo({
    required this.id,
    required this.variantName,
    required this.sku,
  });

  factory AdjustmentVariantInfo.fromJson(Map<String, dynamic> json) {
    return AdjustmentVariantInfo(
      id: json['id'] as String? ?? '',
      variantName: json['variantName'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
    );
  }
}

class AdjustmentBatchInfo {
  final String id;
  final String batchNumber;

  const AdjustmentBatchInfo({required this.id, required this.batchNumber});

  factory AdjustmentBatchInfo.fromJson(Map<String, dynamic> json) {
    return AdjustmentBatchInfo(
      id: json['id'] as String? ?? '',
      batchNumber: json['batchNumber'] as String? ?? '',
    );
  }
}

class AdjustmentDepartmentInfo {
  final String id;
  final String name;

  const AdjustmentDepartmentInfo({required this.id, required this.name});

  factory AdjustmentDepartmentInfo.fromJson(Map<String, dynamic> json) {
    return AdjustmentDepartmentInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class AdjustmentUserInfo {
  final String id;
  final String fullName;

  const AdjustmentUserInfo({required this.id, required this.fullName});

  factory AdjustmentUserInfo.fromJson(Map<String, dynamic> json) {
    return AdjustmentUserInfo(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// صف واحد من جدول تفاصيل التسويات
/// ─────────────────────────────────────────────────────────────

class AdjustmentRow {
  final String id;
  final String variantId;
  final String departmentId;
  final String? batchId;
  final AdjustmentType adjustmentType;
  final int quantity;
  final String? notes;
  final DateTime createdAt;
  final AdjustmentVariantInfo? variant;
  final AdjustmentBatchInfo? batch;
  final AdjustmentDepartmentInfo? department;
  final AdjustmentUserInfo? reportedBy;

  const AdjustmentRow({
    required this.id,
    required this.variantId,
    required this.departmentId,
    this.batchId,
    required this.adjustmentType,
    required this.quantity,
    this.notes,
    required this.createdAt,
    this.variant,
    this.batch,
    this.department,
    this.reportedBy,
  });

  factory AdjustmentRow.fromJson(Map<String, dynamic> json) {
    return AdjustmentRow(
      id: json['id'] as String? ?? '',
      variantId: json['variantId'] as String? ?? '',
      departmentId: json['departmentId'] as String? ?? '',
      batchId: json['batchId'] as String?,
      // ✅ الكمية جايه كـ String من الـ API ("10")، فبنحولها بأمان
      adjustmentType: AdjustmentType.fromString(
        json['adjustmentType'] as String? ?? 'damaged',
      ),
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      notes: json['notes'] as String?,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      variant: json['variant'] is Map
          ? AdjustmentVariantInfo.fromJson(
              json['variant'] as Map<String, dynamic>,
            )
          : null,
      batch: json['batch'] is Map
          ? AdjustmentBatchInfo.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map
          ? AdjustmentDepartmentInfo.fromJson(
              json['department'] as Map<String, dynamic>,
            )
          : null,
      reportedBy: json['reportedBy'] is Map
          ? AdjustmentUserInfo.fromJson(
              json['reportedBy'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  String get arabicTypeLabel => adjustmentType.arabicLabel;
}

class AdjustmentsRowsPage {
  final List<AdjustmentRow> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const AdjustmentsRowsPage({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory AdjustmentsRowsPage.fromJson(Map<String, dynamic> json) {
    return AdjustmentsRowsPage(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => AdjustmentRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

/// ─────────────────────────────────────────────────────────────
/// التقرير الكامل — GET /reports/adjustments
/// ─────────────────────────────────────────────────────────────

class AdjustmentsReport {
  final AdjustmentsSummary summary;
  final List<AdjustmentDepartmentSummary> byDepartment;
  final List<AdjustmentSeriesPoint> series;
  final AdjustmentsRowsPage rows;
  final String groupBy;

  const AdjustmentsReport({
    required this.summary,
    required this.byDepartment,
    required this.series,
    required this.rows,
    required this.groupBy,
  });

  factory AdjustmentsReport.fromJson(Map<String, dynamic> json) {
    return AdjustmentsReport(
      summary: AdjustmentsSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      byDepartment: (json['byDepartment'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                AdjustmentDepartmentSummary.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      series: (json['series'] as List<dynamic>? ?? [])
          .map((e) => AdjustmentSeriesPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      rows: AdjustmentsRowsPage.fromJson(
        json['rows'] as Map<String, dynamic>? ?? {},
      ),
      groupBy: json['groupBy'] as String? ?? 'day',
    );
  }
}
