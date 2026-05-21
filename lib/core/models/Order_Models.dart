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
  ),

  // طلب عادي – قيد التنفيذ
  Order(
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.inProgress,
    priority: OrderPriority.urgent,
  ),

  // طلب عادي – معلق
  Order(
    medicineName: 'ميترونيدازول 500 mg',
    date: '2025-03-22',
    quantity: 100,
    status: OrderStatus.suspended,
    priority: OrderPriority.normal,
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
