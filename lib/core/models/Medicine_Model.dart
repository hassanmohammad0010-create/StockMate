class MedicineModel {
  final String id; // id الخاص بسجل الـ stock-setting (مو الدواء نفسه)
  final String variantId; // id الدواء/الصنف الفعلي
  final String name; // اسم الدواء (من داخل variant)
  final String sku;
  final String storageLocation;
  final int minimumStock;
  final int maximumStock;
  final bool isActive;
  final String departmentName;

  MedicineModel({
    required this.id,
    required this.variantId,
    required this.name,
    required this.sku,
    required this.storageLocation,
    required this.minimumStock,
    required this.maximumStock,
    required this.isActive,
    required this.departmentName,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    // variant هو Map متداخل، لازم نستخرج منه الاسم والـ sku
    final variant = json['variant'] as Map<String, dynamic>? ?? {};
    final department = json['department'] as Map<String, dynamic>? ?? {};

    return MedicineModel(
      id: json['id']?.toString() ?? '',
      variantId: json['variantId']?.toString() ?? '',
      name: variant['variantName']?.toString() ?? '',
      sku: variant['sku']?.toString() ?? '',
      storageLocation: json['storageLocation']?.toString() ?? '',
      // minimumStock و maximumStock يرجعون كـ String من الـ API ("10")
      // لذلك نحولهم لرقم يدوياً
      minimumStock: int.tryParse(json['minimumStock']?.toString() ?? '') ?? 0,
      maximumStock: int.tryParse(json['maximumStock']?.toString() ?? '') ?? 0,
      isActive: json['isActive'] as bool? ?? false,
      departmentName: department['name']?.toString() ?? '',
    );
  }

  @override
  String toString() => 'MedicineModel(id: $id, name: $name, sku: $sku)';
}