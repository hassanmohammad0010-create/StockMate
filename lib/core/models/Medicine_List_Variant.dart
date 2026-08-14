// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة الأدوية (Variants) — Catalog / Variants
/// GET /catalog/variants
/// ─────────────────────────────────────────────────────────────

class MedicineVariantsPageData {
  final List<MedicineVariant> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const MedicineVariantsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory MedicineVariantsPageData.fromJson(Map<String, dynamic> json) {
    return MedicineVariantsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => MedicineVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── دواء واحد (Variant) ───────────────────────────────────────────

class MedicineVariant {
  /// ✅✅✅ الـ id الذي سنرسله للباك اند عند إرسال الوصفة
  final String id;
  final String productId;

  /// ✅✅✅ الاسم الذي سيظهر للطبيب في الدروب داون
  final String variantName;
  final String sku;
  final String unitId;
  final bool isActive;
  final VariantProduct? product;
  final VariantUnit? unit;

  const MedicineVariant({
    required this.id,
    required this.productId,
    required this.variantName,
    required this.sku,
    required this.unitId,
    required this.isActive,
    this.product,
    this.unit,
  });

  factory MedicineVariant.fromJson(Map<String, dynamic> json) {
    return MedicineVariant(
      id: json['id']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      unitId: json['unitId']?.toString() ?? '',
      isActive: json['isActive'] as bool? ?? true,
      product: json['product'] is Map
          ? VariantProduct.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      unit: json['unit'] is Map
          ? VariantUnit.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
    );
  }

  // ─── Helpers للعرض ───────────────────────────────────────────────

  /// الاسم المعروض في الدروب داون
  String get displayName => variantName;

  /// اسم المنتج الأساسي
  String get productName => product?.name ?? '';

  /// اختصار الوحدة (box / btl / pc ...)
  String get unitAbbreviation => unit?.abbreviation ?? '';

  /// هل هو مادة استهلاكية (دواء/مستهلك) وليس أصل ثابت؟
  bool get isConsumable => product?.materialType == 'consumable';
}

// ─── المنتج ────────────────────────────────────────────────────────
class VariantProduct {
  final String id;
  final String name;
  final String materialType;

  const VariantProduct({
    required this.id,
    required this.name,
    required this.materialType,
  });

  factory VariantProduct.fromJson(Map<String, dynamic> json) {
    return VariantProduct(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
    );
  }
}

// ─── الوحدة ────────────────────────────────────────────────────────
class VariantUnit {
  final String id;
  final String name;
  final String abbreviation;

  const VariantUnit({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory VariantUnit.fromJson(Map<String, dynamic> json) {
    return VariantUnit(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      abbreviation: json['abbreviation']?.toString() ?? '',
    );
  }
}