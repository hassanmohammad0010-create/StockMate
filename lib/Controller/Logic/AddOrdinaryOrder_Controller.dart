// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Medicine_Service.dart';
import 'package:stock_mate_project/core/models/Order_Form_Entry.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Post_Refill_Request_Service.dart';
import 'package:stock_mate_project/core/models/Request_Item_Input.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Ordinary_Confirm_Page.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';
import 'package:stock_mate_project/core/models/Medicine_Model.dart';

class AddOrdinaryOrderController extends GetxController {
  static const int maxOrders = 5;

  // ─── Services ───────────────────────────────────────────────────────────
  final MedicineService _medicineService = MedicineService();
  final RefillRequestService _refillRequestService = RefillRequestService();

  late final GetNameRollOfUserController getNameRollOfUserController;
  late final String _departmentId;

  // ─── Reactive state: قائمة الأدوية من الـ API ─────────────────────────────
  final RxList<MedicineModel> medicines = <MedicineModel>[].obs;
  final RxBool isMedicinesLoading = false.obs;
  final RxString medicinesError = ''.obs;

  List<String> get medicineNames =>
      medicines.map((m) => m.name).where((n) => n.isNotEmpty).toList();

  // ─── Reactive state: كل كارد طلب بالواجهة ─────────────────────────────────
  final RxList<OrderFormEntry> orders = <OrderFormEntry>[
    const OrderFormEntry(),
  ].obs;
  final RxInt activeOrderIndex = 0.obs;
  final RxBool isLoading = false.obs;

  // ✅ الأولوية العامة للطلب الكامل
  final RxString requestPriority = 'عادي'.obs;

  // ✅ تخزين الطلب المُنشأ من الـ API
  final Rx<RefillRequest?> createdRequest = Rx<RefillRequest?>(null);

  // ─── TextEditingController للكمية + GlobalKey للـ Form لكل طلب ───────────
  final List<TextEditingController> _quantityControllers = [];
  final List<GlobalKey<FormState>> formKeys = [];

