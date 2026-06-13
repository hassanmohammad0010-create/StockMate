// ignore_for_file: file_names

enum MaterialCategory { consumable, fixed, medicine }

enum BatchStatus { valid, expiringSoon, expired }

class MaterialBatch {
  final String id;
  final int quantity;
  final DateTime expiryDate;

  MaterialBatch({
    required this.id,
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
}

class MaterialItem {
  final String id;
  final String name;
  final String brand;
  final String type;
  final MaterialCategory category;
  final String storageLocation;
  final int minQuantity;
  final int maxQuantity;
  final List<MaterialBatch> batches;

  MaterialItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.type,
    required this.category,
    required this.storageLocation,
    required this.minQuantity,
    required this.maxQuantity,
    required this.batches,
  });

  int get totalQuantity => batches.fold(0, (sum, b) => sum + b.quantity);

  int get validQuantity => batches
      .where((b) => b.status == BatchStatus.valid)
      .fold(0, (sum, b) => sum + b.quantity);

  int get expiringSoonQuantity => batches
      .where((b) => b.status == BatchStatus.expiringSoon)
      .fold(0, (sum, b) => sum + b.quantity);

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
}

final List<MaterialItem> allMaterial = [
  // ─── ثابتة ───────────────────────────────────────────
  MaterialItem(
    id: 'MAT-001',
    name: 'شاش طبي 250',
    brand: 'فارما',
    type: 'ثابتة',
    category: MaterialCategory.fixed,
    storageLocation: 'A-18 رف 3',
    minQuantity: 2000,
    maxQuantity: 100000,
    batches: [
      MaterialBatch(id: 'B001', quantity: 35000, expiryDate: DateTime(2027, 6, 1)),
      MaterialBatch(id: 'B002', quantity: 30000, expiryDate: DateTime(2026, 12, 15)),
      MaterialBatch(id: 'B003', quantity: 10000, expiryDate: DateTime(2026, 7, 10)),
      MaterialBatch(id: 'B004', quantity: 5000,  expiryDate: DateTime(2026, 3, 1)),
    ],
  ),
  MaterialItem(
    id: 'MAT-002',
    name: 'قفازات لاتكس M',
    brand: 'ميدلاين',
    type: 'ثابتة',
    category: MaterialCategory.fixed,
    storageLocation: 'B-05 رف 1',
    minQuantity: 500,
    maxQuantity: 20000,
    batches: [
      MaterialBatch(id: 'B001', quantity: 8000, expiryDate: DateTime(2027, 3, 1)),
      MaterialBatch(id: 'B002', quantity: 4500, expiryDate: DateTime(2026, 9, 20)),
    ],
  ),
  MaterialItem(
    id: 'MAT-003',
    name: 'أنبوب تنفس اصطناعي',
    brand: 'ميدترونيك',
    type: 'ثابتة',
    category: MaterialCategory.fixed,
    storageLocation: 'C-12 رف 2',
    minQuantity: 50,
    maxQuantity: 500,
    batches: [
      MaterialBatch(id: 'B001', quantity: 120, expiryDate: DateTime(2028, 1, 1)),
      MaterialBatch(id: 'B002', quantity: 80,  expiryDate: DateTime(2026, 8, 15)),
    ],
  ),

  // ─── مستهلكة ──────────────────────────────────────────
  MaterialItem(
    id: 'MAT-004',
    name: 'محقنة 5 مل',
    brand: 'بي دي',
    type: 'مستهلكة',
    category: MaterialCategory.consumable,
    storageLocation: 'A-22 رف 4',
    minQuantity: 1000,
    maxQuantity: 50000,
    batches: [
      MaterialBatch(id: 'B001', quantity: 12000, expiryDate: DateTime(2027, 11, 1)),
      MaterialBatch(id: 'B002', quantity: 8000,  expiryDate: DateTime(2026, 7, 30)),
      MaterialBatch(id: 'B003', quantity: 3000,  expiryDate: DateTime(2026, 4, 10)),
    ],
  ),
  MaterialItem(
    id: 'MAT-005',
    name: 'ضمادة لاصقة 10×8',
    brand: 'هارتمان',
    type: 'مستهلكة',
    category: MaterialCategory.consumable,
    storageLocation: 'B-09 رف 2',
    minQuantity: 500,
    maxQuantity: 30000,
    batches: [
      MaterialBatch(id: 'B001', quantity: 6000, expiryDate: DateTime(2027, 5, 1)),
      MaterialBatch(id: 'B002', quantity: 2500, expiryDate: DateTime(2026, 6, 20)),
    ],
  ),
  MaterialItem(
    id: 'MAT-006',
    name: 'كمامة N95',
    brand: '3M',
    type: 'مستهلكة',
    category: MaterialCategory.consumable,
    storageLocation: 'D-01 رف 1',
    minQuantity: 200,
    maxQuantity: 10000,
    batches: [
      MaterialBatch(id: 'B001', quantity: 3000, expiryDate: DateTime(2027, 2, 28)),
      MaterialBatch(id: 'B002', quantity: 1500, expiryDate: DateTime(2026, 5, 15)),
    ],
  ),

  // ─── أدوية ────────────────────────────────────────────
  MaterialItem(
    id: 'MAT-007',
    name: 'باراسيتامول 500 مغ',
    brand: 'غلاكسو',
    type: 'ادوية',
    category: MaterialCategory.medicine,
    storageLocation: 'E-03 رف 5',
    minQuantity: 1000,
    maxQuantity: 40000,
    batches: [
      MaterialBatch(id: 'B001', quantity: 15000, expiryDate: DateTime(2027, 8, 1)),
      MaterialBatch(id: 'B002', quantity: 7000,  expiryDate: DateTime(2026, 6, 10)),
      MaterialBatch(id: 'B003', quantity: 2000,  expiryDate: DateTime(2026, 3, 25)),
    ],
  ),
  MaterialItem(
    id: 'MAT-008',
    name: 'أموكسيسيلين 250 مغ',
    brand: 'فايزر',
    type: 'ادوية',
    category: MaterialCategory.medicine,
    storageLocation: 'E-07 رف 2',
    minQuantity: 500,
    maxQuantity: 20000,
    batches: [
      MaterialBatch(id: 'B001', quantity: 9000, expiryDate: DateTime(2027, 4, 1)),
      MaterialBatch(id: 'B002', quantity: 3500, expiryDate: DateTime(2026, 7, 1)),
    ],
  ),
  MaterialItem(
    id: 'MAT-009',
    name: 'محلول ملحي 0.9%',
    brand: 'باكستر',
    type: 'ادوية',
    category: MaterialCategory.medicine,
    storageLocation: 'F-11 رف 1',
    minQuantity: 200,
    maxQuantity: 5000,
    batches: [
      MaterialBatch(id: 'B001', quantity: 800,  expiryDate: DateTime(2027, 9, 15)),
      MaterialBatch(id: 'B002', quantity: 400,  expiryDate: DateTime(2026, 5, 30)),
      MaterialBatch(id: 'B003', quantity: 150,  expiryDate: DateTime(2026, 3, 5)),
    ],
  ),
];