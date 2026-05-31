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
  MaterialItem(
    id: '1',
    name: 'شاش طبي 250',
    brand: 'فارما',
    type: 'ثابتة',
    category: MaterialCategory.fixed,
    storageLocation: 'A-18 رفق',
    minQuantity: 2000,
    maxQuantity: 100000,
    batches: [
      MaterialBatch(
        id: 'B001',
        quantity: 35000,
        expiryDate: DateTime(2027, 6, 1),
      ),
      MaterialBatch(
        id: 'B002',
        quantity: 30000,
        expiryDate: DateTime(2026, 12, 15),
      ),
      MaterialBatch(
        id: 'B003',
        quantity: 10000,
        expiryDate: DateTime(2026, 7, 10),
      ),
      MaterialBatch(
        id: 'B004',
        quantity: 5000,
        expiryDate: DateTime(2026, 3, 1),
      ),
    ],
  ),
  MaterialItem(
    id: '1',
    name: 'شاش طبي 250',
    brand: 'فارما',
    type: 'ثابتة',
    category: MaterialCategory.fixed,
    storageLocation: 'A-18 رفق',
    minQuantity: 2000,
    maxQuantity: 100000,
    batches: [
      MaterialBatch(
        id: 'B001',
        quantity: 2626,
        expiryDate: DateTime(2027, 6, 1),
      ),
      MaterialBatch(
        id: 'B002',
        quantity: 252,
        expiryDate: DateTime(2026, 12, 15),
      ),
      MaterialBatch(
        id: 'B003',
        quantity: 2575,
        expiryDate: DateTime(2026, 7, 10),
      ),
      MaterialBatch(
        id: 'B004',
        quantity: 1524,
        expiryDate: DateTime(2026, 3, 1),
      ),
    ],
  ),
  MaterialItem(
    id: '1',
    name: 'شاش طبي 250',
    brand: 'فارما',
    type: 'مستهلكة',
    category: MaterialCategory.consumable,
    storageLocation: 'A-18 رفق',
    minQuantity: 2000,
    maxQuantity: 100000,
    batches: [
      MaterialBatch(
        id: 'B001',
        quantity: 1522,
        expiryDate: DateTime(2027, 6, 1),
      ),
      MaterialBatch(
        id: 'B002',
        quantity: 1525,
        expiryDate: DateTime(2026, 12, 15),
      ),
      MaterialBatch(
        id: 'B003',
        quantity: 1425,
        expiryDate: DateTime(2026, 7, 10),
      ),
      MaterialBatch(
        id: 'B004',
        quantity: 1854,
        expiryDate: DateTime(2026, 3, 1),
      ),
    ],
  ),
  MaterialItem(
    id: '1',
    name: 'شاش طبي 250',
    brand: 'فارما',
    type: 'مستهلكة',
    category: MaterialCategory.consumable,
    storageLocation: 'A-18 رفق',
    minQuantity: 2000,
    maxQuantity: 100000,
    batches: [
      MaterialBatch(
        id: 'B001',
        quantity: 1502,
        expiryDate: DateTime(2027, 6, 1),
      ),
      MaterialBatch(
        id: 'B002',
        quantity: 2250,
        expiryDate: DateTime(2026, 12, 15),
      ),
      MaterialBatch(
        id: 'B003',
        quantity: 2510,
        expiryDate: DateTime(2026, 7, 10),
      ),
      MaterialBatch(
        id: 'B004',
        quantity: 1542,
        expiryDate: DateTime(2026, 3, 1),
      ),
    ],
  ),
  MaterialItem(
    id: '1',
    name: 'شاش طبي 250',
    brand: 'فارما',
    type: 'ادوية',
    category: MaterialCategory.medicine,
    storageLocation: 'A-18 رفق',
    minQuantity: 2000,
    maxQuantity: 100000,
    batches: [
      MaterialBatch(
        id: 'B001',
        quantity: 1250,
        expiryDate: DateTime(2027, 6, 1),
      ),
      MaterialBatch(
        id: 'B002',
        quantity: 2350,
        expiryDate: DateTime(2026, 12, 15),
      ),
      MaterialBatch(
        id: 'B003',
        quantity: 2365,
        expiryDate: DateTime(2026, 7, 10),
      ),
      MaterialBatch(
        id: 'B004',
        quantity: 6085,
        expiryDate: DateTime(2026, 3, 1),
      ),
    ],
  ),
  MaterialItem(
    id: '1',
    name: 'شاش طبي 250',
    brand: 'فارما',
    type: 'ثابتة',
    category: MaterialCategory.fixed,
    storageLocation: 'A-18 رفق',
    minQuantity: 2000,
    maxQuantity: 100000,
    batches: [
      MaterialBatch(
        id: 'B001',
        quantity: 26550,
        expiryDate: DateTime(2027, 6, 1),
      ),
      MaterialBatch(
        id: 'B002',
        quantity: 2650,
        expiryDate: DateTime(2026, 12, 15),
      ),
      MaterialBatch(
        id: 'B003',
        quantity: 855,
        expiryDate: DateTime(2026, 7, 10),
      ),
      MaterialBatch(
        id: 'B004',
        quantity: 8738,
        expiryDate: DateTime(2026, 3, 1),
      ),
    ],
  ),
];
