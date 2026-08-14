// lib/core/models/User_Model.dart
// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// Enum الدور (Role)
/// ─────────────────────────────────────────────────────────────

enum RoleName {
  hospital_manager,
  warehouse_manager,
  purchasing_manager,
  department_manager,
  doctor,
  pharmacy_staff,
  reception_staff,
  // ملاحظة: شلنا unknown لأنه ما عاد إلها داعي كـ enum يتخزن
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
      case 'purchasing_manager': // ✅ اتصلحت لتطابق الـ API الفعلي
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
}

/// ─────────────────────────────────────────────────────────────
/// Enum حالة المستخدم
/// ─────────────────────────────────────────────────────────────

enum UserStatus {
  active,
  inactive;

  static UserStatus fromString(String value) {
    return UserStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => UserStatus.active,
    );
  }
}

extension UserStatusX on UserStatus {
  String get arabicLabel => this == UserStatus.active ? 'نشط' : 'غير نشط';
}

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة المستخدمين — List Users
/// GET /users
/// ─────────────────────────────────────────────────────────────

class UsersPageData {
  final List<UserItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const UsersPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory UsersPageData.fromJson(Map<String, dynamic> json) {
    return UsersPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => UserItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── مودل المستخدم الواحد ───────────────────────────────────────────

class UserItem {
  final String id;
  final String fullName;
  final String? phone;
  final String? email;
  final String? specialty;
  final UserStatus status;
  final RoleModel? role;
  final UserDepartment? department;

  const UserItem({
    required this.id,
    required this.fullName,
    this.phone,
    this.email,
    this.specialty,
    required this.status,
    this.role,
    this.department,
  });

  factory UserItem.fromJson(Map<String, dynamic> json) {
    return UserItem(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      specialty: json['specialty'] as String?,
      status: UserStatus.fromString(json['status'] as String? ?? 'active'),
      // ✅ لو الدور مش معروف (زي super_admin) بيرجع null بدل ما يعمل كراش
      role: json['role'] is Map
          ? RoleModel.fromJson(json['role'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map
          ? UserDepartment.fromJson(json['department'] as Map<String, dynamic>)
          : null,
    );
  }

  // ─── تسمية عربية جاهزة للحالة والدور ────────────────────────
  String get statusLabel => status.arabicLabel;

  /// تسمية عربية للدور، أو '---' لو الدور مش معروف (زي super_admin)
  String get roleLabel => role?.name.arabicLabel ?? '---';
}

// ─── القسم (Department) ─────────────────────────────────────────

class UserDepartment {
  final String id;
  final String name;

  const UserDepartment({required this.id, required this.name});

  factory UserDepartment.fromJson(Map<String, dynamic> json) {
    return UserDepartment(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}
