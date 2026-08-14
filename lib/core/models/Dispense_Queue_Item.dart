// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// enum حالة دورة الوصفة — CycleStatus
/// ─────────────────────────────────────────────────────────────

enum CycleStatus {
  ready,
  partially_delivered,
  delivered,
  missed,
  cancelled;

  static CycleStatus fromString(String value) {
    return CycleStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => CycleStatus.ready,
    );
  }

  /// التسمية العربية
  String get label {
    switch (this) {
      case CycleStatus.ready:
        return 'جاهز للصرف';
      case CycleStatus.partially_delivered:
        return 'مسلم جزئياً';
      case CycleStatus.delivered:
        return 'مسلم';
      case CycleStatus.missed:
        return 'فات الموعد';
      case CycleStatus.cancelled:
        return 'ملغي';
    }
  }

  /// لون الشارة
  String get colorKey {
    switch (this) {
      case CycleStatus.ready:
        return 'green';
      case CycleStatus.partially_delivered:
        return 'orange';
      case CycleStatus.delivered:
        return 'blue';
      case CycleStatus.missed:
        return 'red';
      case CycleStatus.cancelled:
        return 'gray';
    }
  }

  /// هل يمكن صرفها؟
  bool get canDispense =>
      this == CycleStatus.ready || this == CycleStatus.partially_delivered;
}

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة صرف الصيدلية
/// GET /pharmacy/dispense-queue
/// ─────────────────────────────────────────────────────────────

class DispenseQueuePageData {
  final List<DispenseQueueItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const DispenseQueuePageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory DispenseQueuePageData.fromJson(Map<String, dynamic> json) {
    return DispenseQueuePageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => DispenseQueueItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── عنصر طابور واحد ───────────────────────────────────────────────

class DispenseQueueItem {
  final String id;
  final String patientId;
  final String? nationalId;
  final String? familyBookNumber;
  final String patientName;
  final String prescriptionId;
  final int cycleNumber;
  final String medicationSummary;
  final CycleStatus status;
  final DateTime readySince;
  final DateTime updatedAt;

  const DispenseQueueItem({
    required this.id,
    required this.patientId,
    this.nationalId,
    this.familyBookNumber,
    required this.patientName,
    required this.prescriptionId,
    required this.cycleNumber,
    required this.medicationSummary,
    required this.status,
    required this.readySince,
    required this.updatedAt,
  });

  factory DispenseQueueItem.fromJson(Map<String, dynamic> json) {
    return DispenseQueueItem(
      id: json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      nationalId: json['nationalId']?.toString(),
      familyBookNumber: json['familyBookNumber']?.toString(),
      patientName: json['patientName']?.toString() ?? '',
      prescriptionId: json['prescriptionId']?.toString() ?? '',
      cycleNumber: int.tryParse(json['cycleNumber']?.toString() ?? '1') ?? 1,
      medicationSummary: json['medicationSummary']?.toString() ?? '',
      status: CycleStatus.fromString(json['status']?.toString() ?? 'ready'),
      readySince:
          DateTime.tryParse(json['readySince']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────

  /// رقم الهوية للعرض (nationalId ← familyBookNumber ← '—')
  String get displayId {
    if (nationalId != null && nationalId!.trim().isNotEmpty) return nationalId!;
    if (familyBookNumber != null && familyBookNumber!.trim().isNotEmpty) {
      return familyBookNumber!;
    }
    return '—';
  }

  /// مدة الانتظار منذ الجاهزية
  Duration get waitingDuration => DateTime.now().difference(readySince);

  /// نص مدة الانتظار
  String get waitingDurationText {
    final minutes = waitingDuration.inMinutes;
    final hours = waitingDuration.inHours;

    if (hours >= 24) {
      final days = waitingDuration.inDays;
      return '$days يوم';
    }
    if (hours >= 1) {
      final remainingMinutes = minutes % 60;
      return remainingMinutes == 0
          ? '$hours ساعة'
          : '$hours سا $remainingMinutes د';
    }
    if (minutes > 0) return '$minutes دقيقة';
    return 'الآن';
  }

  /// تاريخ الجاهزية منسق
  String get formattedReadySince {
    final d = readySince.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  /// هل الوصفة جديدة (جاهزة منذ أقل من ساعة)؟
  bool get isNew => waitingDuration.inMinutes < 60;
}
