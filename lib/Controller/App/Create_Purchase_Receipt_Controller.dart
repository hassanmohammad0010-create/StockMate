// lib/Controller/App/Create_Purchase_Receipt_Controller.dart
// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_mate_project/core/models/Create_Purchase_Receipt_Item_Input.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';

class CreatePurchaseReceiptController extends GetxController {
  CreatePurchaseReceiptController({required this.requestItems}) {
    for (final item in requestItems) {
      quantityControllers[item.id] = TextEditingController(
        text: item.requestedQuantity.toString(),
      );
      batchNumberControllers[item.id] = TextEditingController();
      purchasePriceControllers[item.id] = TextEditingController();
    }
  }

  final List<PurchaseDetailItem> requestItems; // ✅ اتصحح

  final TextEditingController notesController = TextEditingController();

  final Map<String, TextEditingController> quantityControllers = {};
  final Map<String, TextEditingController> batchNumberControllers = {};
  final Map<String, TextEditingController> purchasePriceControllers = {};

  final RxMap<String, DateTime?> manufacturingDates = <String, DateTime?>{}.obs;
  final RxMap<String, DateTime?> expirationDates = <String, DateTime?>{}.obs;

  final RxList<File> receiptImages = <File>[].obs;

  final ImagePicker _picker = ImagePicker();

  // ─── اختيار الصور ────────────────────────────────────────────
  Future<void> pickFromGallery() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      receiptImages.addAll(picked.map((x) => File(x.path)));
    }
  }

  Future<void> pickFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (picked != null) {
      receiptImages.add(File(picked.path));
    }
  }

  void removeImage(File file) {
    receiptImages.remove(file);
  }

  // ─── التواريخ ────────────────────────────────────────────────
  Future<void> pickManufacturingDate(
    BuildContext context,
    String itemId,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: manufacturingDates[itemId] ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) manufacturingDates[itemId] = picked;
  }

  Future<void> pickExpirationDate(BuildContext context, String itemId) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: expirationDates[itemId] ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) expirationDates[itemId] = picked;
  }

  // ─── بناء عناصر الفاتورة قبل الإرسال ─────────────────────────
  /// يرجع null لو في حقل ناقص لأي صنف (يفيد لعرض رسالة خطأ)
  List<CreatePurchaseReceiptItemInput>? buildItems() {
    final items = <CreatePurchaseReceiptItemInput>[];

    for (final item in requestItems) {
      final qtyText = quantityControllers[item.id]!.text.trim();
      final batch = batchNumberControllers[item.id]!.text.trim();
      final priceText = purchasePriceControllers[item.id]!.text.trim();
      final mfg = manufacturingDates[item.id];
      final exp = expirationDates[item.id];

      if (qtyText.isEmpty ||
          batch.isEmpty ||
          priceText.isEmpty ||
          mfg == null ||
          exp == null) {
        return null;
      }

      items.add(
        CreatePurchaseReceiptItemInput(
          purchaseRequestItemId: item.id,
          quantity: int.tryParse(qtyText) ?? 0,
          batchNumber: batch,
          manufacturingDate: mfg, // ✅ اتصحح - DateTime مباشرة بدون _fmt
          expirationDate: exp, // ✅ اتصحح - DateTime مباشرة بدون _fmt
          purchasePrice: double.tryParse(priceText) ?? 0,
        ),
      );
    }
    return items;
  }

  @override
  void onClose() {
    notesController.dispose();
    for (final c in quantityControllers.values) c.dispose();
    for (final c in batchNumberControllers.values) c.dispose();
    for (final c in purchasePriceControllers.values) c.dispose();
    super.onClose();
  }
}
