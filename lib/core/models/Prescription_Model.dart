// ignore_for_file: file_names, dangling_library_doc_comments

/// ─────────────────────────────────────────────────────────────
/// مودل الوصفة الطبية
/// ─────────────────────────────────────────────────────────────

class Prescription {
  /// id محلي مؤقت (uuid) — يُستخدم لإدارة الوصفة قبل الإرسال
  final String localId;
  final String frequencyUnit; // day / week / month
  final int frequencyInterval;
  final int totalCycles;
  final String startDate; // yyyy-MM-dd
  final List<PrescriptionItem> items;

  const Prescription({
    required this.localId,
    required this.frequencyUnit,
    required this.frequencyInterval,
    required this.totalCycles,
    required this.startDate,
    required this.items,
  });

  /// افتراضي: كل يوم، 3 دورات، اليوم
  factory Prescription.empty() {
    final today = DateTime.now();
    String two(int v) => v.toString().padLeft(2, '0');
    return Prescription(
      localId: DateTime.now().microsecondsSinceEpoch.toString(),
      frequencyUnit: 'day',
      frequencyInterval: 1,
      totalCycles: 3,
      startDate: '${today.year}-${two(today.month)}-${two(today.day)}',
      items: const [],
    );
  }

  Prescription copyWith({
    String? frequencyUnit,
    int? frequencyInterval,
    int? totalCycles,
    String? startDate,
    List<PrescriptionItem>? items,
  }) {
    return Prescription(
      localId: localId,
      frequencyUnit: frequencyUnit ?? this.frequencyUnit,
      frequencyInterval: frequencyInterval ?? this.frequencyInterval,
      totalCycles: totalCycles ?? this.totalCycles,
      startDate: startDate ?? this.startDate,
      items: items ?? this.items,
    );
  }

  /// ✅ الشكل الذي سيُرسل للباك اند (بدون localId)
  Map<String, dynamic> toJson() => {
        'frequencyUnit': frequencyUnit,
        'frequencyInterval': frequencyInterval,
        'totalCycles': totalCycles,
        'startDate': startDate,
        'items': items.map((e) => e.toJson()).toList(),
      };

  // ─── Helpers ──────────────────────────────────────────────────────

  String get frequencyUnitLabel {
    switch (frequencyUnit) {
      case 'day':
        return 'يوم';
      case 'week':
        return 'أسبوع';
      case 'month':
        return 'شهر';
      default:
        return frequencyUnit;
    }
  }

  /// نص مختصر للعرض
  String get summaryText {
    return 'كل $frequencyInterval $frequencyUnitLabel • $totalCycles دورة • $startDate';
  }

  bool get hasItems => items.isNotEmpty;
}

// ─── دواء داخل الوصفة ─────────────────────────────────────────────
class PrescriptionItem {
  final String localId; // محلي للإدارة
  final String variantId; // ✅ يُرسل للباك اند
  final int prescribedQuantity;
  final String dosage;
  final String frequency; // twice daily / once daily ...
  final int durationDays;
  final String displayName; // للاحتفاظ بالاسم للعرض

  const PrescriptionItem({
    required this.localId,
    required this.variantId,
    required this.prescribedQuantity,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    required this.displayName,
  });

  factory PrescriptionItem.empty({
    required String variantId,
    required String displayName,
  }) {
    return PrescriptionItem(
      localId: DateTime.now().microsecondsSinceEpoch.toString(),
      variantId: variantId,
      prescribedQuantity: 1,
      dosage: '',
      frequency: 'مرة يومياً',
      durationDays: 3,
      displayName: displayName,
    );
  }

  PrescriptionItem copyWith({
    int? prescribedQuantity,
    String? dosage,
    String? frequency,
    int? durationDays,
  }) {
    return PrescriptionItem(
      localId: localId,
      variantId: variantId,
      prescribedQuantity: prescribedQuantity ?? this.prescribedQuantity,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      durationDays: durationDays ?? this.durationDays,
      displayName: displayName,
    );
  }

  Map<String, dynamic> toJson() => {
        'variantId': variantId,
        'prescribedQuantity': prescribedQuantity,
        'dosage': dosage,
        'frequency': frequency,
        'durationDays': durationDays,
      };
}