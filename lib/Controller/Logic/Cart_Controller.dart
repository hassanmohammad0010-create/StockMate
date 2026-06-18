// ignore_for_file: file_names
import 'dart:convert';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Cart_Item_Model.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';
import 'package:stock_mate_project/main.dart';

class CartController extends GetxController {
  static CartController get to => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);

  static const String _cartKey = 'cart_items';
  static const String _deletedKey = 'deleted_batches';
  static const String _confirmedDeductionsKey = 'confirmed_deductions'; // ← جديد

  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxInt inventoryVersion = 0.obs;

  int _nextId = 1;

  final List<Map<String, String>> _deletedBatches = [];
  final List<Map<String, dynamic>> _confirmedDeductions = []; // ← جديد

  // ─── Lifecycle ────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _loadState();
  }

  // ─── Persistence ──────────────────────────────────────────────────────────

  void _loadState() {
    // الخطوة 1: أعد تطبيق الدفعات المحذوفة (منتهية الصلاحية)
    final deletedJson = shareprefs?.getString(_deletedKey);
    if (deletedJson != null) {
      try {
        final List<dynamic> list = jsonDecode(deletedJson);
        for (final entry in list) {
          final materialId = entry['materialId'] as String;
          final batchId = entry['batchId'] as String;
          _deletedBatches.add({'materialId': materialId, 'batchId': batchId});
          for (final m in allMaterial) {
            if (m.id == materialId) {
              m.batches.removeWhere((b) => b.id == batchId);
              break;
            }
          }
        }
      } catch (_) {}
    }

    // الخطوة 2: أعد تطبيق الخصومات المؤكدة (سلات مؤكدة في أيام سابقة) ← جديد
    final confirmedJson = shareprefs?.getString(_confirmedDeductionsKey);
    if (confirmedJson != null) {
      try {
        final List<dynamic> list = jsonDecode(confirmedJson);
        for (final entry in list) {
          final materialId = entry['materialId'] as String;
          final batchId = entry['batchId'] as String;
          final quantity = entry['quantity'] as int;
          final expiryDate = entry['expiryDate'] as String;

          _confirmedDeductions.add({
            'materialId': materialId,
            'batchId': batchId,
            'quantity': quantity,
            'expiryDate': expiryDate,
          });

          for (final m in allMaterial) {
            if (m.id == materialId) {
              final idx = m.batches.indexWhere((b) => b.id == batchId);
              if (idx != -1) {
                final existing = m.batches[idx];
                final newQty = existing.quantity - quantity;
                if (newQty <= 0) {
                  m.batches.removeAt(idx);
                } else {
                  m.batches[idx] = MaterialBatch(
                    id: existing.id,
                    quantity: newQty,
                    expiryDate: existing.expiryDate,
                  );
                }
              }
              break;
            }
          }
        }
      } catch (_) {}
    }

    // الخطوة 3: أعد تطبيق خصومات السلة الحالية وأعد بناء cartItems
    final cartJson = shareprefs?.getString(_cartKey);
    if (cartJson != null) {
      try {
        final List<dynamic> cartList = jsonDecode(cartJson);
        for (final itemJson in cartList) {
          final cartItem = CartItem.fromJson(itemJson as Map<String, dynamic>);

          for (final m in allMaterial) {
            if (m.id == cartItem.materialId) {
              for (final deduction in cartItem.deductions) {
                final idx = m.batches.indexWhere((b) => b.id == deduction.batchId);
                if (idx != -1) {
                  final existing = m.batches[idx];
                  final newQty = existing.quantity - deduction.quantity;
                  if (newQty <= 0) {
                    m.batches.removeAt(idx);
                  } else {
                    m.batches[idx] = MaterialBatch(
                      id: existing.id,
                      quantity: newQty,
                      expiryDate: existing.expiryDate,
                    );
                  }
                }
              }
              break;
            }
          }

          cartItems.add(cartItem);
          final n = int.tryParse(cartItem.id.replaceAll('CART-', '')) ?? 0;
          if (n >= _nextId) _nextId = n + 1;
        }
      } catch (_) {}
    }

    if (cartItems.isNotEmpty ||
        _deletedBatches.isNotEmpty ||
        _confirmedDeductions.isNotEmpty) {
      inventoryVersion.value++;
    }
  }

  void _saveCart() {
    shareprefs?.setString(
      _cartKey,
      jsonEncode(cartItems.map((i) => i.toJson()).toList()),
    );
  }

  void _saveDeletedBatches() {
    shareprefs?.setString(_deletedKey, jsonEncode(_deletedBatches));
  }

  void _saveConfirmedDeductions() { // ← جديد
    shareprefs?.setString(
      _confirmedDeductionsKey,
      jsonEncode(_confirmedDeductions),
    );
  }

  // ─── Cart Operations ──────────────────────────────────────────────────────

  String? addToCart(MaterialItem item, int quantity) {
    if (quantity <= 0) return 'الكمية يجب ان تكون اكبر من صفر';

    final available = item.batches
        .where((b) => b.status != BatchStatus.expired)
        .fold(0, (sum, b) => sum + b.quantity);

    if (quantity > available) {
      return 'الكمية المتوفرة غير كافية (المتوفر: $available)';
    }

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
        batchId: batch.id,
        quantity: taken,
        expiryDate: batch.expiryDate,
      ));

      final idx = item.batches.indexWhere((b) => b.id == batch.id);
      final newQty = batch.quantity - taken;
      if (newQty <= 0) {
        item.batches.removeAt(idx);
      } else {
        item.batches[idx] = MaterialBatch(
          id: batch.id,
          quantity: newQty,
          expiryDate: batch.expiryDate,
        );
      }
      remaining -= taken;
    }

    cartItems.add(CartItem(
      id: 'CART-$_nextId',
      materialId: item.id,
      materialName: item.name,
      quantity: quantity,
      deductions: deductions,
    ));
    _nextId++;

    inventoryVersion.value++;
    _saveCart();
    return null;
  }

  void returnToStock(CartItem cartItem, int returnQuantity) {
    final actualReturn = returnQuantity.clamp(0, cartItem.quantity);
    if (actualReturn <= 0) return;

    MaterialItem? material;
    for (final m in allMaterial) {
      if (m.id == cartItem.materialId) {
        material = m;
        break;
      }
    }
    if (material == null) return;

    int remaining = actualReturn;
    for (int i = 0; i < cartItem.deductions.length && remaining > 0; i++) {
      final deduction = cartItem.deductions[i];
      final restoreQty =
          remaining < deduction.quantity ? remaining : deduction.quantity;

      final idx = material.batches.indexWhere((b) => b.id == deduction.batchId);
      if (idx == -1) {
        material.batches.add(MaterialBatch(
          id: deduction.batchId,
          quantity: restoreQty,
          expiryDate: deduction.expiryDate,
        ));
      } else {
        final existing = material.batches[idx];
        material.batches[idx] = MaterialBatch(
          id: existing.id,
          quantity: existing.quantity + restoreQty,
          expiryDate: existing.expiryDate,
        );
      }

      if (restoreQty == deduction.quantity) {
        cartItem.deductions.removeAt(i);
        i--;
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

    inventoryVersion.value++;
    _saveCart();
  }

  void deleteExpiredBatch(MaterialItem item, MaterialBatch batch) {
    if (batch.status != BatchStatus.expired) return;
    item.batches.removeWhere((b) => b.id == batch.id);
    _deletedBatches.add({'materialId': item.id, 'batchId': batch.id});
    _saveDeletedBatches();
    inventoryVersion.value++;
  }

  /// يفرغ السلة بعد التأكيد ويحفظ الخصومات بشكل دائم ← معدّل
void clearCart() {
  for (final cartItem in cartItems) {
    for (final deduction in cartItem.deductions) {
      _confirmedDeductions.add({
        'materialId': cartItem.materialId,
        'batchId': deduction.batchId,
        'quantity': deduction.quantity,
        'expiryDate': deduction.expiryDate.toIso8601String(),
      });
    }
  }
  _saveConfirmedDeductions();
  cartItems.clear();
  shareprefs?.remove(_cartKey);
  inventoryVersion.value++;
}
}