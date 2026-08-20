// lib/core/models/Purchase_Receipt_Details_Model.dart
// ignore_for_file: file_names

import 'package:stock_mate_project/core/models/Purchase_Receipts_Page_Data_Model.dart'
    show ReceiptBatchType, ReceiptStatus, ReceiptReceivedBy;

/// ─────────────────────────────────────────────────────────────
/// مودل تفاصيل إيصال الاستلام — Get Purchase Receipt By Id
/// GET /purchasing/receipts/{id}
/// ─────────────────────────────────────────────────────────────

class PurchaseReceiptDetails {
  final String id;
  final String purchaseRequestId;
  final String supplierId;
  final DateTime receivingDate;
  final ReceiptBatchType type;
  final ReceiptStatus status;
  final String? confirmedById;
  final DateTime? confirmedAt;
  final String? notes;
  final DateTime createdAt;
  final ReceiptReceivedBy? receivedBy;
  final ReceiptReceivedBy? confirmedBy;
  final ReceiptSupplierInfo? supplier;
  final List<ReceiptImage> images;
  final List<ReceiptDetailItem> items;

  const PurchaseReceiptDetails({
    required this.id,
    required this.purchaseRequestId,
    required this.supplierId,
    required this.receivingDate,
    required this.type,
    required this.status,
    this.confirmedById,
    this.confirmedAt,
    this.notes,
    required this.createdAt,
    this.receivedBy,
    this.confirmedBy,
    this.supplier,
    required this.images,
    required this.items,
  });

  factory PurchaseReceiptDetails.fromJson(Map<String, dynamic> json) {
    return PurchaseReceiptDetails(
      id: json['id']?.toString() ?? '',
      purchaseRequestId: json['purchaseRequestId']?.toString() ?? '',
      supplierId: json['supplierId']?.toString() ?? '',
      receivingDate: _parseDate(json['receivingDate']) ?? DateTime.now(),
      type: ReceiptBatchType.fromString(json['type']?.toString() ?? 'batch'),
      status: ReceiptStatus.fromString(
        json['status']?.toString() ?? 'pending_confirmation',
      ),
      confirmedById: json['confirmedById']?.toString(),
      confirmedAt: _parseDate(json['confirmedAt']),
      notes: json['notes']?.toString(),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      receivedBy: json['receivedBy'] is Map
          ? ReceiptReceivedBy.fromJson(
              json['receivedBy'] as Map<String, dynamic>,
            )
          : null,
      confirmedBy: json['confirmedBy'] is Map
          ? ReceiptReceivedBy.fromJson(
              json['confirmedBy'] as Map<String, dynamic>,
            )
          : null,
      supplier: json['supplier'] is Map
          ? ReceiptSupplierInfo.fromJson(
              json['supplier'] as Map<String, dynamic>,
            )
          : null,
      images: (json['images'] as List? ?? [])
          .map((e) => ReceiptImage.fromJson(e as Map<String, dynamic>))
          .toList(),
      items: (json['items'] as List? ?? [])
          .map((e) => ReceiptDetailItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  // ─── Helpers ─────────────────────────────────────────────────

  bool get isConfirmed => status == ReceiptStatus.confirmed;
  bool get isPending => status == ReceiptStatus.pendingConfirmation;
  bool get isCancelled => status == ReceiptStatus.cancelled;

  String get formattedReceivingDate => _fmtDate(receivingDate);
  String get formattedCreatedAt => _fmtDateTime(createdAt);
  String? get formattedConfirmedAt =>
      confirmedAt == null ? null : _fmtDateTime(confirmedAt!);

  static String _fmtDate(DateTime d) {
    final local = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year}';
  }

  static String _fmtDateTime(DateTime d) {
    final local = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} • ${two(local.hour)}:${two(local.minute)}';
  }
}

// ─── المورّد ──────────────────────────────────────────────────────

class ReceiptSupplierInfo {
  final String id;
  final String name;

  const ReceiptSupplierInfo({required this.id, required this.name});

