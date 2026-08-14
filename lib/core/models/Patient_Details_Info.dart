// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل تفاصيل المريض (السجل الطبي)
/// GET /medical-visits/patient/{id}/history
/// ─────────────────────────────────────────────────────────────

class PatientDetailsResponse {
  final PatientDetailsInfo patient;
  final List<PatientDepartmentHistory> departments;

  const PatientDetailsResponse({
    required this.patient,
    required this.departments,
  });

  factory PatientDetailsResponse.fromJson(Map<String, dynamic> json) {
    return PatientDetailsResponse(
      patient: PatientDetailsInfo.fromJson(
        json['patient'] as Map<String, dynamic>,
      ),
      departments: (json['departments'] as List<dynamic>? ?? [])
          .map((e) =>
              PatientDepartmentHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// إجمالي عدد الزيارات عبر كل الأقسام
  int get totalVisits =>
      departments.fold(0, (sum, d) => sum + d.visits.length);
}

// ─── معلومات المريض ────────────────────────────────────────────────
class PatientDetailsInfo {
  final String id;
  final String fullName;
  final String? nationalId;
  final String? patientId;

  const PatientDetailsInfo({
    required this.id,
    required this.fullName,
    this.nationalId,
    this.patientId,
  });

  factory PatientDetailsInfo.fromJson(Map<String, dynamic> json) {
    return PatientDetailsInfo(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      nationalId: json['nationalId']?.toString(),
      patientId: json['patientId']?.toString(),
    );
  }

  /// ✅ التسلسل: nationalId ← familyBookNumber ← patientId ← 'غير متوفر'
  String get displayId {
    if (nationalId != null && nationalId!.trim().isNotEmpty) return nationalId!;
    if (patientId != null && patientId!.trim().isNotEmpty) return patientId!;
    return 'غير متوفر';
  }
}

// ─── قسم مع زياراته ────────────────────────────────────────────────
class PatientDepartmentHistory {
  final String id;
  final String name;
  final List<PatientVisit> visits;

  const PatientDepartmentHistory({
    required this.id,
    required this.name,
    required this.visits,
  });

  factory PatientDepartmentHistory.fromJson(Map<String, dynamic> json) {
    return PatientDepartmentHistory(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      visits: (json['visits'] as List<dynamic>? ?? [])
          .map((e) => PatientVisit.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// ترتيب الزيارات من الأحدث للأقدم
  List<PatientVisit> get sortedVisits {
    final sorted = List<PatientVisit>.from(visits);
    sorted.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    return sorted;
  }
}

// ─── زيارة واحدة ───────────────────────────────────────────────────
class PatientVisit {
  final String id;
  final DateTime visitDate;
  final String status;
  final String? clinicalNotes;
  final String? diagnosis;
  final String? externalMedications;
  final String? cancelReason;
  final PatientDoctor? doctor;

  const PatientVisit({
    required this.id,
    required this.visitDate,
    required this.status,
    this.clinicalNotes,
    this.diagnosis,
    this.externalMedications,
    this.cancelReason,
    this.doctor,
  });

  factory PatientVisit.fromJson(Map<String, dynamic> json) {
    return PatientVisit(
      id: json['id']?.toString() ?? '',
      visitDate:
          DateTime.tryParse(json['visitDate']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? '',
      clinicalNotes: json['clinicalNotes']?.toString(),
      diagnosis: json['diagnosis']?.toString(),
      externalMedications: json['externalMedications']?.toString(),
      cancelReason: json['cancelReason']?.toString(),
      doctor: json['doctor'] is Map
          ? PatientDoctor.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
    );
  }

  // ─── Helpers ───────────────────────────────────────────────────

  /// ✅ ترجمة الحالة
  String get statusLabel {
    switch (status) {
      case 'completed':
        return 'مكتملة';
      case 'cancelled':
        return 'ملغاة';
      case 'scheduled':
        return 'مجدولة';
      case 'in_progress':
        return 'قيد الإجراء';
      case 'pending':
        return 'قيد الانتظار';
      default:
        return status;
    }
  }

  /// هل الزيارة ملغاة؟
  bool get isCancelled => status == 'cancelled';

  /// تنسيق تاريخ الزيارة
  String get formattedVisitDate {
    final d = visitDate.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  /// تاريخ الزيارة فقط (بدون الوقت)
  String get formattedVisitDateOnly {
    final d = visitDate.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  /// هل توجد ملاحظات سريرية؟
  bool get hasClinicalNotes =>
      clinicalNotes != null && clinicalNotes!.trim().isNotEmpty;

  /// هل يوجد تشخيص؟
  bool get hasDiagnosis =>
      diagnosis != null && diagnosis!.trim().isNotEmpty;

  /// هل توجد أدوية خارجية؟
  bool get hasExternalMedications =>
      externalMedications != null && externalMedications!.trim().isNotEmpty;

  /// هل يوجد سبب للإلغاء؟
  bool get hasCancelReason =>
      cancelReason != null && cancelReason!.trim().isNotEmpty;
}

// ─── معلومات الطبيب ────────────────────────────────────────────────
class PatientDoctor {
  final String id;
  final String fullName;
  final String? specialty;

  const PatientDoctor({
    required this.id,
    required this.fullName,
    this.specialty,
  });

  factory PatientDoctor.fromJson(Map<String, dynamic> json) {
    return PatientDoctor(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      specialty: json['specialty']?.toString(),
    );
  }
}