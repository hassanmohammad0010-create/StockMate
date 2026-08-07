// lib/core/models/Supplier_Model.dart
class SupplierModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final bool isActive;

  SupplierModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.isActive = true,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email'] as String?,
      address: json['address'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
