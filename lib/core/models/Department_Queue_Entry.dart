// ignore_for_file: file_names

// import 'package:stock_mate_project/core/models/Patient_List_Model.dart';
import 'package:stock_mate_project/core/models/Patient_Model.dart';

/// ─────────────────────────────────────────────────────────────
/// enum حالة الطابور — يجب أن يتطابق 100% مع الباك اند
/// ─────────────────────────────────────────────────────────────

enum QueueStatus {
  waiting,
  in_consultation,
  completed,
  removed;

  /// تحويل من نص الـ API إلى enum
  static QueueStatus fromString(String value) {
    return QueueStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => QueueStatus.waiting,
    );
  }

  /// ✅ التسمية العربية للعرض
  String get label {
    switch (this) {
      case QueueStatus.waiting:
        return 'في الانتظار';
      case QueueStatus.in_consultation:
        return 'قيد المعاينة';
      case QueueStatus.completed:
        return 'تمت المعاينة';
      case QueueStatus.removed:
        return 'مُزال من الطابور';
    }
  }
}

/// ─────────────────────────────────────────────────────────────
/// مودل طابور القسم — Department Queue
/// GET /department-queue
/// ─────────────────────────────────────────────────────────────

class DepartmentQueuePageData {
  final List<DepartmentQueueEntry> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const DepartmentQueuePageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory DepartmentQueuePageData.fromJson(Map<String, dynamic> json) {
    return DepartmentQueuePageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => DepartmentQueueEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── مدخل طابور واحد ───────────────────────────────────────────────

class DepartmentQueueEntry {
  final String id; // ✅ id مدخل الطابور = queueEntryId
  final String departmentId;
  final QueueDepartment? department;
  final String patientId;
  final QueuePatient? patient;
  final QueueStatus status;
  final String addedById;
  final QueuePerson? addedBy;
  final DateTime addedAt;
  final String? lockedById;
  final QueuePerson? lockedBy;
  final DateTime? lockedAt;
  final DateTime? completedAt;
  final String? removedById;
  final String? removedReason;

  const DepartmentQueueEntry({
    required this.id,
    required this.departmentId,
    this.department,
    required this.patientId,
    this.patient,
    required this.status,
    required this.addedById,
    this.addedBy,
    required this.addedAt,
    this.lockedById,
    this.lockedBy,
    this.lockedAt,
    this.completedAt,
    this.removedById,
    this.removedReason,
  });

  factory DepartmentQueueEntry.fromJson(Map<String, dynamic> json) {
    return DepartmentQueueEntry(
      id: json['id']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      department: json['department'] is Map
          ? QueueDepartment.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      patientId: json['patientId']?.toString() ?? '',
      patient: json['patient'] is Map
          ? QueuePatient.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
      status: QueueStatus.fromString(json['status']?.toString() ?? 'waiting'),
      addedById: json['addedById']?.toString() ?? '',
      addedBy: json['addedBy'] is Map
          ? QueuePerson.fromJson(json['addedBy'] as Map<String, dynamic>)
          : null,
      addedAt:
          DateTime.tryParse(json['addedAt']?.toString() ?? '') ??
          DateTime.now(),
      lockedById: json['lockedById']?.toString(),
      lockedBy: json['lockedBy'] is Map
          ? QueuePerson.fromJson(json['lockedBy'] as Map<String, dynamic>)
          : null,
      lockedAt: _parseDate(json['lockedAt']),
      completedAt: _parseDate(json['completedAt']),
      removedById: json['removedById']?.toString(),
      removedReason: json['removedReason']?.toString(),
    );
  }

  static DateTime? _parseDate(dynamic v) =>
      v == null ? null : DateTime.tryParse(v.toString());

  // ─── Helpers للحالة ──────────────────────────────────────────────

  bool get isWaiting => status == QueueStatus.waiting;
  bool get isInConsultation => status == QueueStatus.in_consultation;
  bool get isCompleted => status == QueueStatus.completed;
  bool get isRemoved => status == QueueStatus.removed;

  String get statusLabel => status.label;

  /// ✅✅✅ التحويل إلى PatientListItem
  /// (حتى تبقى الكاردات وصفحة التفاصيل كما هي بدون أي تعديل)
  PatientListItem toPatientListItem() {
    return PatientListItem(
      // ✅ id المريض الحقيقي — مهم لصفحة التفاصيل (السجل الطبي)
      id: patient?.id ?? patientId,
      fullName: patient?.fullName ?? '',
      nationalId: patient?.nationalId,
      familyBookNumber: patient?.familyBookNumber,
      patientId: patient?.patientId,
      registeredById: addedById,
      registeredBy: addedBy != null
          ? PatientRegisteredBy(id: addedBy!.id, fullName: addedBy!.fullName)
          : null,
      // ✅ مدة الانتظار تُحسب من addedAt
      createdAt: addedAt,
      updatedAt: addedAt,
      // ✅✅✅ id مدخل الطابور — لازم لزر الحجز
      queueEntryId: id,
    );
  }
}

// ─── القسم ─────────────────────────────────────────────────────────
class QueueDepartment {
  final String id;
  final String name;

  const QueueDepartment({required this.id, required this.name});

  factory QueueDepartment.fromJson(Map<String, dynamic> json) {
    return QueueDepartment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ─── المريض داخل الطابور ───────────────────────────────────────────
class QueuePatient {
  final String id;
  final String fullName;
  final String? nationalId;
  final String? patientId;
  final String? familyBookNumber;

  const QueuePatient({
    required this.id,
    required this.fullName,
    this.nationalId,
    this.patientId,
    this.familyBookNumber,
  });

  factory QueuePatient.fromJson(Map<String, dynamic> json) {
    return QueuePatient(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      nationalId: json['nationalId']?.toString(),
      patientId: json['patientId']?.toString(),
      familyBookNumber: json['familyBookNumber']?.toString(),
    );
  }
}

// ─── شخص (من أضاف / من قفل) ────────────────────────────────────────
class QueuePerson {
  final String id;
  final String fullName;

  const QueuePerson({required this.id, required this.fullName});

  factory QueuePerson.fromJson(Map<String, dynamic> json) {
    return QueuePerson(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}
