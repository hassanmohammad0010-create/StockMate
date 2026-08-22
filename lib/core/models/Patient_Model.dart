// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة المرضى — List Patients
/// GET /patients
/// ─────────────────────────────────────────────────────────────

class PatientsPageData {
  final List<PatientListItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const PatientsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PatientsPageData.fromJson(Map<String, dynamic> json) {
    return PatientsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => PatientListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── مودل المريض الواحد ────────────────────────────────────────────

class PatientListItem {
  final String id;
  final String fullName;
  final String? nationalId;
  final String? familyBookNumber;
  final String? patientId;
  final String registeredById;
  final PatientRegisteredBy? registeredBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// ✅ id مدخل الطابور (تذكرة الانتظار) — لازم لإند بوينت الحجز
  final String? queueEntryId;

  /// ✅ اسم الطبيب الذي حجز المريض (يُملأ فقط لحالة in_consultation)
  final String? lockedByName;

  const PatientListItem({
    required this.id,
    required this.fullName,
    this.nationalId,
    this.familyBookNumber,
    this.patientId,
    required this.registeredById,
    this.registeredBy,
    required this.createdAt,
    required this.updatedAt,
    this.queueEntryId,
    this.lockedByName,
  });

  factory PatientListItem.fromJson(Map<String, dynamic> json) {
    return PatientListItem(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      nationalId: json['nationalId']?.toString(),
      familyBookNumber: json['familyBookNumber']?.toString(),
      patientId: json['patientId']?.toString(),
      registeredById: json['registeredById']?.toString() ?? '',
      registeredBy: json['registeredBy'] is Map
          ? PatientRegisteredBy.fromJson(
              json['registeredBy'] as Map<String, dynamic>,
            )
          : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      // queueEntryId و lockedByName لا يأتيان من هذا الإند بوينت — يُمرران من طابور القسم
    );
  }

  // ─── Helpers للعرض ───────────────────────────────────────────────

  /// الاسم
  String get name => fullName;

  /// ✅ التسلسل: nationalId ← familyBookNumber ← patientId ← 'غير متوفر'
  String get nationalNumber {
    if (nationalId != null && nationalId!.trim().isNotEmpty) {
      return nationalId!;
    }
    if (familyBookNumber != null && familyBookNumber!.trim().isNotEmpty) {
      return familyBookNumber!;
    }
    if (patientId != null && patientId!.trim().isNotEmpty) {
      return patientId!;
    }
    return 'غير متوفر';
  }

  /// مدة الانتظار = الوقت منذ التسجيل/الإضافة للطابور
  Duration get waitingDuration => DateTime.now().difference(createdAt);

  /// نص مدة الانتظار
  String get waitingDurationText {
    final minutes = waitingDuration.inMinutes;
    final hours = waitingDuration.inHours;

    if (hours >= 1) {
      final remainingMinutes = minutes % 60;
      return remainingMinutes == 0
          ? '$hours ساعة'
          : '$hours سا $remainingMinutes د';
    }
    if (minutes > 0) return '$minutes دقيقة';
    return 'الآن';
  }

  /// من سجّل المريض
  String get registeredByName => registeredBy?.fullName ?? '—';

  /// تنسيق تاريخ التسجيل
  String get formattedCreatedAt {
    final d = createdAt.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }
}

// ─── من سجّل المريض ─────────────────────────────────────────────────

class PatientRegisteredBy {
  final String id;
  final String fullName;

  const PatientRegisteredBy({required this.id, required this.fullName});

  factory PatientRegisteredBy.fromJson(Map<String, dynamic> json) {
    return PatientRegisteredBy(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}