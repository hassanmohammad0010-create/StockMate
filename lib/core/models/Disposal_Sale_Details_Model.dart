// lib/core/models/Disposal_Sale_Details_Model.dart
// ignore_for_file: file_names

import 'package:stock_mate_project/core/models/Disposal_Sales_Page_Data_Model.dart';

/// ─────────────────────────────────────────────────────────────
/// موديل تفاصيل طلب مبيعات الإتلاف
/// GET /disposal/sales/{id}
/// ─────────────────────────────────────────────────────────────

class DisposalSaleDetails {
  final String id;
  final DisposalDestination? destination;
  final DisposalPersonRef? requestedBy;
  final DisposalSaleRequestStatus status;
  final DisposalPersonRef? approvedBy;
  final DateTime? approvedAt;
  final String? rejectionReason;
  final DisposalPersonRef? confirmedBy;
  final DateTime? confirmedAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<DisposalSaleItem> items;
  final List<String> images;

  const DisposalSaleDetails({
    required this.id,
    this.destination,
    this.requestedBy,
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.rejectionReason,
    this.confirmedBy,
    this.confirmedAt,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.images,
  });

  factory DisposalSaleDetails.fromJson(Map<String, dynamic> json) {
    return DisposalSaleDetails(
      id: json['id']?.toString() ?? '',
      destination: json['destination'] is Map
          ? DisposalDestination.fromJson(
              json['destination'] as Map<String, dynamic>,
            )
          : null,
      requestedBy: json['requestedBy'] is Map
          ? DisposalPersonRef.fromJson(
              json['requestedBy'] as Map<String, dynamic>,
            )
          : null,
      status: DisposalSaleRequestStatus.fromString(
        json['status']?.toString() ?? 'pending_approval',
      ),
      approvedBy: json['approvedBy'] is Map
          ? DisposalPersonRef.fromJson(
              json['approvedBy'] as Map<String, dynamic>,
            )
          : null,
      approvedAt: _parseDate(json['approvedAt']),
      rejectionReason: json['rejectionReason']?.toString(),
      confirmedBy: json['confirmedBy'] is Map
          ? DisposalPersonRef.fromJson(
              json['confirmedBy'] as Map<String, dynamic>,
            )
          : null,
      confirmedAt: _parseDate(json['confirmedAt']),
      notes: json['notes']?.toString(),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseDate(json['updatedAt']) ?? DateTime.now(),
      items: (json['items'] as List? ?? [])
          .map((e) => DisposalSaleItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      images: (json['images'] as List? ?? []).map((e) => e.toString()).toList(),
    );
  }

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  // ─── Helpers ─────────────────────────────────────────────────

  String get statusLabel => status.displayName;

  bool get isRejected => status == DisposalSaleRequestStatus.rejected;

  /// إجمالي مبلغ البيع (مجموع سعر × كمية كل عنصر)
  double get totalAmount =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  String get formattedCreatedAt => _fmt(createdAt);

  String? get formattedApprovedAt =>
      approvedAt == null ? null : _fmt(approvedAt!);

  String? get formattedConfirmedAt =>
      confirmedAt == null ? null : _fmt(confirmedAt!);

  static String _fmt(DateTime d) {
    final local = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(local.day)}/${two(local.month)}/${local.year} • ${two(local.hour)}:${two(local.minute)}';
  }
}

// ─── مرجع شخص (يستخدم لـ requestedBy / approvedBy / confirmedBy) ────

class DisposalPersonRef {
  final String id;
  final String fullName;

  const DisposalPersonRef({required this.id, required this.fullName});

  factory DisposalPersonRef.fromJson(Map<String, dynamic> json) {
    return DisposalPersonRef(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}

// ─── عنصر طلب البيع ─────────────────────────────────────────────

class DisposalSaleItem {
  final String id;
  final int quantity;
  final double price;
  final DisposalSaleVariant? variant;
  final DisposalSaleBatch? batch;

  const DisposalSaleItem({
    required this.id,
    required this.quantity,
    required this.price,
    this.variant,
    this.batch,
  });

  factory DisposalSaleItem.fromJson(Map<String, dynamic> json) {
    return DisposalSaleItem(
      id: json['id']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      variant: json['variant'] is Map
          ? DisposalSaleVariant.fromJson(
              json['variant'] as Map<String, dynamic>,
            )
          : null,
      batch: json['batch'] is Map
          ? DisposalSaleBatch.fromJson(json['batch'] as Map<String, dynamic>)
          : null,
    );
  }

  double get subtotal => price * quantity;
}

class DisposalSaleVariant {
  final String id;
  final String variantName;
  final String sku;

  const DisposalSaleVariant({
    required this.id,
    required this.variantName,
    required this.sku,
  });

  factory DisposalSaleVariant.fromJson(Map<String, dynamic> json) {
    return DisposalSaleVariant(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
    );
  }
}

class DisposalSaleBatch {
  final String id;
  final String batchNumber;
  final DateTime? expirationDate;

  const DisposalSaleBatch({
    required this.id,
    required this.batchNumber,
    this.expirationDate,
  });

  factory DisposalSaleBatch.fromJson(Map<String, dynamic> json) {
    return DisposalSaleBatch(
      id: json['id']?.toString() ?? '',
      batchNumber: json['batchNumber']?.toString() ?? '',
      expirationDate: json['expirationDate'] != null
          ? DateTime.tryParse(json['expirationDate'].toString())
          : null,
    );
  }
}
