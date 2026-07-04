class SupplierProduct {
  final String name;
  const SupplierProduct({required this.name});

  factory SupplierProduct.fromJson(Map<String, dynamic> json) {
    return SupplierProduct(name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class SupplierModel {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String? address;
  final String? notes;
  final bool isActive;
  final List<SupplierProduct> products; // المواد المسؤول عن إحضارها

  const SupplierModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.address,
    this.notes,
    required this.isActive,
    required this.products,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] as int,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] as String?,
      notes: json['notes'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      products: (json['products'] as List<dynamic>? ?? [])
          .map((p) => SupplierProduct.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'notes': notes,
      'is_active': isActive,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
