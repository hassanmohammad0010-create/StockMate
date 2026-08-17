// lib/core/models/Inventory_Transaction_Model.dart
// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة حركات المخزون التفصيلية — Inventory Transactions
/// GET /inventory/transactions
/// ─────────────────────────────────────────────────────────────

class InventoryTransactionsPageData {
  final List<InventoryTransactionItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const InventoryTransactionsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory InventoryTransactionsPageData.fromJson(Map<String, dynamic> json) {
    return InventoryTransactionsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (e) => InventoryTransactionItem.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── الحركة الواحدة ─────────────────────────────────────────────

class InventoryTransactionItem {
  final String id;
  final String transactionType;
  final String variantId;
  final String batchId;
  final String departmentId;
  final int quantity;
  final int balanceAfter;
  final String referenceType;
  final String? referenceId;
  final DateTime transactionDate;
  final String? notes;
  final TransactionVariantInfo? variant;
  final TransactionBatchInfo? batch;
  final TransactionDepartmentInfo? department;
  final TransactionUserInfo? performedBy;

  const InventoryTransactionItem({
    required this.id,
    required this.transactionType,
    required this.variantId,
    required this.batchId,
    required this.departmentId,
    required this.quantity,
    required this.balanceAfter,
    required this.referenceType,
    this.referenceId,
    required this.transactionDate,
    this.notes,
    this.variant,
    this.batch,
    this.department,
    this.performedBy,
  });

  factory InventoryTransactionItem.fromJson(Map<String, dynamic> json) {
    return InventoryTransactionItem(
      id: json['id']?.toString() ?? '',
      transactionType: json['transactionType']?.toString() ?? '',
      variantId: json['variantId']?.toString() ?? '',
      batchId: json['batchId']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      balanceAfter: int.tryParse(json['balanceAfter']?.toString() ?? '') ?? 0,
      referenceType: json['referenceType']?.toString() ?? '',
      referenceId: json['referenceId']?.toString(),
      transactionDate:
          DateTime.tryParse(json['transactionDate']?.toString() ?? '') ??
          DateTime.now(),
      notes: json['notes']?.toString(),
      variant: json['variant'] is Map
          ? TransactionVariantInfo.fromJson(
              json['variant'] as Map<String, dynamic>,
            )
          : null,
      batch: json['batch'] is Map
          ? TransactionBatchInfo.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map
          ? TransactionDepartmentInfo.fromJson(
              json['department'] as Map<String, dynamic>,
            )
          : null,
      performedBy: json['performedBy'] is Map
          ? TransactionUserInfo.fromJson(
              json['performedBy'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// تسمية عربية لنوع الحركة
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

  String get formattedDate {
    final d = transactionDate.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  bool get isIncoming => quantity > 0;
}

// ─── الصنف (Variant) مع المنتج والوحدة ──────────────────────────

class TransactionVariantInfo {
  final String id;
  final String variantName;
  final String sku;
  final TransactionUnitInfo? unit;
  final TransactionProductInfo? product;

  const TransactionVariantInfo({
    required this.id,
    required this.variantName,
    required this.sku,
    this.unit,
    this.product,
  });

  factory TransactionVariantInfo.fromJson(Map<String, dynamic> json) {
    return TransactionVariantInfo(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      unit: json['unit'] is Map
          ? TransactionUnitInfo.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
      product: json['product'] is Map
          ? TransactionProductInfo.fromJson(
              json['product'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class TransactionUnitInfo {
  final String id;
  final String name;
  final String abbreviation;

  const TransactionUnitInfo({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory TransactionUnitInfo.fromJson(Map<String, dynamic> json) {
    return TransactionUnitInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      abbreviation: json['abbreviation']?.toString() ?? '',
    );
  }
}

class TransactionProductInfo {
  final String id;
  final String name;
  final String materialType;
  final TransactionCategoryInfo? category;

  const TransactionProductInfo({
    required this.id,
    required this.name,
    required this.materialType,
    this.category,
  });

  factory TransactionProductInfo.fromJson(Map<String, dynamic> json) {
    return TransactionProductInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
      category: json['category'] is Map
          ? TransactionCategoryInfo.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class TransactionCategoryInfo {
  final String id;
  final String name;

  const TransactionCategoryInfo({required this.id, required this.name});

  factory TransactionCategoryInfo.fromJson(Map<String, dynamic> json) {
    return TransactionCategoryInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ─── الدفعة ──────────────────────────────────────────────────────

class TransactionBatchInfo {
  final String id;
  final String batchNumber;

  const TransactionBatchInfo({required this.id, required this.batchNumber});

  factory TransactionBatchInfo.fromJson(Map<String, dynamic> json) {
    return TransactionBatchInfo(
      id: json['id']?.toString() ?? '',
      batchNumber: json['batchNumber']?.toString() ?? '',
    );
  }
}

// ─── القسم ───────────────────────────────────────────────────────

class TransactionDepartmentInfo {
  final String id;
  final String name;

  const TransactionDepartmentInfo({required this.id, required this.name});

  factory TransactionDepartmentInfo.fromJson(Map<String, dynamic> json) {
    return TransactionDepartmentInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ─── مستخدم منفذ العملية ────────────────────────────────────────

class TransactionUserInfo {
  final String id;
  final String fullName;

  const TransactionUserInfo({required this.id, required this.fullName});

  factory TransactionUserInfo.fromJson(Map<String, dynamic> json) {
    return TransactionUserInfo(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}
