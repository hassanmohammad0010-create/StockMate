class PrescriptionModel {
  final String id;
  final String patientName;
  final String doctorName;
  final String condition;
  final String medications;
  final DateTime date;

  PrescriptionModel({
    required this.id,
    required this.patientName,
    required this.doctorName,
    required this.condition,
    required this.medications,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'patientName': patientName,
        'doctorName': doctorName,
        'condition': condition,
        'medications': medications,
        'date': date.toIso8601String(),
      };

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] as String,
      patientName: json['patientName'] as String,
      doctorName: json['doctorName'] as String,
      condition: json['condition'] as String,
      medications: json['medications'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}