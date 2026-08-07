// // ignore_for_file: file_names

// /// ─────────────────────────────────────────────────────────────
// /// مودل قائمة الطلبات — List Refill Requests
// /// GET /department-refills/requests
// /// ─────────────────────────────────────────────────────────────

// // ─── Enums الخاصة بالطلبات ───────────────────────────────────────

// enum OrderStatus {
//   draft,
//   pending_hospital_approval,
//   pending_manager_approval,
//   hospital_rejected,
//   manager_rejected,
//   preparing,
//   complete,
//   partially_complete,
//   cancelled,
// }

// enum OrderPriority {
//   normal,
//   urgent,
// }

// enum RecurringInterval {
//   daily,
//   weekly,
//   monthly,
// }

// // ─── مودل البيانات الرئيسية ────────────────────────────────────────

// class RefillRequestsPageData {
//   final List<OrdertItem> items;
//   final int total;
//   final int page;
//   final int limit;
//   final int totalPages;

//   const RefillRequestsPageData({
//     required this.items,
//     required this.total,
//     required this.page,
//     required this.limit,
//     required this.totalPages,
//   });

//   factory RefillRequestsPageData.fromJson(Map<String, dynamic> json) {
//     return RefillRequestsPageData(
//       items: (json['items'] as List<dynamic>? ?? [])
//           .map((e) => OrdertItem.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       total: json['total'] as int? ?? 0,
//       page: json['page'] as int? ?? 1,
//       limit: json['limit'] as int? ?? 20,
//       totalPages: json['totalPages'] as int? ?? 1,
//     );
//   }
// }

// // ─── مودل الطلب الواحد ─────────────────────────────────────────────

// class OrdertItem {
//   final String id;
//   final String requestNumber;
//   final String departmentId;
//   final DepartmentInfo? department;

//   // ✅ Enums بدل Strings
//   final OrderStatus status;
//   final OrderPriority priority;
//   final String requestType;
//   final RecurringInterval? recurringInterval;

//   final String? periodicScheduleId;
//   final DateTime createdAt;

//   const OrdertItem({
//     required this.id,
//     required this.requestNumber,
//     required this.departmentId,
//     this.department,
//     required this.status,
//     required this.priority,
//     required this.requestType,
//     this.recurringInterval,
//     this.periodicScheduleId,
//     required this.createdAt,
//   });

//   factory OrdertItem.fromJson(Map<String, dynamic> json) {
//     final statusStr = json['status'] as String? ?? 'draft';
//     final priorityStr = json['priority'] as String? ?? 'normal';
//     final requestTypeStr = json['requestType'] as String? ?? 'normal';

//     return OrdertItem(
//       id: json['id'] as String? ?? '',
//       requestNumber: json['requestNumber'] as String? ?? '',
//       departmentId: json['departmentId'] as String? ?? '',
//       department: json['department'] != null
//           ? DepartmentInfo.fromJson(json['department'] as Map<String, dynamic>)
//           : null,
//       status: _parseOrderStatus(statusStr),
//       priority: _parseOrderPriority(priorityStr),
//       requestType: requestTypeStr,
//       recurringInterval: _parseRecurringInterval(requestTypeStr),
//       periodicScheduleId: json['periodicScheduleId'] as String?,
//       createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
//           DateTime.now(),
//     );
//   }

//   // ─── دوال التحويل الآمنة من String إلى Enum ────────────────────

//   static OrderStatus _parseOrderStatus(String value) {
//     switch (value) {
//       case 'draft':
//         return OrderStatus.draft;
//       case 'pending_hospital_approval':
//         return OrderStatus.pending_hospital_approval;
//       case 'pending_manager_approval':
//         return OrderStatus.pending_manager_approval;
//       case 'hospital_rejected':
//         return OrderStatus.hospital_rejected;
//       case 'manager_rejected':
//         return OrderStatus.manager_rejected;
//       case 'preparing':
//         return OrderStatus.preparing;
//       case 'complete':
//         return OrderStatus.complete;
//       case 'partially_complete':
//         return OrderStatus.partially_complete;
//       case 'cancelled':
//         return OrderStatus.cancelled;
//       default:
//         return OrderStatus.draft;
//     }
//   }

//   static OrderPriority _parseOrderPriority(String value) {
//     switch (value) {
//       case 'urgent':
//         return OrderPriority.urgent;
//       case 'normal':
//       default:
//         return OrderPriority.normal;
//     }
//   }

//   static RecurringInterval? _parseRecurringInterval(String value) {
//     switch (value) {
//       case 'daily':
//         return RecurringInterval.daily;
//       case 'weekly':
//         return RecurringInterval.weekly;
//       case 'monthly':
//         return RecurringInterval.monthly;
//       default:
//         return null;
//     }
//   }

//   // ─── تسميات عربية للعرض في الواجهة (مجمّعة حسب الفلتر) ─────────

//   String get statusLabel {
//     switch (status) {
//       case OrderStatus.draft:
//       case OrderStatus.pending_hospital_approval:
//         return 'معلق';
//       case OrderStatus.pending_manager_approval:
//       case OrderStatus.preparing:
//         return 'قيد التنفيذ';
//       case OrderStatus.hospital_rejected:
//       case OrderStatus.manager_rejected:
//       case OrderStatus.cancelled:
//         return 'مرفوض';
//       case OrderStatus.partially_complete:
//         return 'منجز';
//       case OrderStatus.complete:
//         return 'مستلم';
//     }
//   }

//   String get priorityLabel => priority == OrderPriority.urgent ? 'ضروري' : 'عادي';

