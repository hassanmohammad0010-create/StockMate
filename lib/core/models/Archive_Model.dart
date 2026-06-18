// ignore_for_file: file_names

class ArchiveMedicineModel {
  final String name;
  final int quantity;
  final String company;

  ArchiveMedicineModel({
    required this.name,
    required this.quantity,
    required this.company,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'company': company,
      };

  factory ArchiveMedicineModel.fromJson(Map<String, dynamic> json) =>
      ArchiveMedicineModel(
        name: json['name'] as String,
        quantity: json['quantity'] as int,
        company: json['company'] as String,
      );
}