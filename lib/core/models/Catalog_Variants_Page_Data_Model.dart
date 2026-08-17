// lib/core/models/Catalog_Variant_Model.dart
// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة الأصناف (Variants) — Catalog Variants
/// GET /catalog/variants
/// ─────────────────────────────────────────────────────────────

class CatalogVariantsPageData {
  final List<CatalogVariant> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const CatalogVariantsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory CatalogVariantsPageData.fromJson(Map<String, dynamic> json) {
    return CatalogVariantsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => CatalogVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── الصنف الواحد (Variant) ─────────────────────────────────────

class CatalogVariant {
  final String id;
  final String productId;
  final String variantName;
  final String sku;
  final String unitId;
  final bool isActive;
  final CatalogProduct? product;
  final CatalogUnit? unit;

  const CatalogVariant({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.sku,
    required this.unitId,
    required this.isActive,
    this.product,
    this.unit,
  });

  factory CatalogVariant.fromJson(Map<String, dynamic> json) {
    return CatalogVariant(
      id: json['id'] as String? ?? '',
      productId: json['productId'] as String? ?? '',
      variantName: json['variantName'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      unitId: json['unitId'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      product: json['product'] is Map
          ? CatalogProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      unit: json['unit'] is Map
          ? CatalogUnit.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
    );
  }

  /// اسم المنتج الأساسي (لو موجود) وإلا اسم الصنف الفرعي
  String get displayName => product?.name ?? variantName;
}

// ─── المنتج الأساسي ─────────────────────────────────────────────

class CatalogProduct {
  final String id;
  final String name;
  final String materialType;

  const CatalogProduct({
    required this.id,
    required this.name,
    required this.materialType,
  });

  factory CatalogProduct.fromJson(Map<String, dynamic> json) {
    return CatalogProduct(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      materialType: json['materialType'] as String? ?? '',
    );
  }

  /// تسمية عربية لنوع المادة
  String get materialTypeLabel {
    switch (materialType) {
      case 'consumable':
        return 'مستهلك';
      case 'fixed_asset':
        return 'أصل ثابت';
      case 'medicine':
        return 'دواء';
      default:
        return materialType;
    }
  }
}

// ─── الوحدة ───────────────────────────────────────────────────

class CatalogUnit {
  final String id;
  final String name;
  final String abbreviation;

  const CatalogUnit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory CatalogUnit.fromJson(Map<String, dynamic> json) {
    return CatalogUnit(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      abbreviation: json['abbreviation'] as String? ?? '',
    );
  }
}