//   String get requestTypeLabel {
//     switch (requestType) {
//       case 'daily':
//         return 'يومي';
//       case 'weekly':
//         return 'أسبوعي';
//       case 'monthly':
//         return 'شهري';
//       default:
//         return 'عادي';
//     }
//   }

//   // ─── تنسيق التاريخ ─────────────────────────────────────────────
//   String get formattedCreatedAt {
//     final d = createdAt.toLocal();
//     String two(int v) => v.toString().padLeft(2, '0');
//     return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
//   }

//   /// هل الطلب دوري؟
//   bool get isRecurring => recurringInterval != null;
// }

// // ─── مودل معلومات القسم ────────────────────────────────────────────

// class DepartmentInfo {
//   final String id;
//   final String name;

//   const DepartmentInfo({required this.id, required this.name});

//   factory DepartmentInfo.fromJson(Map<String, dynamic> json) {
//     return DepartmentInfo(
//       id: json['id'] as String? ?? '',
//       name: json['name'] as String? ?? '',
//     );
//   }
// }

// ignore_for_file: file_names

/// ─────────────────────────────────────────────────────────────
/// Enums الخاصة بالطلبات
/// ─────────────────────────────────────────────────────────────

enum OrderStatus {
  draft,
  pending_hospital_approval,
  pending_manager_approval,
  hospital_rejected,
  manager_rejected,
  preparing,
  complete,
  partially_complete,
  cancelled;

  /// تحويل من نص الـ API إلى enum
  static OrderStatus fromString(String value) {
    return OrderStatus.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => OrderStatus.draft,
    );
  }
}

enum OrderPriority {
  normal,
  urgent;

  /// تحويل من نص الـ API إلى enum
  static OrderPriority fromString(String value) {
    return OrderPriority.values.firstWhere(
      (e) => e.name == value.toLowerCase(),
      orElse: () => OrderPriority.normal,
    );
  }
}

enum RecurringInterval {
  daily,
  weekly,
  monthly;

  /// يُرجع null إذا لم يكن النوع دورياً (normal)
  static RecurringInterval? fromString(String value) {
    final v = value.toLowerCase();
    for (final e in RecurringInterval.values) {
      if (e.name == v) return e;
    }
    return null;
  }
}

/// ─────────────────────────────────────────────────────────────
/// مودل قائمة الطلبات — List Refill Requests
/// GET /department-refills/requests
/// ─────────────────────────────────────────────────────────────

class RefillRequestsPageData {
  final List<OrdertItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const RefillRequestsPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory RefillRequestsPageData.fromJson(Map<String, dynamic> json) {
    return RefillRequestsPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrdertItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

// ─── مودل الطلب الواحد ─────────────────────────────────────────────

class OrdertItem {
  final String id;
  final String requestNumber;
  final String departmentId;
  final DepartmentInfo? department;

  // ✅ Enums بدل Strings
  final OrderStatus status;
  final OrderPriority priority;
  final String requestType;
  final RecurringInterval? recurringInterval;

  final String? periodicScheduleId;
  final DateTime createdAt;

  const OrdertItem({
    required this.id,
    required this.requestNumber,
    required this.departmentId,
    this.department,
    required this.status,
    required this.priority,
    required this.requestType,
    this.recurringInterval,
    this.periodicScheduleId,
    required this.createdAt,
  });

  factory OrdertItem.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'draft';
    final priorityStr = json['priority'] as String? ?? 'normal';
    final requestTypeStr = json['requestType'] as String? ?? 'normal';

    return OrdertItem(
      id: json['id'] as String? ?? '',
      requestNumber: json['requestNumber'] as String? ?? '',
      departmentId: json['departmentId'] as String? ?? '',
      department: json['department'] != null
          ? DepartmentInfo.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      // ✅ استخدام fromString مباشرة من الـ enums
      status: OrderStatus.fromString(statusStr),
      priority: OrderPriority.fromString(priorityStr),
      requestType: requestTypeStr,
      recurringInterval: RecurringInterval.fromString(requestTypeStr),
      periodicScheduleId: json['periodicScheduleId'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  // ─── تسميات عربية للعرض في الواجهة (مجمّعة حسب الفلتر) ─────────

  String get statusLabel {
    switch (status) {
      case OrderStatus.draft:
      case OrderStatus.pending_hospital_approval:
        return 'معلق';
      case OrderStatus.pending_manager_approval:
      case OrderStatus.preparing:
        return 'قيد التنفيذ';
      case OrderStatus.hospital_rejected:
      case OrderStatus.manager_rejected:
      case OrderStatus.cancelled:
        return 'مرفوض';
      case OrderStatus.partially_complete:
        return 'منجز';
      case OrderStatus.complete:
        return 'مستلم';
    }
  }

  String get priorityLabel =>
      priority == OrderPriority.urgent ? 'ضروري' : 'عادي';

  String get requestTypeLabel {
    switch (requestType) {
      case 'daily':
        return 'يومي';
      case 'weekly':
        return 'أسبوعي';
      case 'monthly':
        return 'شهري';
      default:
        return 'عادي';
    }
  }

  // ─── تنسيق التاريخ ─────────────────────────────────────────────
  String get formattedCreatedAt {
    final d = createdAt.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }

  /// هل الطلب دوري؟
  bool get isRecurring => recurringInterval != null;
}

// ─── مودل معلومات القسم ────────────────────────────────────────────

class DepartmentInfo {
  final String id;
  final String name;

  const DepartmentInfo({required this.id, required this.name});

  factory DepartmentInfo.fromJson(Map<String, dynamic> json) {
    return DepartmentInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}