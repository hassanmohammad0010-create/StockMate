// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// مودل تفاصيل الوصفة — Get Prescription By Id
/// GET /prescriptions/{id}
/// ─────────────────────────────────────────────────────────────

class PrescriptionDetails {
  final String id;
  final String visitId;
  final String patientId;
  final String doctorId;
  final String status;
  final String frequencyUnit;
  final int frequencyInterval;
  final DateTime startDate;
  final int totalCycles;
  final int currentCycleNumber;
  final DateTime? currentCycleStart;
  final DateTime? currentCycleEnd;
  final String currentCycleStatus;
  final String? cancelReason;
  final DateTime createdAt;
  final PrescriptionPatient? patient;
  final PrescriptionDoctor? doctor;
  final PrescriptionVisit? visit;
  final List<PrescriptionItem> items;

  const PrescriptionDetails({
    required this.id,
    required this.visitId,
    required this.patientId,
    required this.doctorId,
    required this.status,
    required this.frequencyUnit,
    required this.frequencyInterval,
    required this.startDate,
    required this.totalCycles,
    required this.currentCycleNumber,
    this.currentCycleStart,
    this.currentCycleEnd,
    required this.currentCycleStatus,
    this.cancelReason,
    required this.createdAt,
    this.patient,
    this.doctor,
    this.visit,
    required this.items,
  });

  factory PrescriptionDetails.fromJson(Map<String, dynamic> json) {
    return PrescriptionDetails(
      id: json['id']?.toString() ?? '',
      visitId: json['visitId']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      frequencyUnit: json['frequencyUnit']?.toString() ?? 'day',
      frequencyInterval:
          int.tryParse(json['frequencyInterval']?.toString() ?? '1') ?? 1,
      startDate: DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      totalCycles: int.tryParse(json['totalCycles']?.toString() ?? '1') ?? 1,
      currentCycleNumber:
          int.tryParse(json['currentCycleNumber']?.toString() ?? '1') ?? 1,
      currentCycleStart:
          DateTime.tryParse(json['currentCycleStart']?.toString() ?? ''),
      currentCycleEnd:
          DateTime.tryParse(json['currentCycleEnd']?.toString() ?? ''),
      currentCycleStatus: json['currentCycleStatus']?.toString() ?? 'ready',
      cancelReason: json['cancelReason']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      patient: json['patient'] is Map
          ? PrescriptionPatient.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
      doctor: json['doctor'] is Map
          ? PrescriptionDoctor.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      visit: json['visit'] is Map
          ? PrescriptionVisit.fromJson(json['visit'] as Map<String, dynamic>)
          : null,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => PrescriptionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  // ─── Helpers ────────────────────────────────────────────────────

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

  String get formattedStartDate {
    final d = startDate.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }
}

class PrescriptionPatient {
  final String id;
  final String fullName;

  const PrescriptionPatient({required this.id, required this.fullName});

  factory PrescriptionPatient.fromJson(Map<String, dynamic> json) {
    return PrescriptionPatient(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}

class PrescriptionDoctor {
  final String id;
  final String fullName;

  const PrescriptionDoctor({required this.id, required this.fullName});

  factory PrescriptionDoctor.fromJson(Map<String, dynamic> json) {
    return PrescriptionDoctor(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}

class PrescriptionVisit {
  final String id;
  final String departmentId;
  final PrescriptionVisitDepartment? department;

  const PrescriptionVisit({
    required this.id,
    required this.departmentId,
    this.department,
  });

  factory PrescriptionVisit.fromJson(Map<String, dynamic> json) {
    return PrescriptionVisit(
      id: json['id']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      department: json['department'] is Map
          ? PrescriptionVisitDepartment.fromJson(
              json['department'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PrescriptionVisitDepartment {
  final String id;
  final String name;

  const PrescriptionVisitDepartment({required this.id, required this.name});

  factory PrescriptionVisitDepartment.fromJson(Map<String, dynamic> json) {
    return PrescriptionVisitDepartment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ─── دواء داخل الوصفة ──────────────────────────────────────────────
class PrescriptionItem {
  final String id;
  final String variantId;
  final int prescribedQuantity; // ✅ الكمية المطلوبة (تُحوّل من String)
  final String dosage;
  final String frequency;
  final int durationDays;
  final int dispensedQuantity; // ✅ الكمية المصروفة سابقاً
  final PrescriptionItemVariant? variant;

  const PrescriptionItem({
    required this.id,
    required this.variantId,
    required this.prescribedQuantity,
    required this.dosage,
    required this.frequency,
    required this.durationDays,
    required this.dispensedQuantity,
    this.variant,
  });

  factory PrescriptionItem.fromJson(Map<String, dynamic> json) {
    return PrescriptionItem(
      id: json['id']?.toString() ?? '',
      variantId: json['variantId']?.toString() ?? '',
      // ✅ الأرقام تأتي كـ String من الباك اند
      prescribedQuantity:
          int.tryParse(json['prescribedQuantity']?.toString() ?? '0') ?? 0,
      dosage: json['dosage']?.toString() ?? '',
      frequency: json['frequency']?.toString() ?? '',
      durationDays:
          int.tryParse(json['durationDays']?.toString() ?? '0') ?? 0,
      dispensedQuantity:
          int.tryParse(json['dispensedQuantity']?.toString() ?? '0') ?? 0,
      variant: json['variant'] is Map
          ? PrescriptionItemVariant.fromJson(
              json['variant'] as Map<String, dynamic>)
          : null,
    );
  }

  String get displayName => variant?.variantName ?? '—';
  String get sku => variant?.sku ?? '—';
}

class PrescriptionItemVariant {
  final String id;
  final String variantName;
  final String sku;

  const PrescriptionItemVariant({
    required this.id,
    required this.variantName,
    required this.sku,
  });

  factory PrescriptionItemVariant.fromJson(Map<String, dynamic> json) {
    return PrescriptionItemVariant(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
    );
  }
}