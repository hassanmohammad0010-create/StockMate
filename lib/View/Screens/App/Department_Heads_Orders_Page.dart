// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class DepartmentOrdersPage extends StatelessWidget {
  const DepartmentOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stock Mate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Cairo', // استخدم خط Cairo لدعم العربية
      ),
      home: const OrdersPage(),
    );
  }
}

// ==================== نماذج البيانات ====================

enum OrderStatus { completed, rejected, inProgress, suspended }

enum OrderPriority { normal, urgent }

class Order {
  final String medicineName;
  final String date;
  final int quantity;
  final OrderStatus status;
  final OrderPriority priority;
  final bool isRecurring;

  const Order({
    required this.medicineName,
    required this.date,
    required this.quantity,
    required this.status,
    required this.priority,
    this.isRecurring = false,
  });
}

// ==================== بيانات تجريبية ====================

final List<Order> allOrders = [
  Order(
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.completed,
    priority: OrderPriority.normal,
  ),
  Order(
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.rejected,
    priority: OrderPriority.urgent,
  ),
  Order(
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.inProgress,
    priority: OrderPriority.normal,
  ),
  Order(
    medicineName: 'بارا سيتامول 500 mg',
    date: '2025-03-19',
    quantity: 300,
    status: OrderStatus.inProgress,
    priority: OrderPriority.urgent,
  ),
  Order(
    medicineName: 'أموكسيسيلين 250 mg',
    date: '2025-03-20',
    quantity: 150,
    status: OrderStatus.rejected,
    priority: OrderPriority.urgent,
  ),
  Order(
    medicineName: 'إيبوبروفين 400 mg',
    date: '2025-03-21',
    quantity: 200,
    status: OrderStatus.completed,
    priority: OrderPriority.normal,
  ),
  Order(
    medicineName: 'ميترونيدازول 500 mg',
    date: '2025-03-22',
    quantity: 100,
    status: OrderStatus.suspended,
    priority: OrderPriority.normal,
  ),
  Order(
    medicineName: 'سيفترياكسون 1g',
    date: '2025-03-23',
    quantity: 50,
    status: OrderStatus.rejected,
    priority: OrderPriority.urgent,
  ),
];

// ==================== الصفحة الرئيسية ====================

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // فلتر التصنيف المحدد
  String _selectedFilter = 'الكل';

  // قائمة الفلاتر
  final List<String> _filters = [
    'الكل',
    'الطلبات الدورية',
    'معلق',
    'قيد التنفيذ',
    'منجز',
    'مرفوضة',
  ];


  List<Order> get _filteredOrders {
    switch (_selectedFilter) {
      case 'الكل':
        return allOrders;
      case 'الطلبات الدورية':
        return allOrders.where((o) => o.isRecurring).toList();
      case 'معلق':
        return allOrders
            .where((o) => o.status == OrderStatus.suspended)
            .toList();
      case 'قيد التنفيذ':
        return allOrders
            .where((o) => o.status == OrderStatus.inProgress)
            .toList();
      case 'منجز':
        return allOrders
            .where((o) => o.status == OrderStatus.completed)
            .toList();
      case 'مرفوضة':
        return allOrders
            .where((o) => o.status == OrderStatus.rejected)
            .toList();
      default:
        return allOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Color(0xFFF4F6FA),
        body: Column(
          children: [
            // ── شريط الفلاتر ──
            _buildFilterBar(),

            // ── قائمة الطلبات ──
            Expanded(
              child: _filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        return _OrderCard(order: _filteredOrders[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== شريط الفلاتر ====================
  Widget _buildFilterBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _FilterChip(
                label: filter,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ==================== حالة القائمة الفارغة ====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'لا توجد طلبات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== شريحة الفلتر ====================

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? constDarkBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? constDarkBlue
                : const Color(0xFFDDE2EE),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }
}

// ==================== بطاقة الطلب ====================

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── المحتوى النصي ──
            Expanded(
              child: Column(
                children: [
                  // اسم الدواء
                  Text(
                    order.medicineName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: constColor,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 6),

                  // التاريخ
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: Text(
                      '         باطنية   ${order.date}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // الكمية والأولوية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // _PriorityBadge(priority: order.priority),
                      // const SizedBox(width: 8),
                      Text(
                        'الكمية : ${order.quantity} وحدة',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4B5563),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _PriorityBadge(priority: order.priority),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 95),

            // ── شارة الحالة ──
            _StatusBadge(status: order.status),
          ],
        ),
      ),
    );
  }
}

// ==================== شارة الحالة ====================

class _StatusBadge extends StatelessWidget {
  final OrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    late String label;
    late Color bgColor;
    late Color textColor;

    switch (status) {
      case OrderStatus.completed:
        label = 'تم الإنجاز';
        bgColor = const Color(0xFFE3FDED);
        textColor = const Color(0xFF09C05E);
        break;
      case OrderStatus.rejected:
        label = 'مرفوضة';
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFE53935);
        break;
      case OrderStatus.inProgress:
        label = 'قيد التنفيذ';
        bgColor = const Color(0xFFE3F2FD);
        textColor =  constDarkBlue;
        break;
      case OrderStatus.suspended:
        label = 'معلق';
        bgColor = const Color(0xFFFFF8E2);
        textColor = const Color(0xFFFFBF00);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

// ==================== شارة الأولوية ====================

class _PriorityBadge extends StatelessWidget {
  final OrderPriority priority;

  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final isUrgent = priority == OrderPriority.urgent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFE53935) : constDarkBlue,
        // isUrgent ? const Color(0xFFFFEBEE) : const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isUrgent ? 'ضروري' : 'عادي',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          // isUrgent ? const Color(0xFFE53935) : constDarkBlue,
        ),
      ),
    );
  }
}
