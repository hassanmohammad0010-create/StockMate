// lib/View/Widget/App/Create_Purchase_Receipt_BottomSheet.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Create_Purchase_Receipt_Controller.dart';
import 'package:stock_mate_project/Controller/App/Get_All_Suppliers_Controller.dart';
import 'package:stock_mate_project/Service/Head%20of%20Purchasing/Create_Purchase_Receipt_Service.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/Function/Validation.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/models/Purchase_Request_Model.dart';
import 'package:stock_mate_project/core/models/Supplier_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Row.dart';

class CreatePurchaseReceiptBottomSheet extends StatefulWidget {
  const CreatePurchaseReceiptBottomSheet({
    super.key,
    required this.purchaseRequestId,
    required this.items,
    required this.onSuccess,
  });

  final String purchaseRequestId;
  final List<PurchaseDetailItem> items;
  final VoidCallback onSuccess;

  @override
  State<CreatePurchaseReceiptBottomSheet> createState() =>
      _CreatePurchaseReceiptBottomSheetState();
}

class _CreatePurchaseReceiptBottomSheetState
    extends State<CreatePurchaseReceiptBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CreatePurchaseReceiptController _receiptController;
  late final GetAllSuppliersController _suppliersController;
  final Rxn<SupplierModel> _selectedSupplier = Rxn<SupplierModel>();
  final Rxn<DateTime> _receivingDate = Rxn<DateTime>();

  @override
  void initState() {
    super.initState();
    _receiptController = Get.put(
      CreatePurchaseReceiptController(requestItems: widget.items),
      tag: widget.purchaseRequestId,
    );
    _suppliersController = Get.put(GetAllSuppliersController());
  }

  Future<void> _pickReceivingDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _receivingDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) _receivingDate.value = picked;
  }

  Future<void> _onConfirm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedSupplier.value == null) {
      customSnackBar(
        title: 'خطأ',
        message: 'الرجاء اختيار المورد',
        color: constRed,
        messageColor: constLightRed,
      );
      return;
    }

    if (_receivingDate.value == null) {
      customSnackBar(
        title: 'خطأ',
        message: 'الرجاء اختيار تاريخ الاستلام',
        color: constRed,
        messageColor: constLightRed,
      );
      return;
    }

    final builtItems = _receiptController.buildItems();
    if (builtItems == null) {
      customSnackBar(
        title: 'خطأ',
        message:
            'الرجاء إكمال بيانات كل صنف (الكمية، الدفعة، التاريخين، السعر)',
        color: constRed,
        messageColor: constLightRed,
      );
      return;
    }

    Get.back(); // إغلاق الشيت
    showLoadingDialog();

    final success = await CreatePurchaseReceiptService().createReceipt(
      purchaseRequestId: widget.purchaseRequestId,
      supplierId: _selectedSupplier.value!.id,
      receivingDate: _receivingDate.value!,
      notes: _receiptController.notesController.text.trim(),
      items: builtItems,
      receiptImages: _receiptController.receiptImages,
    );

    hideLoadingDialog();

    if (success) {
      customSnackBar(
        title: 'تم بنجاح',
        message: 'تم إنشاء إيصال الاستلام بنجاح',
        color: constGreen,
        messageColor: constLightGreen,
      );
      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.screenWidth * 0.03,
                    vertical: context.screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          alignment: Alignment.center,
                          width: context.screenWidth * 0.35,
                          height: context.screenHeight * 0.05,
                          decoration: BoxDecoration(
                            color: constLightBlue,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'إنشاء إيصال استلام',
                            style: TextStyle(
                              color: constBlue,
                              fontFamily: lateef,
                              fontSize: context.screenHeight * 0.024,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.screenHeight * 0.015),

                      // ─── المورد ─────────────────────────────
                      GetBuilder<GetAllSuppliersController>(
                        builder: (sController) {
                          if (sController.suppliers == null) {
                            return const Center(
                              child: CustomLoadingIndicator(),
                            );
                          }
                          return CustomDropdown<SupplierModel>(
                            items: sController.suppliers ?? [],
                            labelBuilder: (s) => s.name,
                            label: 'المورد',
                            hint: '',
                            icon: Icons.business_center_outlined,
                            validator: (data) => Validation()
                                .generalValidationForDropdown(data?.name),
                            value: _selectedSupplier.value,
                            onChanged: (data) {
                              _selectedSupplier.value = data;
                            },
                          );
                        },
                      ),
                      SizedBox(height: context.screenHeight * 0.015),

                      // ─── تاريخ الاستلام ─────────────────────
                      Obx(
                        () => GestureDetector(
                          onTap: _pickReceivingDate,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.screenWidth * 0.04,
                              vertical: context.screenHeight * 0.018,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: constBlue,
                                  size: 22,
                                ),
                                SizedBox(width: context.screenWidth * 0.03),
                                Text(
                                  _receivingDate.value == null
                                      ? 'اختر تاريخ الاستلام'
                                      : '${_receivingDate.value!.year}-${_receivingDate.value!.month.toString().padLeft(2, '0')}-${_receivingDate.value!.day.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _receivingDate.value == null
                                        ? Colors.grey.shade500
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.screenHeight * 0.015),

                      // ─── الملاحظات ───────────────────────────
                      CustomMyTextFormField(
                        controller: _receiptController.notesController,
                        label: 'ملاحظات (اختياري)',
                        hint: '',
                        prefixIcon: Icons.notes_outlined,
                      ),
                      SizedBox(height: context.screenHeight * 0.02),

                      // ─── الصور ───────────────────────────────
                      Text(
                        'صور الإيصال',
                        style: TextStyle(
                          fontFamily: cairo,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: context.screenHeight * 0.01),
                      Obx(
                        () => Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ..._receiptController.receiptImages.map(
                              (file) => Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      file,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: GestureDetector(
                                      onTap: () =>
                                          _receiptController.removeImage(file),
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: _receiptController.pickFromGallery,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: constLightBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.photo_library_outlined,
                                  color: constBlue,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _receiptController.pickFromCamera,
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: constLightBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: constBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: context.screenHeight * 0.02),

                      // ─── الأصناف ─────────────────────────────
                      // ─── الأصناف ─────────────────────────────
                      Text(
                        'بيانات الأصناف',
                        style: TextStyle(
                          fontFamily: cairo,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: context.screenHeight * 0.015),

                      // استخدام asMap للحصول على الـ index لعمل Divider بين العناصر فقط (وليس بعد الأخير)
                      ...widget.items.asMap().entries.map((entry) {
                        int index = entry.key;
                        var item = entry.value;
                        final String materialName =
                            item.variant?.product?.name ??
                            item.variant?.variantName ??
                            '-';
                        final String unitAbbreviation =
                            item.variant?.unit?.abbreviation ?? '';

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // عنوان اختياري يوضح رقم الصنف (يعطي شكل أرتب بعد إزالة الكونتينر)
                            Text(
                              'تفاصيل الصنف ${index + 1}',
                              style: TextStyle(
                                fontFamily: cairo,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: constBlue,
                              ),
                            ),
                            SizedBox(height: context.screenHeight * 0.01),

                            // كارت عرض بيانات المادة الأساسية
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              child: Column(
                                children: [
                                  CustomRow(
                                    title: 'المادة',
                                    iconData: Icons.design_services_outlined,
                                    label: materialName,
                                  ),
                                  CustomRow(
                                    title: 'الكمية المطلوبة',
                                    iconData: Icons.inventory_2_outlined,
                                    label:
                                        '${item.requestedQuantity} $unitAbbreviation',
                                  ),
                                  CustomRow(
                                    title: 'السعر المتوقع',
                                    iconData: Icons.attach_money,
                                    label: '${item.estimatedPrice}\$',
                                  ),
                                  // ← الكمية المعتمدة/المستلمة تظهر فقط لو متوفرة
                                  if (item.approvedQuantity != null)
                                    CustomRow(
                                      title: 'الكمية المعتمدة',
                                      iconData: Icons.check_circle_outline,
                                      label:
                                          '${item.approvedQuantity} $unitAbbreviation',
                                    ),
                                  if (item.receivedQuantity > 0)
                                    CustomRow(
                                      title: 'الكمية المستلمة',
                                      iconData: Icons.move_to_inbox_outlined,
                                      label:
                                          '${item.receivedQuantity} $unitAbbreviation',
                                    ),
                                ],
                              ),
                            ),
                            SizedBox(height: context.screenHeight * 0.015),

                            // الحقول الخاصة بالصنف
                            CustomMyTextFormField(
                              controller: _receiptController
                                  .quantityControllers[item.id],
                              label: 'الكمية المستلمة',
                              hint: '',
                              keyboardType: TextInputType.number,
                              prefixIcon: Icons.numbers,
                              validator: (data) =>
                                  Validation().generalValidation(data!),
                            ),
                            SizedBox(height: context.screenHeight * 0.012),

                            CustomMyTextFormField(
                              controller: _receiptController
                                  .batchNumberControllers[item.id],
                              label: 'رقم الدفعة',
                              hint: '',
                              prefixIcon: Icons.tag_outlined,
                              validator: (data) =>
                                  Validation().generalValidation(data!),
                            ),
                            SizedBox(height: context.screenHeight * 0.012),

                            CustomMyTextFormField(
                              controller: _receiptController
                                  .purchasePriceControllers[item.id],
                              label: 'سعر الشراء',
                              hint: '',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              prefixIcon: Icons.attach_money,
                              validator: (data) =>
                                  Validation().generalValidation(data!),
                            ),
                            SizedBox(height: context.screenHeight * 0.012),

                            Obx(
                              () => GestureDetector(
                                onTap: () => _receiptController
                                    .pickManufacturingDate(context, item.id),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.screenWidth * 0.03,
                                    vertical: context.screenHeight * 0.014,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.event_outlined,
                                        size: 18,
                                        color: constBlue,
                                      ),
                                      SizedBox(
                                        width: context.screenWidth * 0.02,
                                      ),
                                      Text(
                                        _receiptController
                                                    .manufacturingDates[item
                                                    .id] ==
                                                null
                                            ? 'تاريخ التصنيع'
                                            : _receiptController
                                                  .manufacturingDates[item.id]
                                                  .toString()
                                                  .split(' ')
                                                  .first,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: context.screenHeight * 0.012),

                            Obx(
                              () => GestureDetector(
                                onTap: () => _receiptController
                                    .pickExpirationDate(context, item.id),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: context.screenWidth * 0.03,
                                    vertical: context.screenHeight * 0.014,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.event_busy_outlined,
                                        size: 18,
                                        color: constBlue,
                                      ),
                                      SizedBox(
                                        width: context.screenWidth * 0.02,
                                      ),
                                      Text(
                                        _receiptController.expirationDates[item
                                                    .id] ==
                                                null
                                            ? 'تاريخ الانتهاء'
                                            : _receiptController
                                                  .expirationDates[item.id]
                                                  .toString()
                                                  .split(' ')
                                                  .first,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // إضافة الفاصل (Divider) بين الأصناف، باستثناء الصنف الأخير
                            if (index < widget.items.length - 1) ...[
                              SizedBox(height: context.screenHeight * 0.025),
                              const Divider(
                                color: Colors.grey,
                                thickness: 1,
                                height: 1,
                              ),
                              SizedBox(height: context.screenHeight * 0.025),
                            ],
                          ],
                        );
                      }).toList(),
                      SizedBox(height: context.screenHeight * 0.03),
                      Align(
                        alignment: Alignment.center,
                        child: CustomMainButtom(
                          title: 'تأكيد',
                          color: constBlue,
                          fontcolor: Colors.white,
                          onPressed: _onConfirm,
                        ),
                      ),
                      SizedBox(height: context.screenHeight * 0.03),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
