// lib/core/models/Purchase_Receipt_Model.dart
// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// Enums الخاصة بإيصالات الاستلام (Purchase Receipts)
/// ─────────────────────────────────────────────────────────────

enum ReceiptBatchType {
  batch,
  finalBatch;

  static ReceiptBatchType fromString(String value) {
    switch (value) {
      case 'final_batch':
        return ReceiptBatchType.finalBatch;
      case 'batch':
      default:
        return ReceiptBatchType.batch;
    }
  }

  String get arabicLabel =>
      this == ReceiptBatchType.finalBatch ? 'دفعة نهائية' : 'دفعة جزئية';
}

enum ReceiptStatus {
  pendingConfirmation,
  confirmed,
  cancelled;

  static ReceiptStatus fromString(String value) {
    switch (value) {
      case 'pending_confirmation':
        return ReceiptStatus.pendingConfirmation;
      case 'confirmed':
        return ReceiptStatus.confirmed;
      case 'cancelled':
        return ReceiptStatus.cancelled;
      default:
        return ReceiptStatus.pendingConfirmation;
    }
  }

  String get arabicLabel {
    switch (this) {
      case ReceiptStatus.pendingConfirmation:
        return 'بانتظار التأكيد';
      case ReceiptStatus.confirmed:
        return 'مؤكد';
      case ReceiptStatus.cancelled:
        return 'ملغي';
    }
  }
}

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة إيصالات الاستلام — List Purchase Receipts
/// GET /purchasing/receipts
/// ─────────────────────────────────────────────────────────────

class PurchaseReceiptsPageData {
  final List<PurchaseReceiptItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PurchaseReceiptsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PurchaseReceiptsPageData.fromJson(Map<String, dynamic> json) {
    return PurchaseReceiptsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => PurchaseReceiptItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── إيصال الاستلام الواحد ──────────────────────────────────────

class PurchaseReceiptItem {
  final String id;
  final String purchaseRequestId;
  final String supplierId;
  final DateTime receivingDate;
  final ReceiptBatchType type;
  final ReceiptStatus status;
  final ReceiptReceivedBy? receivedBy;
  final DateTime createdAt;

  const PurchaseReceiptItem({
    required this.id,
    required this.purchaseRequestId,
    required this.supplierId,
    required this.receivingDate,
    required this.type,
    required this.status,
    this.receivedBy,
    required this.createdAt,
  });

  factory PurchaseReceiptItem.fromJson(Map<String, dynamic> json) {
    return PurchaseReceiptItem(
      id: json['id'] as String? ?? '',
      purchaseRequestId: json['purchaseRequestId'] as String? ?? '',
      supplierId: json['supplierId'] as String? ?? '',
      receivingDate:
          DateTime.tryParse(json['receivingDate'] as String? ?? '') ??
          DateTime.now(),
      type: ReceiptBatchType.fromString(json['type'] as String? ?? 'batch'),
      status: ReceiptStatus.fromString(
        json['status'] as String? ?? 'pending_confirmation',
      ),
      receivedBy: json['receivedBy'] is Map
          ? ReceiptReceivedBy.fromJson(
              json['receivedBy'] as Map<String, dynamic>,
            )
          : null,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  String get formattedReceivingDate {
    final d = receivingDate.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  String get formattedCreatedAt {
    final d = createdAt.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }
}

// ─── مستلم الإيصال ───────────────────────────────────────────────

class ReceiptReceivedBy {
  final String id;
  final String fullName;

  const ReceiptReceivedBy({required this.id, required this.fullName});

  factory ReceiptReceivedBy.fromJson(Map<String, dynamic> json) {
    return ReceiptReceivedBy(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
    );
  }
}
