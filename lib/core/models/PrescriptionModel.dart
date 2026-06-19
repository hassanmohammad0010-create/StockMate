// ignore_for_file: file_names

enum PrescriptionStatus { newRx, processed }

class PrescriptionModel {
  final String id;
  final String patientName;
  final String doctorName;
  final String condition;
  final String medications;
  final String? notes;
  final DateTime date;
  final PrescriptionStatus status;

  PrescriptionModel({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.condition,
    required this.medications,
    this.notes,
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientName': patientName,
        'doctorName': doctorName,
        'condition': condition,
        'medications': medications,
        'date': date.toIso8601String(),
        'notes': notes,
        'status': status.name,
      };

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      doctorName: json['doctorName'] as String,
      condition: json['condition'] as String,
      medications: json['medications'] as String,
      date: DateTime.parse(json['date'] as String),
      notes: json['notes'] as String?,
      status: PrescriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PrescriptionStatus.newRx,
      ),
    );
  }

  // مفيدة للتحديث الفوري لحالة الوصفة دون إعادة بناء كل الكائن يدويًا
  PrescriptionModel copyWith({
    String? id,
    String? patientName,
    String? doctorName,
    String? condition,
    String? medications,
    String? notes,
    DateTime? date,
    PrescriptionStatus? status,
  }) {
    return PrescriptionModel(
      id: id ?? this.id,
      patientName: patientName ?? this.patientName,
      doctorName: doctorName ?? this.doctorName,
      condition: condition ?? this.condition,
      medications: medications ?? this.medications,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }
}