  factory ReceiptSupplierInfo.fromJson(Map<String, dynamic> json) {
    return ReceiptSupplierInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ─── صورة الإيصال ────────────────────────────────────────────────

class ReceiptImage {
  final String id;
  final int sortOrder;
  final DateTime createdAt;

  const ReceiptImage({
    required this.id,
    required this.sortOrder,
    required this.createdAt,
  });

  factory ReceiptImage.fromJson(Map<String, dynamic> json) {
    return ReceiptImage(
      id: json['id']?.toString() ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}

// ─── عنصر الإيصال (صنف داخل الإيصال) ────────────────────────────

class ReceiptDetailItem {
  final String id;
  final String purchaseRequestItemId;
  final String variantId;
  final int expectedQuantity;
  final int quantity;
  final int quantityDiscrepancy;
  final int? confirmedQuantity;
  final int confirmedQuantityDiscrepancy;
  final double purchasePrice;
  final String? batchNumber;
  final DateTime? manufacturingDate;
  final DateTime? expirationDate;
  final ReceiptVariantInfo? variant;
  final ReceiptBatchInfo? batch;

  const ReceiptDetailItem({
    required this.id,
    required this.purchaseRequestItemId,
    required this.variantId,
    required this.expectedQuantity,
    required this.quantity,
    required this.quantityDiscrepancy,
    this.confirmedQuantity,
    required this.confirmedQuantityDiscrepancy,
    required this.purchasePrice,
    this.batchNumber,
    this.manufacturingDate,
    this.expirationDate,
    this.variant,
    this.batch,
  });

  factory ReceiptDetailItem.fromJson(Map<String, dynamic> json) {
    return ReceiptDetailItem(
      id: json['id']?.toString() ?? '',
      purchaseRequestItemId: json['purchaseRequestItemId']?.toString() ?? '',
      variantId: json['variantId']?.toString() ?? '',
      expectedQuantity:
          int.tryParse(json['expectedQuantity']?.toString() ?? '') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      quantityDiscrepancy:
          int.tryParse(json['quantityDiscrepancy']?.toString() ?? '') ?? 0,
      confirmedQuantity: json['confirmedQuantity'] != null
          ? int.tryParse(json['confirmedQuantity'].toString())
          : null,
      confirmedQuantityDiscrepancy:
          int.tryParse(
            json['confirmedQuantityDiscrepancy']?.toString() ?? '',
          ) ??
          0,
      purchasePrice:
          double.tryParse(json['purchasePrice']?.toString() ?? '') ?? 0,
      batchNumber: json['batchNumber']?.toString(),
      manufacturingDate: json['manufacturingDate'] != null
          ? DateTime.tryParse(json['manufacturingDate'].toString())
          : null,
      expirationDate: json['expirationDate'] != null
          ? DateTime.tryParse(json['expirationDate'].toString())
          : null,
      variant: json['variant'] is Map
          ? ReceiptVariantInfo.fromJson(json['variant'] as Map<String, dynamic>)
          : null,
      batch: json['batch'] is Map
          ? ReceiptBatchInfo.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
    );
  }

  /// هل فيه فرق بين الكمية المتوقعة والمستلمة؟
  bool get hasDiscrepancy => quantityDiscrepancy != 0;
}

// ─── الصنف (Variant) ────────────────────────────────────────────

class ReceiptVariantInfo {
  final String id;
  final String variantName;
  final String sku;
  final ReceiptUnitInfo? unit;
  final ReceiptProductInfo? product;

  const ReceiptVariantInfo({
    required this.id,
    required this.variantName,
    required this.sku,
    this.unit,
    this.product,
  });

  factory ReceiptVariantInfo.fromJson(Map<String, dynamic> json) {
    return ReceiptVariantInfo(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      unit: json['unit'] is Map
          ? ReceiptUnitInfo.fromJson(json['unit'] as Map<String, dynamic>)
          : null,
      product: json['product'] is Map
          ? ReceiptProductInfo.fromJson(json['product'] as Map<String, dynamic>)
          : null,
    );
  }
}

class ReceiptUnitInfo {
  final String id;
  final String name;
  final String abbreviation;

  const ReceiptUnitInfo({
    required this.id,
    required this.name,
    required this.abbreviation,
  });

  factory ReceiptUnitInfo.fromJson(Map<String, dynamic> json) {
    return ReceiptUnitInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      abbreviation: json['abbreviation']?.toString() ?? '',
    );
  }
}

class ReceiptProductInfo {
  final String id;
  final String name;
  final String materialType;
  final ReceiptCategoryInfo? category;

  const ReceiptProductInfo({
    required this.id,
    required this.name,
    required this.materialType,
    this.category,
  });

  factory ReceiptProductInfo.fromJson(Map<String, dynamic> json) {
    return ReceiptProductInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      materialType: json['materialType']?.toString() ?? '',
      category: json['category'] is Map
          ? ReceiptCategoryInfo.fromJson(
              json['category'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class ReceiptCategoryInfo {
  final String id;
  final String name;

  const ReceiptCategoryInfo({required this.id, required this.name});

  factory ReceiptCategoryInfo.fromJson(Map<String, dynamic> json) {
    return ReceiptCategoryInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ─── الدفعة (Batch) — nullable لو لسه ماتسجلتش ─────────────────

class ReceiptBatchInfo {
  final String id;
  final String batchNumber;

  const ReceiptBatchInfo({required this.id, required this.batchNumber});

  factory ReceiptBatchInfo.fromJson(Map<String, dynamic> json) {
    return ReceiptBatchInfo(
      id: json['id']?.toString() ?? '',
      batchNumber: json['batchNumber']?.toString() ?? '',
    );
  }
}
