// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Consumption_Item_Input.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Cart_Item_Model.dart';
import 'package:stock_mate_project/core/models/New_MaterialItem.dart'; // ✅✅✅ الموديل الموحد

class CartController extends GetxController {
  static CartController get to => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  static const String _cartKey = 'cart_items';

  final RxList<CartItem> cartItems = <CartItem>[].obs;

  int _nextId = 1;

  // ─── تأكيد السلة (الاستهلاك) ─────────────────────────────
  final RecordConsumptionService _consumptionService =
      RecordConsumptionService();

  /// حقل الملاحظات الاختياري
  final TextEditingController notesController = TextEditingController();

  /// حالة الإرسال
  final RxBool isConfirming = false.obs;

  // ─── Lifecycle ────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _loadCart();
  }

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  // ─── Persistence ──────────────────────────────────────────────
  Future<void> _loadCart() async {
    final cartJson = await _secureStorage.read(key: _cartKey);
    if (cartJson != null) {
      try {
        final List<dynamic> cartList = jsonDecode(cartJson);
        for (final itemJson in cartList) {
          final cartItem = CartItem.fromJson(itemJson as Map<String, dynamic>);
          cartItems.add(cartItem);
          final n = int.tryParse(cartItem.id.replaceAll('CART-', '')) ?? 0;
          if (n >= _nextId) _nextId = n + 1;
        }
      } catch (_) {}
    }
  }

  Future<void> _saveCart() async {
    await _secureStorage.write(
      key: _cartKey,
      value: jsonEncode(cartItems.map((i) => i.toJson()).toList()),
    );
  }

  // ─── ✅ إضافة عنصر للسلة (متوافق مع LiveStock) ─────────────────
  String? addToCart(MaterialItem item, int quantity) {
    if (quantity <= 0) return 'الكمية يجب أن تكون أكبر من صفر';

    final available = item.batches
        .where((b) => b.status != BatchStatus.expired)
        .fold(0, (sum, b) => sum + b.quantity);

    if (quantity > available) {
      return 'الكمية المتوفرة غير كافية (المتوفر: $available)';
    }

    // ✅ ترتيب الدفعات حسب تاريخ الانتهاء (الأقرب انتهاءً أولاً — FIFO)
    final sortedBatches = item.batches
        .where((b) => b.status != BatchStatus.expired)
        .toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    int remaining = quantity;
    final List<BatchDeduction> deductions = [];

    for (final batch in sortedBatches) {
      if (remaining <= 0) break;
      final taken = remaining < batch.quantity ? remaining : batch.quantity;

      deductions.add(BatchDeduction(
        batchId: batch.batchId, // ✅✅✅ batchId وليس id
        quantity: taken,
        expiryDate: batch.expiryDate,
      ));

      remaining -= taken;
    }

    // ✅ تحقق: هل المادة موجودة أصلاً في السلة؟ → ادمج الكميات
    final existingIndex =
        cartItems.indexWhere((c) => c.materialId == item.variantId);
    if (existingIndex != -1) {
      final existing = cartItems[existingIndex];
      cartItems[existingIndex] = CartItem(
        id: existing.id,
        materialId: existing.materialId,
        materialName: existing.materialName,
        quantity: existing.quantity + quantity,
        deductions: [...existing.deductions, ...deductions],
      );
    } else {
      cartItems.add(CartItem(
        id: 'CART-$_nextId',
        materialId: item.variantId, // ✅✅✅ variantId
        materialName: item.name,   // ✅✅✅ يستخدم الـ getter (product?.name ?? variantName)
        quantity: quantity,
        deductions: deductions,
      ));
      _nextId++;
    }

    _saveCart();
    return null;
  }

  // ─── إرجاع للمخزون (من صفحة السلة) ─────────────────────────
  void returnToStock(CartItem cartItem, int returnQuantity) {
    final actualReturn = returnQuantity.clamp(0, cartItem.quantity);
    if (actualReturn <= 0) return;

    int remaining = actualReturn;

    // عكس عملية الاقتطاع من آخر deduction
    for (int i = cartItem.deductions.length - 1; i >= 0 && remaining > 0; i--) {
      final deduction = cartItem.deductions[i];
      final restoreQty =
          remaining < deduction.quantity ? remaining : deduction.quantity;

      if (restoreQty == deduction.quantity) {
        cartItem.deductions.removeAt(i);
      } else {
        cartItem.deductions[i] = BatchDeduction(
          batchId: deduction.batchId,
          quantity: deduction.quantity - restoreQty,
          expiryDate: deduction.expiryDate,
        );
      }
      remaining -= restoreQty;
    }

    cartItem.quantity -= actualReturn;
    if (cartItem.quantity <= 0) {
      cartItems.remove(cartItem);
    } else {
      cartItems.refresh();
    }

    _saveCart();
  }

  // ─── تفريغ السلة (بعد التأكيد الناجح) ──────────────────────
  Future<void> clearCart() async {
    cartItems.clear();
    await _secureStorage.delete(key: _cartKey);
  }

  // ─── ترجمة رسائل الخطأ ─────────────────────────────────────
  String _translateError(String? msg) {
    if (msg == null || msg.isEmpty) {
      return 'تعذر تأكيد السلة، حاول مرة أخرى';
    }
    if (msg.contains('Insufficient')) {
      return 'المخزون غير كافٍ لتسجيل هذه الكمية';
    }
    return msg;
  }

  // ─── ✅ تأكيد السلة اليومية → POST /inventory/consumption ────
  Future<void> confirmDailyCart() async {
    if (isConfirming.value || cartItems.isEmpty) return;

    isConfirming.value = true;
    try {
      final departmentId = Get.find<GetNameRollOfUserController>().id.value ?? '';

      // ✅✅✅ materialId في السلة = variantId المطلوب في الإند بوينت
      final items = cartItems
          .map(
            (item) => ConsumptionItemInput(
              variantId: item.materialId,
              quantity: item.quantity,
            ),
          )
          .toList();

      final success = await _consumptionService.recordConsumption(
        departmentId: departmentId,
        items: items,
        notes: notesController.text.trim(),
      );

      if (success) {
        customSnackBar(
          title: 'تم التأكيد',
          message: 'تم تأكيد السلة اليومية وتسجيل الاستهلاك بنجاح',
          color: constGreen,
          messageColor: Colors.white,
        );

        notesController.clear();
        await clearCart();
      } else {
        customSnackBar(
          title: 'فشل التأكيد',
          message: _translateError(_consumptionService.lastError),
          color: constRed,
          messageColor: Colors.white,
        );
      }
    } finally {
      isConfirming.value = false;
    }
  }
}