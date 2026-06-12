class Supplier {
  final int id;
  final String name;
  final String phone;
  final String email;
  final List<String> materials; // المواد المسؤول عن إحضارها

  const Supplier({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.materials,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
      id: json['id'] as int,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      materials: List<String>.from(json['materials'] ?? []),
    );
  }
}