  // ─── ملاحظات الطلب الكامل (حقل عام واحد لكل الطلب) ────────────────────────
  final TextEditingController notesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
    _departmentId = getNameRollOfUserController.id ?? '';
    _addControllerSet();
    fetchMedicines();
  }

  @override
  void onClose() {
    for (final c in _quantityControllers) {
      c.dispose();
    }
    notesController.dispose();
    super.onClose();
  }

  // ─── جلب الأدوية من الـ API ────────────────────────────────────────────────
  Future<void> fetchMedicines() async {
    isMedicinesLoading.value = true;
    medicinesError.value = '';

    final result = await _medicineService.getMedicines(
      departmentId: _departmentId,
    );

    if (result.isEmpty) {
      medicinesError.value = 'تعذر تحميل قائمة الأدوية';
    }

    medicines.value = result;
    isMedicinesLoading.value = false;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  void _addControllerSet() {
    _quantityControllers.add(TextEditingController());
    formKeys.add(GlobalKey<FormState>());
  }

  TextEditingController quantityCtrl([int? index]) =>
      _quantityControllers[index ?? activeOrderIndex.value];

  GlobalKey<FormState> formKey([int? index]) =>
      formKeys[index ?? activeOrderIndex.value];

  // ─── Order management ─────────────────────────────────────────────────────
  bool get canAddOrder => orders.length < maxOrders;
  bool get canRemoveOrder => orders.length > 1;

  void addOrder() {
    if (!canAddOrder) {
      customSnackBar(
        title: 'تنبيه',
        message: 'لا يمكنك إضافة أكثر من $maxOrders طلبات',
        color: constOrange,
        messageColor: Colors.white,
      );
      return;
    }
    _saveCurrentQuantity();
    orders.add(const OrderFormEntry());
    _addControllerSet();
    activeOrderIndex.value = orders.length - 1;
  }

  void removeOrder(int index) {
    if (!canRemoveOrder) return;
    _quantityControllers[index].dispose();
    _quantityControllers.removeAt(index);
    formKeys.removeAt(index);
    orders.removeAt(index);

    if (activeOrderIndex.value >= orders.length) {
      activeOrderIndex.value = orders.length - 1;
    }
  }

  void selectOrder(int index) {
    _saveCurrentQuantity();
    activeOrderIndex.value = index;
    _loadQuantityToController(index);
  }

  // ─── Sync: quantity ↔ model ───────────────────────────────────────────────
  void _saveCurrentQuantity() {
    final i = activeOrderIndex.value;
    if (i >= orders.length) return;
    final qty = _quantityControllers[i].text;
    orders[i] = orders[i].copyWith(quantity: qty);
  }

  void _loadQuantityToController(int index) {
    _quantityControllers[index].text = orders[index].quantity;
  }

  // ─── Dropdown updates ─────────────────────────────────────────────────────
  void updateMedicineName(int index, String? name) {
    if (index >= orders.length) return;

    final matched = medicines.firstWhereOrNull((m) => m.name == name);
    orders[index] = orders[index].copyWith(selectedMedicine: matched);
    orders.refresh();
  }

  // ✅ تحديث الأولوية العامة للطلب الكامل
  void updateRequestPriority(String priority) {
    requestPriority.value = priority;
    print('🎯 الأولوية المختارة الآن: $priority');
  }

  // ─── STEP 1: إنشاء الطلب (POST /requests) → draft → انتقال للتأكيد ───────
  Future<void> validateAndGoToConfirm() async {
    _saveCurrentQuantity();

    bool allValid = true;
    int invalidIndex = -1;

    // ✅ التحقق من جميع النماذج
    for (int i = 0; i < orders.length; i++) {
      final formState = formKey(i).currentState;

      if (formState != null) {
        // ✅ الطلب موجود في الشجرة، نتحقق منه باستخدام الـ validator
        if (!formState.validate()) {
          allValid = false;
          invalidIndex = i;
          break;
        }
      } else {
        // ✅ الطلب غير موجود في الشجرة، نتحقق يدوياً من الـ Model
        final o = orders[i];
        if (o.selectedMedicine == null || o.quantity.trim().isEmpty) {
          allValid = false;
          invalidIndex = i;
          break;
        }
      }
    }

    if (!allValid) {
      // ✅ الانتقال للطلب الذي يحتوي على خطأ إذا لم يكن هو الحالي
      if (invalidIndex != activeOrderIndex.value) {
        selectOrder(invalidIndex);
        // ننتظر حتى يتم بناء الطلب الجديد ثم نتحقق منه لعرض الأخطاء
        WidgetsBinding.instance.addPostFrameCallback((_) {
          formKey(invalidIndex).currentState?.validate();
        });
      }

      customSnackBar(
        title: 'بيانات ناقصة',
        message: 'يرجى تعبئة جميع الحقول المطلوبة',
        color: constRed,
        messageColor: Colors.white,
      );
      return;
    }

    // ✅ إرسال الطلب للباك اند
    isLoading.value = true;
    try {
      final items = orders
          .where(
            (o) => o.selectedMedicine != null && o.quantity.trim().isNotEmpty,
          )
          .map(
            (o) => RequestItemInput(
              variantId: o.selectedMedicine!.variantId,
              requestedQuantity: int.tryParse(o.quantity.trim()) ?? 0,
            ),
          )
          .toList();

      if (items.isEmpty) {
        customSnackBar(
          title: 'بيانات ناقصة',
          message: 'يرجى إضافة دواء واحد على الأقل قبل الإرسال',
          color: constRed,
          messageColor: Colors.white,
        );
        return;
      }

      final currentPriority = requestPriority.value;

      // ✅ حوّل من عربي لإنجليزي قبل الإرسال
      final String apiPriority;
      switch (currentPriority) {
        case 'عادي':
          apiPriority = 'normal';
          break;
        case 'ضروري':
          apiPriority = 'urgent';
          break;
        default:
          apiPriority = 'normal';
      }

      final requestBody = CreateRefillRequestModel(
        priority: apiPriority,
        requestType: 'normal',
        frequencyInterval: null,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        items: items,
      );

      print('📤 Body المرسل: ${jsonEncode(requestBody.toJson())}');

      final result = await _refillRequestService.createRequest(requestBody);

      if (result == null) return;

      createdRequest.value = result;

      if (result.status == RequestStatus.draft) {
        print('✅ تم الإنشاء بنجاح | ID: ${result.id}');
        print('📊 الحالة: ${result.status.displayName}');
        print('📋 الرقم: ${result.requestNumber}');

        Get.to(
          () => const OrdinaryConfirmPage(),
          transition: Transition.rightToLeft,
        );
      } else {
        customSnackBar(
          messageColor: Colors.white,
          title: 'تنبيه',
          message: 'حالة غير متوقعة: ${result.status.displayName}',
          color: constOrange,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── STEP 2: تأكيد الإرسال (POST /{id}/submit) → pending_hospital_approval
  Future<void> confirmRequest() async {
    final requestId = createdRequest.value?.id;
    if (requestId == null) {
      customSnackBar(
        title: 'خطأ',
        message: 'لم يتم العثور على الطلب',
        color: constRed,
        messageColor: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final result = await _refillRequestService.submitRequest(requestId);

      if (result == null) return;

      createdRequest.value = result;

      print('✅ تم التأكيد بنجاح | ID: ${result.id}');
      print('📊 الحالة الجديدة: ${result.status.displayName}');

      if (result.status == RequestStatus.pendingHospitalApproval) {
        customSnackBar(
          title: 'تم الإرسال',
          message: 'تم إرسال الطلب للمشفى بنجاح (${result.requestNumber})',
          color: constGreen,
          messageColor: Colors.white,
        );
        Get.offAllNamed(AppRoutes.DepartmentHeadsMainPage);
      } else {
        customSnackBar(
          messageColor: Colors.white,
          title: 'تنبيه',
          message: 'حالة غير متوقعة: ${result.status.displayName}',
          color: constOrange,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
