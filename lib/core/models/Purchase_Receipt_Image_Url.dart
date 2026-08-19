// lib/core/models/Purchase_Receipt_Image_Model.dart
// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل صور إيصال الاستلام (روابط موقّعة) — Purchase Receipt Images
/// GET /purchasing/receipts/{id}/images
/// ─────────────────────────────────────────────────────────────

class PurchaseReceiptImageUrl {
  final String id;
  final int sortOrder;
  final String url;
  final DateTime expiresAt;

  const PurchaseReceiptImageUrl({
    required this.id,
    required this.sortOrder,
    required this.url,
    required this.expiresAt,
  });

  factory PurchaseReceiptImageUrl.fromJson(Map<String, dynamic> json) {
    return PurchaseReceiptImageUrl(
      id: json['id'] as String? ?? '',
      sortOrder: json['sortOrder'] as int? ?? 0,
      url: json['url'] as String? ?? '',
      expiresAt:
          DateTime.tryParse(json['expiresAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  /// هل الرابط لسه صالح؟
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
