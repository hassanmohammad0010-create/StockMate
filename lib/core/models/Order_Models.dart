// ignore_for_file: file_names

enum OrderStatus { completed, rejected, inProgress, suspended }

enum OrderPriority { normal, urgent }

enum RecurringInterval { daily, weekly, monthly }

class Order {
  final String medicineName;
  final String date;
  final int quantity;
  final OrderStatus status;
  final String rejectionReason;

  final OrderPriority priority;
  final String type;
  final String vendor;

  final bool isRecurring;
  final RecurringInterval? recurringInterval;

  const Order({
    required this.medicineName,
    required this.date,
    required this.quantity,
    required this.status,
    this.rejectionReason = '',
    this.priority = OrderPriority.normal,
    this.type = 'اعتيادي',
    this.vendor = '---',
    this.isRecurring = false,
    this.recurringInterval,
  });
}

// ============================================================
//  بيانات تجريبية
// ============================================================

final List<Order> allOrders = [
  // طلب عادي – منجز
  Order(
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.completed,
    priority: OrderPriority.normal,
    vendor: 'فارما',
    type: 'عادي',
  ),

  // طلب عادي – مرفوض
  Order(
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.rejected,
    priority: OrderPriority.urgent,
    rejectionReason:
        'الكمية المطلوبة تتجاوز الحد الأقصى المتاح في المستودع حالياً. الرجاء تقليل الكمية أو إعادة الطلب لاحقاً.',
    type: 'عادي',
  ),

  // طلب عادي – قيد التنفيذ
  Order(
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.inProgress,
    priority: OrderPriority.urgent,
    type: 'عادي',
  ),

  // طلب عادي – معلق
  Order(
    medicineName: 'ميترونيدازول 500 mg',
    date: '2025-03-22',
    quantity: 100,
    status: OrderStatus.suspended,
    priority: OrderPriority.normal,
    type: 'عادي',
  ),

  // طلب دوري – يومي – منجز
  Order(
    medicineName: 'أقنعة وجه',
    date: '1/1/2026',
    quantity: 100,
    status: OrderStatus.inProgress,
    isRecurring: true,
    recurringInterval: RecurringInterval.daily,
    vendor: 'فارما',
    type: 'دوري',
  ),

  // طلب دوري – أسبوعي – منجز
  Order(
    medicineName: 'أقنعة وجه',
    date: '1/1/2026',
    quantity: 100,
    status: OrderStatus.rejected,
    isRecurring: true,
    recurringInterval: RecurringInterval.weekly,
    vendor: 'فارما',
    type: 'دوري',
    rejectionReason:
        'الكمية المطلوبة تتجاوز الحد الأقصى المتاح في المستودع حالياً. الرجاء تقليل الكمية أو إعادة الطلب لاحقاً.',
  ),

  // طلب دوري – شهري – منجز
  Order(
    medicineName: 'أقنعة وجه',
    date: '1/1/2026',
    quantity: 100,
    status: OrderStatus.completed,
    isRecurring: true,
    recurringInterval: RecurringInterval.monthly,
    vendor: 'فارما',
    type: 'دوري',
  ),
];

String recurringIntervalLabel(RecurringInterval interval) {
  switch (interval) {
    case RecurringInterval.daily:
      return 'يومي';
    case RecurringInterval.weekly:
      return 'أسبوعي';
    case RecurringInterval.monthly:
      return 'شهري';
  }
}

// class OrderModel {
//   String? medicineName; // dropdown — اسم الدواء
//   String  quantity;     // text field
//   String? unit;         // dropdown — الوحدة
//   String? brand;        // dropdown — الوكيل / الماركة
//   String  priority;     // 'عادي' | 'ضروري'

//   OrderModel({
//     this.medicineName,
//     this.quantity = '',
//     this.unit,
//     this.brand,
//     this.priority = 'عادي',
//   });

//   OrderModel copyWith({
//     String? medicineName,
//     String? quantity,
//     String? unit,
//     String? brand,
//     String? priority,
//   }) {
//     return OrderModel(
//       medicineName: medicineName ?? this.medicineName,
//       quantity:     quantity     ?? this.quantity,
//       unit:         unit         ?? this.unit,
//       brand:        brand        ?? this.brand,
//       priority:     priority     ?? this.priority,
//     );
//   }

//   // الطلب صالح إذا تم اختيار المادة والوحدة والوكيل وإدخال الكمية
//   bool get isValid =>
//       (medicineName?.trim().isNotEmpty ?? false) &&
//       quantity.trim().isNotEmpty &&
//       (unit?.trim().isNotEmpty ?? false) &&
//       (brand?.trim().isNotEmpty ?? false);

//   Map<String, dynamic> toJson() => {
//         'medicineName': medicineName,
//         'quantity':     quantity,
//         'unit':         unit,
//         'brand':        brand,
//         'priority':     priority,
//       };

//   @override
//   String toString() =>
//       'OrderModel(medicine: $medicineName, qty: $quantity, unit: $unit, priority: $priority)';
// }


// Sentinel — قيمة وهمية تعني "امسح هذا الحقل واجعله null"
// لا يمكن استخدام null مباشرة في copyWith لأن
// null ?? oldValue يرجع oldValue دائماً
const _clear = Object();

class OrderModel {
  String? medicineName;
  String  quantity;
  String? unit;
  String? brand;
  String  priority;

  OrderModel({
    this.medicineName,
    this.quantity = '',
    this.unit,
    this.brand,
    this.priority = 'عادي',
  });

  /// لتمرير null صراحةً استخدم الثابت [clearField]:
  ///   model.copyWith(medicineName: clearField)
  OrderModel copyWith({
    Object? medicineName = _clear,
    Object? quantity     = _clear,
    Object? unit         = _clear,
    Object? brand        = _clear,
    Object? priority     = _clear,
  }) {
    return OrderModel(
      medicineName: identical(medicineName, _clear)
          ? this.medicineName
          : medicineName as String?,
      quantity: identical(quantity, _clear)
          ? this.quantity
          : (quantity as String? ?? ''),
      unit: identical(unit, _clear)
          ? this.unit
          : unit as String?,
      brand: identical(brand, _clear)
          ? this.brand
          : brand as String?,
      priority: identical(priority, _clear)
          ? this.priority
          : (priority as String? ?? 'عادي'),
    );
  }

  bool get isValid =>
      (medicineName?.trim().isNotEmpty ?? false) &&
      quantity.trim().isNotEmpty &&
      (unit?.trim().isNotEmpty ?? false) &&
      (brand?.trim().isNotEmpty ?? false);

  Map<String, dynamic> toJson() => {
        'medicineName': medicineName,
        'quantity':     quantity,
        'unit':         unit,
        'brand':        brand,
        'priority':     priority,
      };

  @override
  String toString() =>
      'OrderModel(medicine: $medicineName, qty: $quantity, unit: $unit, priority: $priority)';
}