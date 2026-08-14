// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل المخزون الحي — Live Stock
/// GET /inventory/department-inventory/live-stock
/// ─────────────────────────────────────────────────────────────

enum MaterialCategory {
  consumable,
  fixed,
  medicine;

  static MaterialCategory fromString(String value) {
    return MaterialCategory.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => MaterialCategory.consumable,
    );
  }
}

enum BatchStatus { valid, expiringSoon, expired }

// ─── صفحة النتائج ───────────────────────────────────────────────

class LiveStockPageData {
  final List<MaterialItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const LiveStockPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory LiveStockPageData.fromJson(Map<String, dynamic> json) {
    return LiveStockPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => MaterialItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── الصنف (Batch) ──────────────────────────────────────────────

class MaterialBatch {
  final String batchId;
  final String batchNumber;
  final int quantity;
  final DateTime expiryDate;

  MaterialBatch({
    required this.batchId,
    required this.batchNumber,
    required this.quantity,
    required this.expiryDate,
  });

  BatchStatus get status {
    final diff = expiryDate.difference(DateTime.now()).inDays;
    if (diff < 0) return BatchStatus.expired;
    if (diff <= 90) return BatchStatus.expiringSoon;
    return BatchStatus.valid;
  }

  String get statusLabel {
    switch (status) {
      case BatchStatus.valid:
        return 'صالحة';
      case BatchStatus.expiringSoon:
        return 'تنتهي قريباً';
      case BatchStatus.expired:
        return 'منتهية';
    }
  }

  factory MaterialBatch.fromJson(Map<String, dynamic> json) {
    return MaterialBatch(
      batchId: json['batchId']?.toString() ?? '',
      batchNumber: json['batchNumber']?.toString() ?? '',
      quantity: json['quantity'] as int? ?? 0,
      expiryDate:
          DateTime.tryParse(json['expirationDate'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

// ─── الوحدة ───────────────────────────────────────────────────

class MaterialUnit {
  final String id;
  final String name;
  final String abbreviation;

  const MaterialUnit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory MaterialUnit.fromJson(Map<String, dynamic> json) {
    return MaterialUnit(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      abbreviation: json['abbreviation']?.toString() ?? '',
    );
  }
}

// ─── فئة المنتج (Category) ─────────────────────────────────────

class MaterialProductCategory {
  final String id;
  final String name;

  const MaterialProductCategory({required this.id, required this.name});

  factory MaterialProductCategory.fromJson(Map<String, dynamic> json) {
    return MaterialProductCategory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ─── المنتج ───────────────────────────────────────────────────

class MaterialProduct {
  final String id;
  final String name;
  final MaterialCategory materialType;
  final MaterialProductCategory? category;

  const MaterialProduct({
    required this.id,
    required this.name,
    required this.materialType,
    this.category,
  });

  factory MaterialProduct.fromJson(Map<String, dynamic> json) {
    return MaterialProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      materialType: MaterialCategory.fromString(
        json['materialType']?.toString() ?? 'consumable',
      ),
      category: json['category'] is Map
          ? MaterialProductCategory.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

// ─── الصنف الرئيسي (Variant) ──────────────────────────────────

class MaterialItem {
  final String variantId;
  final String variantName;
  final String sku;
  final MaterialUnit? unit;
  final MaterialProduct? product;
  final int totalQuantity;
  final int minQuantity;
  final int maxQuantity;
  final List<MaterialBatch> batches;

  MaterialItem({
    required this.variantId,
    required this.variantName,
    required this.sku,
    this.unit,
    this.product,
    required this.totalQuantity,
    required this.minQuantity,
    required this.maxQuantity,
    required this.batches,
  });

  factory MaterialItem.fromJson(Map<String, dynamic> json) {
    return MaterialItem(
      variantId: json['variantId']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      unit: json['unit'] is Map
          ? MaterialUnit.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
      product: json['product'] is Map
          ? MaterialProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      totalQuantity: json['totalQuantity'] as int? ?? 0,
      minQuantity: json['minimumStock'] as int? ?? 0,
      maxQuantity: json['maximumStock'] as int? ?? 0,
      batches: (json['batches'] as List<dynamic>? ?? [])
          .map((b) => MaterialBatch.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }

  // ─── Helpers للعرض ─────────────────────────────────────────

  /// اسم المنتج الأساسي (لو موجود) وإلا اسم الصنف الفرعي
  String get name => product?.name ?? variantName;

  MaterialCategory get category =>
      product?.materialType ?? MaterialCategory.consumable;

  String get categoryLabel {
    switch (category) {
      case MaterialCategory.consumable:
        return 'مستهلك';
      case MaterialCategory.fixed:
        return 'ثابت';
      case MaterialCategory.medicine:
        return 'دواء';
    }
  }

  /// اسم الفئة الفرعية (زي "Medical Supplies") لو موجود
  String? get subCategoryLabel => product?.category?.name;

  int get validQuantity => batches
      .where((b) => b.status == BatchStatus.valid)
      .fold(0, (sum, b) => sum + b.quantity);

  int get expiringSoonQuantity => batches
      .where((b) => b.status == BatchStatus.expiringSoon)
      .fold(0, (sum, b) => sum + b.quantity);

  double get fillRatio => maxQuantity == 0 ? 0 : totalQuantity / maxQuantity;

  bool get isBelowMinimum => totalQuantity < minQuantity;
}
