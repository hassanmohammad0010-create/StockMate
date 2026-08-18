// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// enum نوع التسوية — AdjustmentType
/// ─────────────────────────────────────────────────────────────

enum AdjustmentType {
  shrinkage,
  damaged,
  found,
  expired;

  static AdjustmentType fromString(String value) {
    return AdjustmentType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => AdjustmentType.damaged,
    );
  }

  /// ✅ التسمية العربية
  String get label {
    switch (this) {
      case AdjustmentType.shrinkage:
        return 'نقص / فقد';
      case AdjustmentType.damaged:
        return 'تالف';
      case AdjustmentType.found:
        return 'زيادة مخزنية';
      case AdjustmentType.expired:
        return 'منتهي الصلاحية';
    }
  }

  /// ✅ أيقونة لكل نوع
  String get iconKey {
    switch (this) {
      case AdjustmentType.shrinkage:
        return 'remove';
      case AdjustmentType.damaged:
        return 'broken';
      case AdjustmentType.found:
        return 'add';
      case AdjustmentType.expired:
        return 'event_busy';
    }
  }

  /// هل هو نوع سالب (خسارة)؟
  bool get isLoss =>
      this == AdjustmentType.shrinkage ||
      this == AdjustmentType.damaged ||
      this == AdjustmentType.expired;
}

/// ─────────────────────────────────────────────────────────────
/// مودل سجل التسويات — Inventory Adjustments
/// GET /inventory/adjustments
/// ─────────────────────────────────────────────────────────────

class InventoryAdjustmentsPageData {
  final List<InventoryAdjustment> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const InventoryAdjustmentsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory InventoryAdjustmentsPageData.fromJson(Map<String, dynamic> json) {
    return InventoryAdjustmentsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => InventoryAdjustment.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── تسوية واحدة ───────────────────────────────────────────────────

class InventoryAdjustment {
  final String id;
  final String variantId;
  final String departmentId;
  final String batchId;
  final AdjustmentType adjustmentType;
  final int quantity; // ✅ يُحوَّل من String
  final String notes;
  final DateTime createdAt;
  final AdjustmentVariant? variant;
  final AdjustmentDepartment? department;
  final AdjustmentBatch? batch;
  final AdjustmentPerson? reportedBy;

  const InventoryAdjustment({
    required this.id,
    required this.variantId,
    required this.departmentId,
    required this.batchId,
    required this.adjustmentType,
    required this.quantity,
    required this.notes,
    required this.createdAt,
    this.variant,
    this.department,
    this.batch,
    this.reportedBy,
  });

  factory InventoryAdjustment.fromJson(Map<String, dynamic> json) {
    return InventoryAdjustment(
      id: json['id']?.toString() ?? '',
      variantId: json['variantId']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      batchId: json['batchId']?.toString() ?? '',
      adjustmentType: AdjustmentType.fromString(
        json['adjustmentType']?.toString() ?? 'damaged',
      ),
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      notes: json['notes']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      variant: json['variant'] is Map
          ? AdjustmentVariant.fromJson(json['variant'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map
          ? AdjustmentDepartment.fromJson(
              json['department'] as Map<String, dynamic>)
          : null,
      batch: json['batch'] is Map
          ? AdjustmentBatch.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
      reportedBy: json['reportedBy'] is Map
          ? AdjustmentPerson.fromJson(json['reportedBy'] as Map<String, dynamic>)
          : null,
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────

  /// اسم المادة
  String get displayName => variant?.variantName ?? '—';

  /// اسم المنتج الأساسي
  String get productName => variant?.product?.name ?? '';

  /// رمز الصنف
  String get sku => variant?.sku ?? '—';

  /// الفئة
  String get categoryName => variant?.product?.category?.name ?? '—';

  /// اختصار الوحدة
  String get unitAbbreviation => variant?.unit?.abbreviation ?? '';

  /// رقم الدفعة
  String get batchNumber => batch?.batchNumber ?? '—';

  /// اسم القسم
  String get departmentName => department?.name ?? '—';

  /// من أبلغ
  String get reportedByName => reportedBy?.fullName ?? '—';

  /// هل توجد ملاحظات؟
  bool get hasNotes => notes.trim().isNotEmpty;

  /// تنسيق التاريخ
  String get formattedCreatedAt {
    final d = createdAt.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  /// التاريخ فقط
  String get formattedDateOnly {
    final d = createdAt.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}

// ─── الصنف (Variant) ───────────────────────────────────────────────
class AdjustmentVariant {
  final String id;
  final String variantName;
  final String sku;
  final AdjustmentUnit? unit;
  final AdjustmentProduct? product;

  const AdjustmentVariant({
    required this.id,
    required this.variantName,
    required this.sku,
    this.unit,
    this.product,
  });

  factory AdjustmentVariant.fromJson(Map<String, dynamic> json) {
    return AdjustmentVariant(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      unit: json['unit'] is Map
          ? AdjustmentUnit.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
      product: json['product'] is Map
          ? AdjustmentProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AdjustmentUnit {
  final String id;
  final String name;
  final String abbreviation;

  const AdjustmentUnit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory AdjustmentUnit.fromJson(Map<String, dynamic> json) {
    return AdjustmentUnit(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      abbreviation: json['abbreviation']?.toString() ?? '',
    );
  }
}

class AdjustmentProduct {
  final String id;
  final String name;
  final String materialType;
  final AdjustmentCategory? category;

  const AdjustmentProduct({
    required this.id,
    required this.name,
    required this.materialType,
    this.category,
  });

  factory AdjustmentProduct.fromJson(Map<String, dynamic> json) {
    return AdjustmentProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
      category: json['category'] is Map
          ? AdjustmentCategory.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }
}

class AdjustmentCategory {
  final String id;
  final String name;

  const AdjustmentCategory({required this.id, required this.name});

  factory AdjustmentCategory.fromJson(Map<String, dynamic> json) {
    return AdjustmentCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class AdjustmentDepartment {
  final String id;
  final String name;

  const AdjustmentDepartment({required this.id, required this.name});

  factory AdjustmentDepartment.fromJson(Map<String, dynamic> json) {
    return AdjustmentDepartment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

class AdjustmentBatch {
  final String id;
  final String batchNumber;

  const AdjustmentBatch({required this.id, required this.batchNumber});

  factory AdjustmentBatch.fromJson(Map<String, dynamic> json) {
    return AdjustmentBatch(
      id: json['id']?.toString() ?? '',
      batchNumber: json['batchNumber']?.toString() ?? '',
    );
  }
}

class AdjustmentPerson {
  final String id;
  final String fullName;

  const AdjustmentPerson({required this.id, required this.fullName});

  factory AdjustmentPerson.fromJson(Map<String, dynamic> json) {
    return AdjustmentPerson(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}