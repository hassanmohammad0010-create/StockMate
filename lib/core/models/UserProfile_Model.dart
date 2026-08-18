// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// ثوابت الصلاحيات — لاستخدامها بأمان بدل كتابة النصوص يدوياً
/// ─────────────────────────────────────────────────────────────

class Permissions {
  static const String createDepartmentRefillRequest =
      'create_department_refill_request';
  static const String confirmDepartmentDelivery = 'confirm_department_delivery';
  static const String viewInventory = 'view_inventory';
  static const String performInventoryAdjustment =
      'perform_inventory_adjustment';
  static const String performStockCount = 'perform_stock_count';
  static const String recordDepartmentConsumption =
      'record_department_consumption';
  static const String manageDepartmentQueue = 'manage_department_queue';
  static const String viewPatients = 'view_patients';
  static const String viewPatientHistory = 'view_patient_history';
  static const String cancelVisit = 'cancel_visit';
}

/// ─────────────────────────────────────────────────────────────
/// مودل ملف المستخدم الكامل — Get My Profile
/// GET /users/me
/// ─────────────────────────────────────────────────────────────

class UserProfile {
  final String id;
  final String fullName;
  final String? phone;
  final String? email;
  final String? specialty;
  final String status;
  final String? roleId;
  final String? departmentId;
  final UserRole? role;
  final UserDepartment? department;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> permissions;

  const UserProfile({
    required this.id,
    required this.fullName,
    this.phone,
    this.email,
    this.specialty,
    required this.status,
    this.roleId,
    this.departmentId,
    this.role,
    this.department,
    required this.createdAt,
    required this.updatedAt,
    required this.permissions,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      specialty: json['specialty']?.toString(),
      status: json['status']?.toString() ?? '',
      roleId: json['roleId']?.toString(),
      departmentId: json['departmentId']?.toString(),
      role: json['role'] is Map
          ? UserRole.fromJson(json['role'] as Map<String, dynamic>)
          : null,
      department: json['department'] is Map
          ? UserDepartment.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      permissions: (json['permissions'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  // ─── ✅ Helpers ──────────────────────────────────────────────────

  /// اسم الدور (department_manager / doctor / pharmacist ...)
  String get roleName => role?.name ?? '';

  /// اسم القسم
  String get departmentName => department?.name ?? '';

  /// هل الحساب نشط؟
  bool get isActive => status == 'active';

  /// ✅ فحوصات سريعة للأدوار الشائعة
  bool get isDepartmentManager => roleName == 'department_manager';
  bool get isDoctor => roleName == 'doctor';
  bool get isPharmacist => roleName == 'pharmacist';
  bool get isReception => roleName == 'reception';

  /// ✅✅✅ فحص صلاحية معينة
  bool hasPermission(String permission) => permissions.contains(permission);

  /// هل يملك أي صلاحية من القائمة؟
  bool hasAnyPermission(List<String> perms) =>
      perms.any((p) => permissions.contains(p));

  /// هل يملك كل الصلاحيات؟
  bool hasAllPermissions(List<String> perms) =>
      perms.every((p) => permissions.contains(p));
}

// ─── الدور ─────────────────────────────────────────────────────────
class UserRole {
  final String id;
  final String name;

  const UserRole({required this.id, required this.name});

  factory UserRole.fromJson(Map<String, dynamic> json) {
    return UserRole(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}

// ─── القسم ─────────────────────────────────────────────────────────
class UserDepartment {
  final String id;
  final String name;

  const UserDepartment({required this.id, required this.name});

  factory UserDepartment.fromJson(Map<String, dynamic> json) {
    return UserDepartment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}