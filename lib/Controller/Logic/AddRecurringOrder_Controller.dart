// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Medicine_Service.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Post_Refill_Request_Service.dart';
import 'package:stock_mate_project/core/models/Request_Item_Input.dart';
import 'package:stock_mate_project/View/Screens/App/Head%20of%20department/Recurring_Confirm_Page.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/models/Medicine_Model.dart';
import 'package:stock_mate_project/core/router/app_routes.dart';

class AddRecurringOrderController extends GetxController {
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

  // ─── Reactive state ───────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  // ✅ تخزين الطلب المُنشأ من الـ API
  final Rx<RefillRequest?> createdRequest = Rx<RefillRequest?>(null);

  // ─── Form + Controllers ─────────────────────────────────────────────────
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ─── ✅ الحقول المستقلة (بدل OrderModel) ─────────────────────────────────
  final Rxn<String> selectedMedicineName = Rxn<String>();
  // ─── التكرار — القيمة الافتراضية: أسبوعي ─────────────────────────────────
  final RxString selectedRecurring = 'weekly'.obs;

  static const Map<String, String> recurringLabels = {
    'daily': 'يومي',
    'weekly': 'أسبوعي',
    'monthly': 'شهري',
  };

  // ─── المدة (عدد التكرارات) ──────────────────────────────────────────────
  late final RxInt selectedDuration;

  @override
  void onInit() {
    super.onInit();
    getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
    _departmentId = getNameRollOfUserController.id ?? '';
    selectedDuration = durationOptions.first.obs;
    fetchMedicines();
  }

  @override
  void onClose() {
    quantityController.dispose();
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

  // ─── التكرار ──────────────────────────────────────────────────────────────
  void selectRecurring(String value) {
    selectedRecurring.value = value;
    // عند تغيير نوع التكرار، نعيد ضبط المدة لأول قيمة
    final firstOption = durationOptions.first;
    selectedDuration.value = firstOption;
  }

  // ─── المدة (عدد التكرارات) ────────────────────────────────────────────────
  List<int> get durationOptions {
    switch (selectedRecurring.value) {
      case 'daily':
        return List.generate(364, (i) => i + 2);
      case 'monthly':
        return List.generate(11, (i) => i + 2);
      case 'weekly':
      default:
        return List.generate(51, (i) => i + 2);
    }
  }

  void updateDuration(int value) {
    selectedDuration.value = value;
  }

  // ─── ✅ تحديث اسم الدواء مباشرة ─────────────────────────────────────────
  void updateMedicineName(String? value) {
    selectedMedicineName.value = value;
  }

  // ─── STEP 1: إنشاء الطلب (POST /requests) → draft → انتقال للتأكيد ───────
  Future<void> validateAndGoToConfirm() async {
    // ✅ formKey.validate() يتحقق من كل شيء
    final isFormValid = formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      customSnackBar(
        title: 'بيانات ناقصة',
        message: 'يرجى تعبئة جميع الحقول المطلوبة',
        color: constRed,
        messageColor: Colors.white,
      );
      return;
    }

    // ✅ بناء CreateRefillRequestModel مباشرة من الحقول المستقلة
    isLoading.value = true;
    try {
      final medicineName = selectedMedicineName.value;

      // البحث عن variantId من الاسم
      final matched = medicines.firstWhereOrNull((m) => m.name == medicineName);

      if (matched == null) {
        customSnackBar(
          title: 'خطأ',
          message: 'لم يتم العثور على الدواء المختار',
          color: constRed,
          messageColor: Colors.white,
        );
        return;
      }

      final items = [
        RequestItemInput(
          variantId: matched.variantId,
          requestedQuantity: int.tryParse(quantityController.text.trim()) ?? 0,
        ),
      ];

      // ✅ بناء الـ Request Body مباشرة
      final requestBody = CreateRefillRequestModel(
        priority: 'normal',
        requestType: selectedRecurring.value,
        frequencyInterval: selectedDuration.value,
        notes: notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
        items: items,
      );

      print('📤 Body المرسل: ${requestBody.toJson()}');
      print('🔁 نوع التكرار: ${selectedRecurring.value}');
      print('🔢 الـ frequencyInterval: ${selectedDuration.value}');

      final result = await _refillRequestService.createRequest(requestBody);

      if (result == null) return;

      createdRequest.value = result;

      if (result.status == RequestStatus.draft) {
        print('✅ تم الإنشاء بنجاح | ID: ${result.id}');
        print('📊 الحالة: ${result.status.displayName}');
        print('📋 الرقم: ${result.requestNumber}');

        Get.to(
          () => const RecurringConfirmPage(),
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
          message:
              'تم إرسال الطلب الدوري للمشفى بنجاح (${result.requestNumber})',
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
