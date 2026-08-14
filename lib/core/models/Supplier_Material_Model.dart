// lib/core/models/Supplier_Material_Model.dart
class SupplierMaterialModel {
  final String materialName;
  final String unitName;
  final String materialType;

  SupplierMaterialModel({
    required this.materialName,
    required this.unitName,
    required this.materialType,
  });

  factory SupplierMaterialModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? product = json['product'] is Map
        ? json['product'] as Map<String, dynamic>
        : null;
    final Map<String, dynamic>? unit = json['unit'] is Map
        ? json['unit'] as Map<String, dynamic>
        : null;

    return SupplierMaterialModel(
      // ← اسم المادة الأساسي جاي من كائن product مش من variantName
      // (variantName بيحتوي تفاصيل التعبئة زي "Box of 50")
      materialName: product?['name']?.toString() ?? '',
      unitName: unit?['name']?.toString() ?? '',
      materialType: product?['materialType']?.toString() ?? '',
    );
  }
}
