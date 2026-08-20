// ignore_for_file: file_names

import 'package:stock_mate_project/core/models/Refill_Delivery_Model.dart';
import 'package:stock_mate_project/core/models/Inventory_Adjustments_Model.dart';

/// ─────────────────────────────────────────────────────────────
/// مودل تفاصيل التسليم — Get Refill Delivery By Id
/// GET /department-refills/deliveries/{deliveryId}
/// ─────────────────────────────────────────────────────────────

class RefillDeliveryDetails {
  final String id;
  final String refillRequestId;
  final String? deliveredById;
  final DateTime? deliveredAt;
  final DeliveryType type;
  final String? receivedById;
  final DateTime? confirmedAt;
  final String? notes;
  final List<DeliveryItem> items;

  const RefillDeliveryDetails({
    required this.id,
    required this.refillRequestId,
    this.deliveredById,
    this.deliveredAt,
    required this.type,
    this.receivedById,
    this.confirmedAt,
    this.notes,
    required this.items,
  });

  factory RefillDeliveryDetails.fromJson(Map<String, dynamic> json) {
    return RefillDeliveryDetails(
      id: json['id']?.toString() ?? '',
      refillRequestId: json['refillRequestId']?.toString() ?? '',
      deliveredById: json['deliveredById']?.toString(),
      deliveredAt: _parseDate(json['deliveredAt']),
      type: DeliveryType.fromString(json['type']?.toString() ?? 'batch'),
      receivedById: json['receivedById']?.toString(),
      confirmedAt: _parseDate(json['confirmedAt']),
      notes: json['notes']?.toString(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => DeliveryItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  // ─── Helpers ───────────────────────────────────────────────────

  bool get hasNotes => notes != null && notes!.trim().isNotEmpty;

  String get formattedDeliveredAt {
    final d = deliveredAt?.toLocal();
    if (d == null) return '—';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  String get formattedConfirmedAt {
    final d = confirmedAt?.toLocal();
    if (d == null) return '—';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  /// ✅ هل يوجد فرق في أي صنف؟
  bool get hasAnyDiscrepancy => items.any((i) => i.hasDiscrepancy);

  /// ✅ إجمالي المرسَل
  int get totalShipped =>
      items.fold(0, (sum, i) => sum + i.shippedQuantity);

  /// ✅ إجمالي المستلَم
  int get totalReceived =>
      items.fold(0, (sum, i) => sum + i.receivedQuantity);
}

// ─── صنف داخل التسليم ──────────────────────────────────────────────

class DeliveryItem {
  final String id;
  final String refillItemId;
  final String batchId;
  final int shippedQuantity; // ✅ تُحوَّل من String
  final int receivedQuantity; // ✅ تُحوَّل من String
  final int quantityDiscrepancy; // ✅ تُحوَّل من String
  final DeliveryBatch? batch;

  const DeliveryItem({
    required this.id,
    required this.refillItemId,
    required this.batchId,
    required this.shippedQuantity,
    required this.receivedQuantity,
    required this.quantityDiscrepancy,
    this.batch,
  });

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      id: json['id']?.toString() ?? '',
      refillItemId: json['refillItemId']?.toString() ?? '',
      batchId: json['batchId']?.toString() ?? '',
      shippedQuantity:
          int.tryParse(json['shippedQuantity']?.toString() ?? '0') ?? 0,
      receivedQuantity:
          int.tryParse(json['receivedQuantity']?.toString() ?? '0') ?? 0,
      quantityDiscrepancy:
          int.tryParse(json['quantityDiscrepancy']?.toString() ?? '0') ?? 0,
      batch: json['batch'] is Map
          ? DeliveryBatch.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────

  String get displayName => batch?.variant?.variantName ?? '—';
  String get productName => batch?.variant?.product?.name ?? '';
  String get sku => batch?.variant?.sku ?? '—';
  String get batchNumber => batch?.batchNumber ?? '—';
  String get unitAbbreviation => batch?.variant?.unit?.abbreviation ?? '';

  /// ✅ هل يوجد فرق بين المرسَل والمستلَم؟
  bool get hasDiscrepancy => quantityDiscrepancy != 0;

  String get formattedExpiry {
    final d = batch?.expirationDate?.toLocal();
    if (d == null) return '—';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}

// ─── الدفعة داخل الصنف ─────────────────────────────────────────────

class DeliveryBatch {
  final String id;
  final String batchNumber;
  final DateTime? expirationDate;
  final AdjustmentVariant? variant; // ✅ إعادة استخدام موديل الـ variant الموجود

  const DeliveryBatch({
    required this.id,
    required this.batchNumber,
    this.expirationDate,
    this.variant,
  });

  factory DeliveryBatch.fromJson(Map<String, dynamic> json) {
    return DeliveryBatch(
      id: json['id']?.toString() ?? '',
      batchNumber: json['batchNumber']?.toString() ?? '',
      expirationDate: DateTime.tryParse(
        json['expirationDate']?.toString() ?? '',
      ),
      variant: json['variant'] is Map
          ? AdjustmentVariant.fromJson(json['variant'] as Map<String, dynamic>)
          : null,
    );
  }
}