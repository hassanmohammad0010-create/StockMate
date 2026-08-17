// lib/Controller/App/Create_Purchase_Receipt_Controller.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_mate_project/Service/Head%20of%20Purchasing/Create_Purchase_Receipt_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/models/Create_Purchase_Receipt_Item_Input.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class ReceiptItemFormData {
  ReceiptItemFormData({required this.item});

  final PurchaseDetailItem item;

  final quantityController = TextEditingController();
  final batchNumberController = TextEditingController();
  final purchasePriceController = TextEditingController();
  final Rxn<DateTime> manufacturingDate = Rxn<DateTime>();
  final Rxn<DateTime> expirationDate = Rxn<DateTime>();

  void dispose() {
    quantityController.dispose();
    batchNumberController.dispose();
    purchasePriceController.dispose();
  }
}

class CreatePurchaseReceiptController extends GetxController {
  CreatePurchaseReceiptController({
    required this.purchaseRequestId,
    required List<PurchaseDetailItem> requestItems,
  }) {
    itemsFormData = requestItems
        .map((item) => ReceiptItemFormData(item: item))
        .toList();
  }

  final String purchaseRequestId;
  late final List<ReceiptItemFormData> itemsFormData;

  final CreatePurchaseReceiptService _service = CreatePurchaseReceiptService();
  final ImagePicker _picker = ImagePicker();

  final RxnString supplierId = RxnString();
  final Rxn<DateTime> receivingDate = Rxn<DateTime>(DateTime.now());
  final RxString type = 'batch'.obs; // 'batch' | 'final_batch'
  final TextEditingController notesController = TextEditingController();

  final RxList<File> receiptImages = <File>[].obs;
  final RxBool isSubmitting = false.obs;

  Future<void> pickImageFromGallery() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      receiptImages.add(File(picked.path));
    }
  }

  Future<void> pickImageFromCamera() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      receiptImages.add(File(picked.path));
    }
  }

  void removeImage(int index) {
    receiptImages.removeAt(index);
  }

  Future<bool> submit() async {
    if (supplierId.value == null || supplierId.value!.isEmpty) {
      customSnackBar(
        title: 'خطأ',
        message: 'الرجاء اختيار المورد',
        color: constRed,
        messageColor: constLightRed,
      );
      return false;
    }

    if (receivingDate.value == null) {
      customSnackBar(
        title: 'خطأ',
        message: 'الرجاء اختيار تاريخ الاستلام',
        color: constRed,
        messageColor: constLightRed,
      );
      return false;
    }

    final List<CreatePurchaseReceiptItemInput> items = [];

    for (final formData in itemsFormData) {
      final qtyText = formData.quantityController.text.trim();
      final batch = formData.batchNumberController.text.trim();
      final priceText = formData.purchasePriceController.text.trim();

      // ✅ نتجاهل الأصناف يلي المستخدم ما عبّاها (كمية = 0 أو فاضية)
      if (qtyText.isEmpty || int.tryParse(qtyText) == null) continue;

      if (batch.isEmpty ||
          formData.manufacturingDate.value == null ||
          formData.expirationDate.value == null ||
          priceText.isEmpty ||
          double.tryParse(priceText) == null) {
        customSnackBar(
          title: 'خطأ',
          message: 'الرجاء تعبئة كل بيانات الصنف بشكل كامل',
          color: constRed,
          messageColor: constLightRed,
        );
        return false;
      }

      items.add(
        CreatePurchaseReceiptItemInput(
          purchaseRequestItemId: formData.item.id,
          quantity: int.parse(qtyText),
          batchNumber: batch,
          manufacturingDate: formData.manufacturingDate.value!,
          expirationDate: formData.expirationDate.value!,
          purchasePrice: double.parse(priceText),
        ),
      );
    }

    if (items.isEmpty) {
      customSnackBar(
        title: 'خطأ',
        message: 'الرجاء تعبئة صنف واحد على الأقل',
        color: constRed,
        messageColor: constLightRed,
      );
      return false;
    }

    isSubmitting.value = true;
    showLoadingDialog();

    final success = await _service.createReceipt(
      purchaseRequestId: purchaseRequestId,
      supplierId: supplierId.value!,
      receivingDate: receivingDate.value!,
      type: type.value,
      notes: notesController.text.trim(),
      items: items,
      receiptImages: receiptImages,
    );

    hideLoadingDialog();
    isSubmitting.value = false;

    if (success) {
      customSnackBar(
        title: 'تم الحفظ',
        message: 'تم إنشاء إيصال الاستلام بنجاح',
        color: constGreen,
        messageColor: constLightGreen,
      );
    } else {
      customSnackBar(
        title: 'خطأ',
        message: 'تعذر إنشاء إيصال الاستلام، حاول مجددًا',
        color: constRed,
        messageColor: constLightRed,
      );
    }

    return success;
  }

  @override
  void onClose() {
    for (final f in itemsFormData) {
      f.dispose();
    }
    notesController.dispose();
    super.onClose();
  }
}
