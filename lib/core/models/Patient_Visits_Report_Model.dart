// lib/core/models/Patient_Visits_Report_Model.dart
// ignore_for_file: file_names

class PatientVisitsReport {
  final VisitsSummary summary;
  final List<VisitsByDepartment> byDepartment;
  final List<VisitsSeriesPoint> series;
  final VisitRowsPageData rows;
  final String groupBy;

  const PatientVisitsReport({
    required this.summary,
    required this.byDepartment,
    required this.series,
    required this.rows,
    required this.groupBy,
  });

  factory PatientVisitsReport.fromJson(Map<String, dynamic> json) {
    return PatientVisitsReport(
      summary: VisitsSummary.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      byDepartment: (json['byDepartment'] as List? ?? [])
          .map((e) => VisitsByDepartment.fromJson(e as Map<String, dynamic>))
          .toList(),
      series: (json['series'] as List? ?? [])
          .map((e) => VisitsSeriesPoint.fromJson(e as Map<String, dynamic>))
          .toList(),
      rows: VisitRowsPageData.fromJson(
        json['rows'] as Map<String, dynamic>? ?? {},
      ),
      groupBy: json['groupBy']?.toString() ?? '',
    );
  }
}

// ─── الملخص ─────────────────────────────────────────────────────

class VisitsSummary {
  final int totalVisits;
  final int uniquePatients;
  final List<VisitsStatusCount> byStatus;

  const VisitsSummary({
    required this.totalVisits,
    required this.uniquePatients,
    required this.byStatus,
  });

  factory VisitsSummary.fromJson(Map<String, dynamic> json) {
    return VisitsSummary(
      totalVisits: json['totalVisits'] as int? ?? 0,
      uniquePatients: json['uniquePatients'] as int? ?? 0,
      byStatus: (json['byStatus'] as List? ?? [])
          .map((e) => VisitsStatusCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class VisitsStatusCount {
  final String status;
  final int count;

  const VisitsStatusCount({required this.status, required this.count});

  factory VisitsStatusCount.fromJson(Map<String, dynamic> json) {
    return VisitsStatusCount(
      status: json['status']?.toString() ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

// ─── حسب القسم ──────────────────────────────────────────────────

class VisitsByDepartment {
  final String departmentId;
  final String departmentName;
  final int visitCount;
  final int uniquePatientCount;

  const VisitsByDepartment({
    required this.departmentId,
    required this.departmentName,
    required this.visitCount,
    required this.uniquePatientCount,
  });

  factory VisitsByDepartment.fromJson(Map<String, dynamic> json) {
    return VisitsByDepartment(
      departmentId: json['departmentId']?.toString() ?? '',
      departmentName: json['departmentName']?.toString() ?? '',
      visitCount: json['visitCount'] as int? ?? 0,
      uniquePatientCount: json['uniquePatientCount'] as int? ?? 0,
    );
  }
}

// ─── السلسلة الزمنية ────────────────────────────────────────────

class VisitsSeriesPoint {
  final String bucket;
  final int visitCount;

  const VisitsSeriesPoint({required this.bucket, required this.visitCount});

  factory VisitsSeriesPoint.fromJson(Map<String, dynamic> json) {
    return VisitsSeriesPoint(
      bucket: json['bucket']?.toString() ?? '',
      visitCount: json['visitCount'] as int? ?? 0,
    );
  }
}

// ─── صفحات صفوف الزيارات ────────────────────────────────────────

class VisitRowsPageData {
  final List<VisitRow> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const VisitRowsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory VisitRowsPageData.fromJson(Map<String, dynamic> json) {
    return VisitRowsPageData(
      items: (json['items'] as List? ?? [])
          .map((e) => VisitRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── صف الزيارة الواحدة ─────────────────────────────────────────

class VisitRow {
  final String id;
  final DateTime? visitDate;
  final String status;
  final String? cancelReason;
  final VisitPatient? patient;
  final VisitDoctor? doctor;
  final VisitDepartment? department;

  const VisitRow({
    required this.id,
    this.visitDate,
    required this.status,
    this.cancelReason,
    this.patient,
    this.doctor,
    this.department,
  });

  factory VisitRow.fromJson(Map<String, dynamic> json) {
    return VisitRow(
      id: json['id']?.toString() ?? '',
      visitDate: json['visitDate'] != null
          ? DateTime.tryParse(json['visitDate'].toString())
          : null,
      status: json['status']?.toString() ?? '',
      cancelReason: json['cancelReason']?.toString(),
      patient: json['patient'] is Map
          ? VisitPatient.fromJson(json['patient'] as Map<String, dynamic>)
          : null,
      doctor: json['doctor'] is Map
          ? VisitDoctor.fromJson(json['doctor'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map
          ? VisitDepartment.fromJson(json['department'] as Map<String, dynamic>)
          : null,
    );
  }
}

class VisitPatient {
  final String id;
  final String fullName;
  final String? nationalId;

  const VisitPatient({
    required this.id,
    required this.fullName,
    this.nationalId,
  });

  factory VisitPatient.fromJson(Map<String, dynamic> json) {
    return VisitPatient(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      nationalId: json['nationalId']?.toString(),
    );
  }
}

class VisitDoctor {
  final String id;
  final String fullName;
  final String? specialty;

  const VisitDoctor({required this.id, required this.fullName, this.specialty});

  factory VisitDoctor.fromJson(Map<String, dynamic> json) {
    return VisitDoctor(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      specialty: json['specialty']?.toString(),
    );
  }
}

class VisitDepartment {
  final String id;
  final String name;

  const VisitDepartment({required this.id, required this.name});

  factory VisitDepartment.fromJson(Map<String, dynamic> json) {
    return VisitDepartment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}
