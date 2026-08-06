
// ignore_for_file: file_names
/// ══════════════════════════════════════════════════════════════════════
/// enum الحالات - يجب أن يتطابق 100% مع الباك اند
/// ══════════════════════════════════════════════════════════════════════

enum RequestStatus {
  draft,
  pendingHospitalApproval,
  pendingManagerApproval,
  hospitalRejected,
  managerRejected,
  preparing,
  complete,
  partiallyComplete,
  cancelled;

  /// الباك اند يرسل snake_case: "pending_hospital_approval"
  static RequestStatus fromString(String value) {
    final normalized = value.toLowerCase().replaceAll('_', '');
    return RequestStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => RequestStatus.draft,
    );
  }

  String get displayName => switch (this) {
    RequestStatus.draft => 'مسودة',
    RequestStatus.pendingHospitalApproval => 'بانتظار موافقة المشفى',
    RequestStatus.pendingManagerApproval => 'بانتظار موافقة المدير',
    RequestStatus.hospitalRejected => 'مرفوض من المشفى',
    RequestStatus.managerRejected => 'مرفوض من المدير',
    RequestStatus.preparing => 'قيد التحضير',
    RequestStatus.complete => 'مكتمل',
    RequestStatus.partiallyComplete => 'مكتمل جزئياً',
    RequestStatus.cancelled => 'ملغي',
  };
}

/// ══════════════════════════════════════════════════════════════════════
/// موديلات الإرسال (Request Body)
/// ══════════════════════════════════════════════════════════════════════

class RequestItemInput {
  final String variantId;
  final int requestedQuantity;

  RequestItemInput({
    required this.variantId,
    required this.requestedQuantity,
  });

  Map<String, dynamic> toJson() => {
        'variantId': variantId,
        'requestedQuantity': requestedQuantity,
      };
}

class CreateRefillRequestModel {
  final String priority;
  final String requestType;
  final int? frequencyInterval;
  final String? notes;
  final List<RequestItemInput> items;

  CreateRefillRequestModel({
    required this.priority,
    required this.requestType,
    this.frequencyInterval,
    this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() => {
        'priority': priority,
        'requestType': requestType,
        'frequencyInterval': frequencyInterval,
        'notes': notes,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

/// ══════════════════════════════════════════════════════════════════════
/// موديلات الاستقبال (Response)
/// ══════════════════════════════════════════════════════════════════════

class RefillRequest {
  final String id;
  final String requestNumber;
  final String departmentId;
  final RefillDepartment? department;
  final String requestedById;
  final RefillRequestedBy? requestedBy;
  final RequestStatus status;        // ✅ تغيّر من String لـ RequestStatus
  final String priority;
  final String requestType;
  final int? frequencyInterval;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<RefillRequestItem> items;

  RefillRequest({
    required this.id,
    required this.requestNumber,
    required this.departmentId,
    this.department,
    required this.requestedById,
    this.requestedBy,
    required this.status,
    required this.priority,
    required this.requestType,
    this.frequencyInterval,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
  });

  factory RefillRequest.fromJson(Map<String, dynamic> json) {
    return RefillRequest(
      id: json['id']?.toString() ?? '',
      requestNumber: json['requestNumber']?.toString() ?? '',
      departmentId: json['departmentId']?.toString() ?? '',
      department: json['department'] is Map
          ? RefillDepartment.fromJson(json['department'])
          : null,
      requestedById: json['requestedById']?.toString() ?? '',
      requestedBy: json['requestedBy'] is Map
          ? RefillRequestedBy.fromJson(json['requestedBy'])
          : null,
      status: RequestStatus.fromString(json['status']?.toString() ?? 'draft'),
      priority: json['priority']?.toString() ?? '',
      requestType: json['requestType']?.toString() ?? '',
      frequencyInterval: json['frequencyInterval'] != null
          ? int.tryParse(json['frequencyInterval'].toString())
          : null,
      notes: json['notes']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      items: (json['items'] as List? ?? [])
          .map((e) => RefillRequestItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class RefillDepartment {
  final String id;
  final String name;
  final String type;

  RefillDepartment({required this.id, required this.name, required this.type});

  factory RefillDepartment.fromJson(Map<String, dynamic> json) {
    return RefillDepartment(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }
}

class RefillRequestedBy {
  final String id;
  final String fullName;

  RefillRequestedBy({required this.id, required this.fullName});

  factory RefillRequestedBy.fromJson(Map<String, dynamic> json) {
    return RefillRequestedBy(
      id: json['id']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }
}

class RefillRequestItem {
  final String id;
  final String variantId;
  final int requestedQuantity;
  final int? approvedQuantity;
  final int? deliveredQuantity;
  final RefillVariant? variant;

  RefillRequestItem({
    required this.id,
    required this.variantId,
    required this.requestedQuantity,
    this.approvedQuantity,
    this.deliveredQuantity,
    this.variant,
  });

  factory RefillRequestItem.fromJson(Map<String, dynamic> json) {
    return RefillRequestItem(
      id: json['id']?.toString() ?? '',
      variantId: json['variantId']?.toString() ?? '',
      requestedQuantity:
          int.tryParse(json['requestedQuantity']?.toString() ?? '') ?? 0,
      approvedQuantity: json['approvedQuantity'] != null
          ? int.tryParse(json['approvedQuantity'].toString())
          : null,
      deliveredQuantity: json['deliveredQuantity'] != null
          ? int.tryParse(json['deliveredQuantity'].toString())
          : null,
      variant:
          json['variant'] is Map ? RefillVariant.fromJson(json['variant']) : null,
    );
  }
}

class RefillVariant {
  final String id;
  final String variantName;
  final String sku;

  RefillVariant({required this.id, required this.variantName, required this.sku});

  factory RefillVariant.fromJson(Map<String, dynamic> json) {
    return RefillVariant(
      id: json['id']?.toString() ?? '',
      variantName: json['variantName']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
    );
  }
}