// ignore_for_file: file_names

enum PrescriptionStatus { newRx, processed }

/// يمثل دواء واحد مع الكمية المطلوبة والكمية المعطاة
class MedicationItem {
  final String name;
  final int requestedQuantity;
  int? givenQuantity; // null يعني أن الصيدلية أعطت الكمية المطلوبة كاملة
  final int? originalRequested; // الكمية الأصلية المطلوبة قبل أي تعديل (في حال كانت الوصفة معدّلة)

  MedicationItem({
    required this.name,
    required this.requestedQuantity,
    this.givenQuantity,
    this.originalRequested,
  });

  /// هل تم إعطاء الكمية المطلوبة كاملة؟
  bool get isFullyGiven => givenQuantity == null || givenQuantity == requestedQuantity;

  /// هل تم تعديل الكمية؟
  bool get isModified => givenQuantity != null && givenQuantity != requestedQuantity;

  /// الكمية الفعلية المعطاة
  int get actualGiven => givenQuantity ?? requestedQuantity;

  /// تحويل من نص مع دعم عدة صيغ:
  /// - "اسم الدواء"                     → كمية 1
  /// - "اسم الدواء (4 قطع)"              → كمية 4
  /// - "اسم الدواء (4 قطعة من أصل 6)"    → مُعطاة 4 من أصل 6
  factory MedicationItem.fromText(String text) {
    final cleanText = text.trim();

    // الصيغة 1: "اسم الدواء (X قطعة من أصل Y)"
    final modifiedRegex = RegExp(
      r'^(.*?)\s*\((\d+)\s*(?:قطع|قطعة)\s*من\s*أصل\s*(\d+)\)$',
    );
    final modifiedMatch = modifiedRegex.firstMatch(cleanText);
    if (modifiedMatch != null) {
      return MedicationItem(
        name: modifiedMatch.group(1)!.trim(),
        requestedQuantity: int.parse(modifiedMatch.group(2)!),
        originalRequested: int.parse(modifiedMatch.group(3)!),
      );
    }

    // الصيغة 2: "اسم الدواء (X قطع)"
    final simpleRegex = RegExp(
      r'^(.*?)\s*\((\d+)\s*(?:قطع|قطعة)\)$',
    );
    final simpleMatch = simpleRegex.firstMatch(cleanText);
    if (simpleMatch != null) {
      return MedicationItem(
        name: simpleMatch.group(1)!.trim(),
        requestedQuantity: int.parse(simpleMatch.group(2)!),
      );
    }

    // الصيغة 3: "اسم الدواء" فقط (الصيغ القديمة مثل Amoxicillin 500mg)
    return MedicationItem(
      name: cleanText,
      requestedQuantity: 1,
    );
  }

  /// تحويل إلى نص بالصيغة القياسية
  String toText() {
    return '$name ($requestedQuantity قطع)';
  }

  /// تحويل إلى نص بعد الصرف مع تعديل الكمية
  String toProcessedText() {
    if (givenQuantity == null || givenQuantity == requestedQuantity) {
      return '$name ($requestedQuantity قطع)';
    }
    return '$name ($givenQuantity قطعة من أصل $requestedRequested)';
  }

  int get requestedRequested => originalRequested ?? requestedQuantity;
}


class PrescriptionModel {
  final String id;
  final String patientName;
  final String? doctorName;
  final String medications;
  final String? notes;
  final DateTime date;
  final PrescriptionStatus status;

  PrescriptionModel({
    required this.id,
    required this.patientName,
    this.doctorName,
    required this.medications,
    this.notes,
    required this.date,
    required this.status,
  });

  /// الحصول على قائمة الأدوية كـ MedicationItem
  List<MedicationItem> get medicationItems {
    return medications
        .split('\n')
        .where((m) => m.trim().isNotEmpty)
        .map((m) => MedicationItem.fromText(m))
        .toList();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'patientName': patientName,
    'doctorName': doctorName,
    'medications': medications,
    'date': date.toIso8601String(),
    'notes': notes,
    'status': status.name,
  };

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      doctorName: json['doctorName'] as String?,
      medications: json['medications'] as String,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      status: PrescriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PrescriptionStatus.newRx,
      ),
    );
  }

  PrescriptionModel copyWith({
    String? id,
    String? patientName,
    String? doctorName,
    String? medications,
    String? notes,
    DateTime? date,
    PrescriptionStatus? status,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}