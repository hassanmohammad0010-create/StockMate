enum RoleName {
  hospital_manager,
  warehouse_manager,
  purchasing_manager,
  department_manager,
  doctor,
  pharmacy_staff,
  reception_staff,
  // ملاحظة: شلت unknown لأنه ما عاد إلها داعي كـ enum يتخزن
}

extension RoleNameX on RoleName {
  String get arabicLabel {
    switch (this) {
      case RoleName.hospital_manager:
        return 'مدير المستشفى';
      case RoleName.warehouse_manager:
        return 'مدير المستودع';
      case RoleName.purchasing_manager:
        return 'مدير لجنة المشتريات';
      case RoleName.department_manager:
        return 'مدير القسم';
      case RoleName.doctor:
        return 'طبيب';
      case RoleName.pharmacy_staff:
        return 'موظف صيدلية';
      case RoleName.reception_staff:
        return 'موظف استقبال';
    }
  }

  /// يرجع null إذا القيمة مش موجودة بالـ enum (بما فيها super_admin)
  static RoleName? fromApiValue(String? value) {
    switch (value) {
      case 'hospital_manager':
        return RoleName.hospital_manager;
      case 'warehouse_manager':
        return RoleName.warehouse_manager;
      case 'purchasing_committee_manager':
        return RoleName.purchasing_manager;
      case 'department_manager':
        return RoleName.department_manager;
      case 'doctor':
        return RoleName.doctor;
      case 'pharmacy_staff':
        return RoleName.pharmacy_staff;
      case 'reception_staff':
        return RoleName.reception_staff;
      default:
        return null; // أي قيمة غير معروفة (super_admin وغيرها) بترجع null
    }
  }
}

class RoleModel {
  final String id;
  final RoleName name;

  RoleModel({required this.id, required this.name});

  /// يرجع null إذا الـ role مش موجود بالـ enum، حتى نقدر نستبعده لاحقاً
  static RoleModel? fromJson(Map<String, dynamic> json) {
    final role = RoleNameX.fromApiValue(json['name']);
    if (role == null) return null; // استبعاد فوري

    return RoleModel(id: json['id']?.toString() ?? '', name: role);
  }

  static List<RoleModel> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
        .whereType<RoleModel>() // بتشيل الـ null تلقائياً
        .toList();
  }
}
