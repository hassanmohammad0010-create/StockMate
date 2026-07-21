// ignore_for_file: file_names

class PatientModel {
  final String id;
  final String name;
  final String nationalNumber;
  final DateTime arrivalTime;
  final String status; // حقل الحالة

  PatientModel({
    required this.id,
    required this.name,
    required this.nationalNumber,
    required this.arrivalTime,
    this.status = 'في الانتظار', // القيمة الافتراضية
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      nationalNumber: json['national_number'] ?? '',
      arrivalTime: DateTime.tryParse(json['arrival_time'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'في الانتظار',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'national_number': nationalNumber,
      'arrival_time': arrivalTime.toIso8601String(),
      'status': status,
    };
  }

  PatientModel copyWith({
    String? id,
    String? name,
    String? nationalNumber,
    DateTime? arrivalTime,
    String? status,
  }) {
    return PatientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nationalNumber: nationalNumber ?? this.nationalNumber,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      status: status ?? this.status,
    );
  }

  Duration get waitingDuration => DateTime.now().difference(arrivalTime);

  String get waitingDurationText {
    final duration = waitingDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours ساعة${minutes > 0 ? ' و $minutes دقيقة' : ''}';
    }
    return '$minutes دقيقة';
  }
}