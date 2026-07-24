enum RoleName {
  hospital_manager,
  warehouse_manager,
  purchasing_committee_manager,
  department_manager,
  doctor,
  pharmacy_staff,
  reception_staff,
  unknown,
}

extension RoleNameX on RoleName {
  String get arabicLabel {
    switch (this) {
      case RoleName.hospital_manager:
        return 'مدير المستشفى';
      case RoleName.warehouse_manager:
        return 'مدير المستودع';
      case RoleName.purchasing_committee_manager:
        return 'مدير لجنة المشتريات';
      case RoleName.department_manager:
        return 'مدير القسم';
      case RoleName.doctor:
        return 'طبيب';
      case RoleName.pharmacy_staff:
        return 'موظف صيدلية';
      case RoleName.reception_staff:
        return 'موظف استقبال';
      case RoleName.unknown:
        return 'غير معروف';
    }
  }

  static RoleName fromApiValue(String? value) {
    switch (value) {
      case 'hospital_manager':
        return RoleName.hospital_manager;
      case 'warehouse_manager':
        return RoleName.warehouse_manager;
      case 'purchasing_committee_manager':
        return RoleName.purchasing_committee_manager;
      case 'department_manager':
        return RoleName.department_manager;
      case 'doctor':
        return RoleName.doctor;
      case 'pharmacy_staff':
        return RoleName.pharmacy_staff;
      case 'reception_staff':
        return RoleName.reception_staff;
      default:
        return RoleName.unknown; // fallback آمن بدل ما يرمي exception
    }
  }
}

class RoleModel {
  final String id;
  final RoleName name;

  RoleModel({required this.id, required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toString() ?? '',
      name: RoleNameX.fromApiValue(json['name']),
    );
  }
}
