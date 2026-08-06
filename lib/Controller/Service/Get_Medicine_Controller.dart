import 'package:get/get.dart';
import 'package:stock_mate_project/Controller/Service/Get_Name_Roll_Of_User.dart';
import 'package:stock_mate_project/core/models/Medicine_Model.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Medicine_Service.dart';

/// كنترولر مخصص لاختبار MedicineService لوحده
/// بدون أي ربط بالواجهة - فقط طباعة النتائج في Terminal
class MedicineTestController extends GetxController {
  final MedicineService _medicineService = MedicineService();
  late final GetNameRollOfUserController getNameRollOfUserController;
  late final String _departmentId;
  // ⚠️ مؤقت للاختبار فقط - ضع هنا التوكن اللي حصلت عليه من تسجيل الدخول
  // ⚠️ لا تشارك هذا التوكن مع أي أحد أو بأي محادثة عامة
  // final String _testToken = 'ضع_التوكن_هنا';

  // ⚠️ مؤقت للاختبار فقط - UUID القسم (Department)
  // final String _testDepartmentId = '38fe6427-05eb-40be-a850-15b16ed1e35c';

  // حالات قابلة للمراقبة (اختياري، تفيدك لاحقاً عند الربط بالواجهة)

  var isLoading = false.obs;
  var medicines = <MedicineModel>[].obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getNameRollOfUserController = Get.find<GetNameRollOfUserController>();
    _departmentId = getNameRollOfUserController.id ?? '';
    print('🚀 [MedicineTestController] تم تهيئة الكنترولر');
    fetchMedicinesTest();
  }

  Future<void> fetchMedicinesTest() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      print('⏳ [MedicineTestController] بدء جلب الأدوية...');

      final result = await _medicineService.getMedicines(
        departmentId: _departmentId,
      );

      medicines.value = result;

      print('--------------------------------------------------');
      print('✅ نجح الاختبار! تم جلب ${result.length} دواء');
      for (var i = 0; i < result.length; i++) {
        print('   ${i + 1}. ${result[i]}');
      }
      print('--------------------------------------------------');
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ [MedicineTestController] خطأ: $e');
    } finally {
      isLoading.value = false;
      print('🏁 [MedicineTestController] انتهى الاختبار');
    }
  }
}
