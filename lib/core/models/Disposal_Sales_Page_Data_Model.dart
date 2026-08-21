// lib/core/models/Disposal_Sale_Model.dart
// ignore_for_file: file_names, duplicate_ignore

// lib/core/models/Disposal_Sale_Request_Status.dart
// ignore_for_file: file_names

enum DisposalSaleRequestStatus {
  pendingApproval,
  awaitingConfirmation,
  rejected,
  completed,
  cancelled;

  /// الباك اند يرسل snake_case: "pending_approval"
  static DisposalSaleRequestStatus fromString(String value) {
    final normalized = value.toLowerCase().replaceAll('_', '');
    return DisposalSaleRequestStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == normalized,
      orElse: () => DisposalSaleRequestStatus.pendingApproval,
    );
  }

  String get displayName => switch (this) {
    DisposalSaleRequestStatus.pendingApproval => 'بانتظار الموافقة',
    DisposalSaleRequestStatus.awaitingConfirmation => 'بانتظار التأكيد',
    DisposalSaleRequestStatus.rejected => 'مرفوض',
    DisposalSaleRequestStatus.completed => 'منجز',
    DisposalSaleRequestStatus.cancelled => 'ملغي',
  };
}

class DisposalSalesPageData {
  final List<DisposalSaleListItem> items;
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const DisposalSalesPageData({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory DisposalSalesPageData.fromJson(Map<String, dynamic> json) {
    return DisposalSalesPageData(
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => DisposalSaleListItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

class DisposalSaleListItem {
  final String id;
  final DisposalSaleRequestStatus status; // ✅ صار enum بدل String خام
  final DateTime createdAt;
  final DisposalDestination? destination;

  const DisposalSaleListItem({
    required this.id,
    required this.status,
    required this.createdAt,
    this.destination,
  });

  factory DisposalSaleListItem.fromJson(Map<String, dynamic> json) {
    return DisposalSaleListItem(
      id: json['id']?.toString() ?? '',
      status: DisposalSaleRequestStatus.fromString(
        json['status']?.toString() ?? 'pending_approval',
      ),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
      destination: json['destination'] is Map
          ? DisposalDestination.fromJson(
              json['destination'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  // ← بدل ما كان switch يدوي على String، هلق بيفوّض مباشرة لـ enum.displayName
  String get statusLabel => status.displayName;

  String get formattedCreatedAt {
    final d = createdAt.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} • ${two(d.hour)}:${two(d.minute)}';
  }
}

class DisposalDestination {
  final String id;
  final String name;
  final String? phone;
  final String? email;

  const DisposalDestination({
    required this.id,
    required this.name,
    this.phone,
    this.email,
  });

  factory DisposalDestination.fromJson(Map<String, dynamic> json) {
    return DisposalDestination(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
    );
  }
}
