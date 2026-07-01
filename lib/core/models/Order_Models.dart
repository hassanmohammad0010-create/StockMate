// ignore_for_file: file_names

enum OrderStatus { completed, rejected, inProgress, suspended, reserved }

enum OrderPriority { normal, urgent }

enum RecurringInterval { daily, weekly, monthly }

const _clearOrder = Object();

class Order {
  final String? id;
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
  final bool receivedConfirmed;
  final int? receivedQuantity;

  const Order({
    this.id,
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
    this.receivedConfirmed = false,
    this.receivedQuantity,
  });

  Order copyWith({
    Object? medicineName = _clearOrder,
    Object? date = _clearOrder,
    Object? quantity = _clearOrder,
    Object? status = _clearOrder,
    Object? rejectionReason = _clearOrder,
    Object? priority = _clearOrder,
    Object? type = _clearOrder,
    Object? vendor = _clearOrder,
    Object? isRecurring = _clearOrder,
    Object? recurringInterval = _clearOrder,
    Object? receivedConfirmed = _clearOrder,
    Object? receivedQuantity = _clearOrder,
  }) {
    return Order(
      id: id,
      medicineName: identical(medicineName, _clearOrder)
          ? this.medicineName
          : medicineName as String,
      date: identical(date, _clearOrder) ? this.date : date as String,
      quantity: identical(quantity, _clearOrder)
          ? this.quantity
          : quantity as int,
      status: identical(status, _clearOrder)
          ? this.status
          : status as OrderStatus,
      rejectionReason: identical(rejectionReason, _clearOrder)
          ? this.rejectionReason
          : rejectionReason as String,
      priority: identical(priority, _clearOrder)
          ? this.priority
          : priority as OrderPriority,
      type: identical(type, _clearOrder) ? this.type : type as String,
      vendor: identical(vendor, _clearOrder) ? this.vendor : vendor as String,
      isRecurring: identical(isRecurring, _clearOrder)
          ? this.isRecurring
          : isRecurring as bool,
      recurringInterval: identical(recurringInterval, _clearOrder)
          ? this.recurringInterval
          : recurringInterval as RecurringInterval?,
      receivedConfirmed: identical(receivedConfirmed, _clearOrder)
          ? this.receivedConfirmed
          : receivedConfirmed as bool,
      receivedQuantity: identical(receivedQuantity, _clearOrder)
          ? this.receivedQuantity
          : receivedQuantity as int?,
    );
  }
}

// ============================================================
//  بيانات تجريبية
// ============================================================

final List<Order> allOrders = [
  // طلب عادي – منجز
  Order(
    id: 'o1',
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.completed,
    priority: OrderPriority.normal,
    vendor: 'فارما',
    type: 'اعتيادي',
  ),

  Order(
    id: 'o2',
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.completed,
    priority: OrderPriority.normal,
    vendor: 'فارما',
    type: 'اعتيادي',
  ),
  Order(
    id: 'o3',
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.suspended,
    priority: OrderPriority.normal,
    vendor: 'فارما',
    type: 'اعتيادي',
  ),

  // طلب عادي – مرفوض
  Order(
    id: 'o4',
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.rejected,
    priority: OrderPriority.urgent,
    rejectionReason:
        'الكمية المطلوبة تتجاوز الحد الأقصى المتاح في المستودع حالياً. الرجاء تقليل الكمية أو إعادة الطلب لاحقاً.',
    type: 'اعتيادي',
  ),

  Order(
    id: 'o5',
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.rejected,
    priority: OrderPriority.urgent,
    type: 'اعتيادي',
  ),

  // طلب عادي – قيد التنفيذ
  Order(
    id: 'o6',
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.inProgress,
    priority: OrderPriority.urgent,
    type: 'اعتيادي',
  ),

  // طلب دوري – يومي – منجز
  Order(
    id: 'o7',
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
    id: 'o8',
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
    id: 'o9',
    medicineName: 'أقنعة وجه',
    date: '1/1/2026',
    quantity: 100,
    status: OrderStatus.completed,
    isRecurring: true,
    recurringInterval: RecurringInterval.monthly,
    vendor: 'فارما',
    type: 'اعتيادي',
  ),
   Order(
    id: 'o10',
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 1000,
    status: OrderStatus.completed,
    priority: OrderPriority.normal,
    vendor: 'فارما',
    type: 'اعتيادي',
  ),
   Order(
    id: 'o11',
    medicineName: 'فلاك-م',
    date: '2025-03-19',
    quantity: 600,
    status: OrderStatus.completed,
    priority: OrderPriority.normal,
    vendor: 'فارما',
    type: 'اعتيادي',
  ),
   Order(
    id: 'o12',
    medicineName: 'سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 500,
    status: OrderStatus.completed,
    priority: OrderPriority.normal,
    vendor: 'فارما',
    type: 'اعتيادي',
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

const _clear = Object();

class OrderModel {
  String? medicineName;
  String quantity;
  String? unit;
  String? brand;
  String priority;

  OrderModel({
    this.medicineName,
    this.quantity = '',
    this.unit,
    this.brand,
    this.priority = 'عادي',
  });

  OrderModel copyWith({
    Object? medicineName = _clear,
    Object? quantity = _clear,
    Object? unit = _clear,
    Object? brand = _clear,
    Object? priority = _clear,
  }) {
    return OrderModel(
      medicineName: identical(medicineName, _clear)
          ? this.medicineName
          : medicineName as String?,
      quantity: identical(quantity, _clear)
          ? this.quantity
          : (quantity as String? ?? ''),
      unit: identical(unit, _clear) ? this.unit : unit as String?,
      brand: identical(brand, _clear) ? this.brand : brand as String?,
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
    'quantity': quantity,
    'unit': unit,
    'brand': brand,
    'priority': priority,
  };

  @override
  String toString() =>
      'OrderModel(medicine: $medicineName, qty: $quantity, unit: $unit, priority: $priority)';
}
