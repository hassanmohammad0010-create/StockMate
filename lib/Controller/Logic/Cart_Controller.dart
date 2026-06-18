// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Cart_Item_Model.dart';
import 'package:stock_mate_project/core/models/Material_Model.dart';

class CartController extends GetxController {
  static CartController get to => Get.isRegistered<CartController>()
      ? Get.find<CartController>()
      : Get.put(CartController(), permanent: true);

  final RxList<CartItem> cartItems = <CartItem>[].obs;

  /// يزيد كل مرة يتغيّر فيها المخزون (إضافة/إرجاع)، الصفحات التي تعرض
  /// كميات المخزون تراقب هذه القيمة داخل Obx لتجبر نفسها على إعادة البناء.
  final RxInt inventoryVersion = 0.obs;

  int _nextId = 1;

  /// يضيف [quantity] من [item] الى السلة، ويخصمها من الدفعات الأقرب
  /// انتهاءً أولاً (FEFO). يرجع نص الخطأ عند الفشل، أو null عند النجاح.
  String? addToCart(MaterialItem item, int quantity) {
    if (quantity <= 0) {
      return 'الكمية يجب ان تكون اكبر من صفر';
    }
    if (quantity > item.totalQuantity) {
      return 'الكمية المتوفرة غير كافية (المتوفر: ${item.totalQuantity})';
    }

    final sortedBatches = [...item.batches]
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    int remaining = quantity;
    final List<BatchDeduction> deductions = [];

    for (final batch in sortedBatches) {
      if (remaining <= 0) break;

      final taken = remaining < batch.quantity ? remaining : batch.quantity;
      if (taken <= 0) continue;

      deductions.add(
        BatchDeduction(
          batchId: batch.id,
          quantity: taken,
          expiryDate: batch.expiryDate,
        ),
      );

      final index = item.batches.indexWhere((b) => b.id == batch.id);
      final newQty = batch.quantity - taken;
      if (newQty <= 0) {
        item.batches.removeAt(index);
      } else {
        item.batches[index] = MaterialBatch(
          id: batch.id,
          quantity: newQty,
          expiryDate: batch.expiryDate,
        );
      }
      remaining -= taken;
    }

    cartItems.add(
      CartItem(
        id: 'CART-${_nextId++}',
        materialId: item.id,
        materialName: item.name,
        quantity: quantity,
        deductions: deductions,
      ),
    );

    inventoryVersion.value++;
    return null;
  }

  /// يرجع [returnQuantity] (كاملة أو جزئية) من [cartItem] الى المخزون.
  void returnToStock(CartItem cartItem, int returnQuantity) {
    int actualReturn = returnQuantity;
    if (actualReturn > cartItem.quantity) actualReturn = cartItem.quantity;
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
    final deductionsCopy = List<BatchDeduction>.from(cartItem.deductions);

    for (final deduction in deductionsCopy) {
      if (remaining <= 0) break;
      final restoreQty =
          remaining < deduction.quantity ? remaining : deduction.quantity;

      final index =
          material.batches.indexWhere((b) => b.id == deduction.batchId);
      if (index == -1) {
        material.batches.add(
          MaterialBatch(
            id: deduction.batchId,
            quantity: restoreQty,
            expiryDate: deduction.expiryDate,
          ),
        );
      } else {
        final existing = material.batches[index];
        material.batches[index] = MaterialBatch(
          id: existing.id,
          quantity: existing.quantity + restoreQty,
          expiryDate: existing.expiryDate,
        );
      }

      final originalIndex = cartItem.deductions.indexOf(deduction);
      if (restoreQty == deduction.quantity) {
        cartItem.deductions.removeAt(originalIndex);
      } else {
        cartItem.deductions[originalIndex] = BatchDeduction(
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
  }
}