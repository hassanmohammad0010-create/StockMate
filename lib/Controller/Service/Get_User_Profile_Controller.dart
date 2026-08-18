// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:stock_mate_project/Service/App/Get_My_Profile_Service.dart';
import 'package:stock_mate_project/core/models/UserProfile_Model.dart';

class UserProfileController extends GetxController {
  final GetMyProfileService _profileService = GetMyProfileService();

  // ─── Reactive state ───────────────────────────────────────────────
  final Rxn<UserProfile> profile = Rxn<UserProfile>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  // ─── جلب الملف الشخصي ─────────────────────────────────────────────
  Future<void> fetchProfile() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _profileService.getMyProfile();

      if (result == null) {
        errorMessage.value = 'تعذر تحميل معلومات المستخدم';
      } else {
        profile.value = result;
        print(
          '✅ تم جلب الملف الشخصي: ${result.fullName} | الدور: ${result.roleName} | الصلاحيات: ${result.permissions.length}',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ─── ✅ Helpers مختصرة للاستخدام في الواجهات ─────────────────────

  /// هل تم تحميل الملف؟
  bool get isLoaded => profile.value != null;

  String get fullName => profile.value?.fullName ?? '';
  String get roleName => profile.value?.roleName ?? '';
  String get departmentName => profile.value?.departmentName ?? '';
  String get departmentId => profile.value?.departmentId ?? '';
  String get userId => profile.value?.id ?? '';
  String get email => profile.value?.email ?? '';
  String get phone => profile.value?.phone ?? '';

  /// ✅ فحص صلاحية — مثال:
  /// if (userCtrl.hasPermission(Permissions.manageDepartmentQueue)) { ... }
  bool hasPermission(String permission) =>
      profile.value?.hasPermission(permission) ?? false;

  /// ✅ فحوصات الأدوار
  bool get isDepartmentManager => profile.value?.isDepartmentManager ?? false;
  bool get isDoctor => profile.value?.isDoctor ?? false;
  bool get isPharmacist => profile.value?.isPharmacist ?? false;
}