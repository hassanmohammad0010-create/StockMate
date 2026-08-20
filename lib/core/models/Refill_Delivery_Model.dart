// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// enum نوع التسليم — DeliveryType
/// ─────────────────────────────────────────────────────────────

enum DeliveryType {
  batch,
  final_batch;

  static DeliveryType fromString(String value) {
    return DeliveryType.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => DeliveryType.batch,
    );
  }

  /// ✅ التسمية العربية
  String get label {
    switch (this) {
      case DeliveryType.batch:
        return 'دفعة';
      case DeliveryType.final_batch:
        return 'الدفعة الأخيرة';
    }
  }

  /// ✅ هل هي الدفعة الأخيرة؟
  bool get isFinal => this == DeliveryType.final_batch;
}

/// ─────────────────────────────────────────────────────────────
/// مودل سجل التسليمات — List Refill Deliveries
/// GET /department-refills/deliveries
/// ─────────────────────────────────────────────────────────────

class RefillDeliveryPageData {
  final List<RefillDelivery> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const RefillDeliveryPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory RefillDeliveryPageData.fromJson(Map<String, dynamic> json) {
    return RefillDeliveryPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => RefillDelivery.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── تسليم واحد ────────────────────────────────────────────────────

class RefillDelivery {
  final String id;
  final String refillRequestId;
  final DateTime? deliveredAt;
  final DeliveryType type;
  final DateTime? confirmedAt;

  const RefillDelivery({
    required this.id,
    required this.refillRequestId,
    this.deliveredAt,
    required this.type,
    this.confirmedAt,
  });

  factory RefillDelivery.fromJson(Map<String, dynamic> json) {
    return RefillDelivery(
      id: json['id']?.toString() ?? '',
      refillRequestId: json['refillRequestId']?.toString() ?? '',
      deliveredAt: _parseDate(json['deliveredAt']),
      type: DeliveryType.fromString(json['type']?.toString() ?? 'batch'),
      confirmedAt: _parseDate(json['confirmedAt']),
    );
  }

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  // ─── Helpers للعرض ───────────────────────────────────────────────

  /// ✅ تنسيق تاريخ التسليم
  String get formattedDeliveredAt {
    final d = deliveredAt?.toLocal();
    if (d == null) return '—';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  /// ✅ تنسيق تاريخ التأكيد
  String get formattedConfirmedAt {
    final d = confirmedAt?.toLocal();
    if (d == null) return '—';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  /// ✅ التاريخ المختصر (للكارد)
  String get shortDate {
    final d = deliveredAt?.toLocal();
    if (d == null) return '—';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  /// ✅ معرف الطلب المختصر (للعرض)
  String get shortRequestId =>
      refillRequestId.length > 8
          ? refillRequestId.substring(0, 8)
          : refillRequestId;
}