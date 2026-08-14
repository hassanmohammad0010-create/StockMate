// lib/core/models/Department_Model.dart
class DepartmentModel {
  final String id;
  final String name;
  final String? managerId;
  final String? managerName;

  DepartmentModel({
    required this.id,
    required this.name,
    this.managerId,
    this.managerName,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? manager = json['manager'] is Map
        ? json['manager'] as Map<String, dynamic>
        : null;

    return DepartmentModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      managerId: json['managerId'] as String?,
      managerName: manager?['fullName'] as String?,
    );
  }
}
