import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Create_User_Page_Controller.dart';
import 'package:stock_mate_project/Controller/App/Get_All_Doctors_Controller.dart';
import 'package:stock_mate_project/Controller/App/Get_Department_Header_Without_Postion_Controller.dart';
import 'package:stock_mate_project/Controller/App/Get_Departments_Controller.dart';
import 'package:stock_mate_project/Controller/App/Get_Users_List_Controller.dart';
import 'package:stock_mate_project/Controller/Loading%20Indecator%20Controller/Loading_Indicator_Controller.dart';
import 'package:stock_mate_project/Service/Boss/Create_User_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_Departments_Without_Manger_Controller.dart';
import 'package:stock_mate_project/Service/Boss/UpDate_User_Information_Service.dart';
import 'package:stock_mate_project/Service/Boss/Update_UserStatus_Service.dart';
import 'package:stock_mate_project/Service/Boss/Assign_Department_Manager_Service.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_User_Container.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';
import 'package:stock_mate_project/core/Function/Validation.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/models/Department_Model.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

// ignore: must_be_immutable
class UserMangmentPage extends StatelessWidget {
  UserMangmentPage({super.key});
  final String pageName = '/CreateUserPage';
  final GlobalKey<FormState> createUserPageKey = GlobalKey();
  // final LoadingIndicatorController loadingIndicatorController = Get.put(
  //   LoadingIndicatorController(),
  // );
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  Createuserpagecontroller createuserpagecontroller = Get.put(
    Createuserpagecontroller(),
  ); // ✅ نفس الكنترولر الموجود، هيستخدم في "ربط طبيب بقسم" (كل الأقسام)
  final GetDepartmentsController getAllDepartmentsController = Get.put(
    GetDepartmentsController(),
  );

  // ✅ حالة الاختيار محلية هنا فقط، لأن الكنترولر مالوش selectedDepartment
  final Rxn<DepartmentModel> selectedDoctorDepartment = Rxn<DepartmentModel>();
  final GetUsersListController getUsersListController = Get.put(
    GetUsersListController(),
  );
  final GetDepartmentsWithoutMangerController getDepartmentsController =
      Get.put(GetDepartmentsWithoutMangerController());

  final GetAllDoctorsController getAllDoctorsController = Get.put(
    GetAllDoctorsController(),
  );
  final GetDepartmentHeaderWithoutPostionController
  getDepartmentHeaderWithoutPostionController = Get.put(
    GetDepartmentHeaderWithoutPostionController(),
  );
  String? name, email, specialty, role;

  void _openCreateUserSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: DraggableScrollableSheet(
            initialChildSize: 0.75,
            minChildSize: 0.4,
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
                    key: createUserPageKey,
                    child: GetBuilder<Createuserpagecontroller>(
                      builder: (createuserpagecontroller) {
                        return createuserpagecontroller.rolesModel.isEmpty
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: context.screenHeight * 0.1,
                                ),
                                child: Align(
                                  alignment: AlignmentGeometry.center,
                                  child: CustomLoadingIndicator(),
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.screenWidth * 0.02,
                                  vertical: context.screenHeight * 0.005,
                                ),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: context.screenHeight * 0.015,
                                    horizontal: context.screenWidth * 0.03,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: context.screenHeight * 0.01,
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: context.screenWidth * 0.32,
                                          height: context.screenHeight * 0.05,
                                          decoration: BoxDecoration(
                                            color: constLightBlue,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'ادخل المعلومات',
                                            style: TextStyle(
                                              color: constBlue,
                                              fontFamily: lateef,
                                              fontSize:
                                                  context.screenHeight * 0.026,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: context.screenHeight * 0.01,
                                      ),
                                      Obx(
                                        () => CustomDropdown<String>(
                                          items: createuserpagecontroller
                                              .roleNames,
                                          labelBuilder: (v) => v,
                                          label: 'الدور الخاص بالمستخدم',
                                          hint: '',
                                          validator: (data) => Validation()
                                              .generalValidationForDropdown(
                                                data,
                                              ), //
                                          icon: Icons.rule_outlined,
                                          value: createuserpagecontroller
                                              .selectedRole
                                              .value,
                                          onChanged: (data) {
                                            createuserpagecontroller
                                                    .selectedRole
                                                    .value =
                                                data;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: context.screenHeight * 0.01,
                                      ),
                                      CustomMyTextFormField(
                                        controller: nameController,
                                        label: 'الاسم',
                                        hint: '',
                                        prefixIcon: Icons.person,
                                        onChanged: (data) {
                                          name = data;
                                        },
                                        validator: (data) => Validation()
                                            .generalValidation(data!),
                                      ),
                                      SizedBox(
                                        height: context.screenHeight * 0.01,
                                      ),
                                      CustomMyTextFormField(
                                        label: 'لبريد الالكتروني',
                                        hint: '',
                                        controller: emailController,
                                        prefixIcon: Icons.email,
                                        onChanged: (data) {
                                          email = data;
                                        },
                                        validator: (data) =>
                                            Validation().emailValidate(data!),
                                      ),
                                      SizedBox(
                                        height: context.screenHeight * 0.01,
                                      ),
                                      CustomMyTextFormField(
                                        label: 'الاختصاص',
                                        controller: specialtyController,
                                        hint: '',
                                        onChanged: (data) {
                                          specialty = data;
                                        },
                                        prefixIcon: Icons.sports_cricket_sharp,
                                        validator: (data) => Validation()
                                            .generalValidation(data!),
                                      ),
                                      SizedBox(
                                        height: context.screenHeight * 0.01,
                                      ),
                                      Align(
                                        alignment: AlignmentGeometry.center,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                                context.screenWidth * 0.04,
                                            vertical:
                                                context.screenHeight * 0.02,
                                          ),
                                          child: CustomMainButtom(
                                            title: 'تأكيد',
                                            color: constBlue,
                                            fontcolor: Colors.white,
                                            onPressed: () async {
                                              if (!createUserPageKey
                                                  .currentState!
                                                  .validate()) {
                                                return;
                                              }

                                              // ✅ الفورم أصلاً بيتحقق من selectedRole عبر الـ validator
                                              // (generalValidationForDropdown)، فما عاد نحتاج فحص يدوي هون
                                              role = createuserpagecontroller
                                                  .getRoleId(
                                                    roleName:
                                                        createuserpagecontroller
                                                            .selectedRole
                                                            .value!,
                                                  );

                                              // ✅ يقفل الشيت أولاً (بنفس منطق الشيتين التانيين)
                                              Get.back();
                                              showLoadingDialog();

                                              final bool response =
                                                  await UserService.createUser(
                                                    fullName: name!,
                                                    email: email!,
                                                    roleId: role!,
                                                    specialty: specialty,
                                                  );

                                              hideLoadingDialog(); // ← يتسكر بكل الحالات

                                              if (response) {
                                                nameController.clear();
                                                emailController.clear();
                                                specialtyController.clear();
                                                createuserpagecontroller
                                                        .selectedRole
                                                        .value =
                                                    null;
                                                name = null;
                                                email = null;
                                                specialty = null;
                                                role = null;

                                                getUsersListController
                                                    .refreshUsers();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ✅ الشيت الجديد: ربط طبيب كمدير قسم
  void _openAssignDoctorSheet(BuildContext context) {
    getAllDoctorsController.selectedDoctor.value = null;
    selectedDoctorDepartment.value = null; // ✅ اتغيّر
    final GlobalKey<FormState> openAssignDoctorSheetKey = GlobalKey();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Form(
          key: openAssignDoctorSheetKey,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.02,
                        vertical: context.screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.screenHeight * 0.01,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              width: context.screenWidth * 0.32,
                              height: context.screenHeight * 0.05,
                              decoration: BoxDecoration(
                                color: constLightBlue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'ربط طبيب بقسم',
                                style: TextStyle(
                                  color: constBlue,
                                  fontFamily: lateef,
                                  fontSize: context.screenHeight * 0.026,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: context.screenHeight * 0.01),

                          // ── دروب داون اختيار الطبيب ──
                          // ✅ حذفنا فرع "لا يوجد أطباء" — الدروب داون نفسه
                          // بيعرض "لا يوجد" جواه لما تكون doctors فاضية
                          Obx(() {
                            if (getAllDoctorsController.isLoading.value) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: context.screenHeight * 0.03,
                                ),
                                child: const Center(
                                  child: CustomLoadingIndicator(),
                                ),
                              );
                            }

                            return CustomDropdown<UserItem>(
                              items: getAllDoctorsController.doctors,
                              labelBuilder: (d) => d.fullName,
                              label: 'الطبيب',
                              validator: (data) =>
                                  Validation().generalValidationForDropdown(
                                    data?.fullName,
                                  ), //
                              hint: '',
                              icon: Icons.person_outline,
                              value:
                                  getAllDoctorsController.selectedDoctor.value,
                              onChanged: (data) {
                                getAllDoctorsController.selectedDoctor.value =
                                    data;
                              },
                            );
                          }),

                          SizedBox(height: context.screenHeight * 0.015),

                          // ── دروب داون اختيار القسم (كل الأقسام) ──
                          // ✅ حذفنا فرع "لا يوجد أقسام" لنفس السبب
                          GetBuilder<GetDepartmentsController>(
                            builder: (controller) {
                              if (controller.department == null) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: context.screenHeight * 0.03,
                                  ),
                                  child: const Center(
                                    child: CustomLoadingIndicator(),
                                  ),
                                );
                              }

                              return Obx(
                                () => CustomDropdown<DepartmentModel>(
                                  items: controller.department!,
                                  labelBuilder: (d) => d.name,
                                  label: 'القسم',
                                  hint: '',
                                  validator: (data) => Validation()
                                      .generalValidationForDropdown(data?.name),

                                  icon: Icons.apartment_outlined,
                                  value: selectedDoctorDepartment.value,
                                  onChanged: (data) {
                                    selectedDoctorDepartment.value = data;
                                  },
                                ),
                              );
                            },
                          ),

                          SizedBox(height: context.screenHeight * 0.02),

                          Align(
                            alignment: Alignment.center,
                            child: CustomMainButtom(
                              title: 'تأكيد',
                              color: constBlue,
                              fontcolor: Colors.white,
                              onPressed: () async {
                                if (openAssignDoctorSheetKey.currentState!
                                    .validate()) {
                                  final doctor = getAllDoctorsController
                                      .selectedDoctor
                                      .value;
                                  final department = selectedDoctorDepartment
                                      .value; // ✅ اتغيّر

                                  Get.back();
                                  showLoadingDialog();

                                  final success = await UpdateUserService()
                                      .updateUser(
                                        userId: doctor!.id,
                                        departmentId: department!.id,
                                      );

                                  hideLoadingDialog();

                                  if (success) {
                                    customSnackBar(
                                      title: 'تم بنجاح',
                                      message: 'تم ربط الطبيب بالقسم بنجاح',
                                      color: constGreen,
                                      messageColor: constLightGreen,
                                    );
                                    getUsersListController.refreshUsers();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _openDepartmentsSheet(BuildContext context) {
    getDepartmentHeaderWithoutPostionController.selectedManager.value = null;
    getDepartmentsController.selectedDepartment.value = null;
    final GlobalKey<FormState> departmentsSheetKey = GlobalKey(); // ✅ جديد

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Form(
          // ✅ جديد - يلف كل المحتوى
          key: departmentsSheetKey,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.55,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.screenWidth * 0.02,
                        vertical: context.screenHeight * 0.02,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ... العنوان زي ما هو ...
                          SizedBox(height: context.screenHeight * 0.01),

                          Obx(() {
                            if (getDepartmentsController.isLoading.value) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: context.screenHeight * 0.03,
                                ),
                                child: const Center(
                                  child: CustomLoadingIndicator(),
                                ),
                              );
                            }
                            return CustomDropdown<DepartmentModel>(
                              items: getDepartmentsController.departments,
                              labelBuilder: (d) => d.name,
                              label: 'القسم',
                              hint: '',
                              validator: (data) =>
                                  Validation().generalValidationForDropdown(
                                    data == null ? null : data.name,
                                  ), // ✅
                              icon: Icons.apartment_outlined,
                              value: getDepartmentsController
                                  .selectedDepartment
                                  .value,
                              onChanged: (data) {
                                getDepartmentsController
                                        .selectedDepartment
                                        .value =
                                    data;
                              },
                            );
                          }),

                          SizedBox(height: context.screenHeight * 0.015),

                          Obx(() {
                            if (getDepartmentHeaderWithoutPostionController
                                .isLoading
                                .value) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: context.screenHeight * 0.03,
                                ),
                                child: const Center(
                                  child: CustomLoadingIndicator(),
                                ),
                              );
                            }
                            return CustomDropdown<UserItem>(
                              items: getDepartmentHeaderWithoutPostionController
                                  .managers,
                              labelBuilder: (m) => m.fullName,
                              label: 'رئيس القسم',
                              hint: '',
                              validator: (data) =>
                                  Validation().generalValidationForDropdown(
                                    data == null ? null : data.fullName,
                                  ), // ✅
                              icon: Icons.person_outline,
                              value: getDepartmentHeaderWithoutPostionController
                                  .selectedManager
                                  .value,
                              onChanged: (data) {
                                getDepartmentHeaderWithoutPostionController
                                        .selectedManager
                                        .value =
                                    data;
                              },
                            );
                          }),

                          SizedBox(height: context.screenHeight * 0.02),

                          Align(
                            alignment: Alignment.center,
                            child: CustomMainButtom(
                              title: 'تأكيد',
                              color: constBlue,
                              fontcolor: Colors.white,
                              onPressed: () async {
                                // ✅ فحص الفورم أولاً
                                if (!departmentsSheetKey.currentState!
                                    .validate()) {
                                  return;
                                }

                                final department = getDepartmentsController
                                    .selectedDepartment
                                    .value;
                                final manager =
                                    getDepartmentHeaderWithoutPostionController
                                        .selectedManager
                                        .value;

                                // احتياطي إضافي (نادراً ما يصير لو validate نجح)
                                if (department == null || manager == null)
                                  return;

                                Get.back();
                                showLoadingDialog();

                                final success =
                                    await AssignDepartmentManagerService()
                                        .assignManager(
                                          departmentId: department.id,
                                          managerId: manager.id,
                                        );

                                hideLoadingDialog();

                                if (success) {
                                  customSnackBar(
                                    title: 'تم بنجاح',
                                    message: 'تم ربط القسم بالمدير بنجاح',
                                    color: constGreen,
                                    messageColor: constLightGreen,
                                  );
                                  getDepartmentHeaderWithoutPostionController
                                      .fetchManagers();
                                  getUsersListController.refreshUsers();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'assignManagerBtn',
            backgroundColor: constGreen,
            onPressed: () => _openAssignDoctorSheet(context), // ✅ الاسم الجديد
            child: const Icon(
              Icons.medical_services_outlined,
              color: Colors.white,
            ), // ✅ أيقونة أنسب (اختياري)
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'departmentsBtn',
            backgroundColor: constGreen,
            onPressed: () => _openDepartmentsSheet(context),
            child: const Icon(Icons.business_outlined, color: Colors.white),
          ),
          SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'addUserBtn',
            backgroundColor: constBlue,
            onPressed: () => _openCreateUserSheet(context),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          CustomBackContainer(),
          CustomHeadContainer(title: 'الموظفين'),
          Expanded(
            child: GetBuilder<GetUsersListController>(
              builder: (controller) {
                if (controller.users == null) {
                  return const Center(child: CustomLoadingIndicator());
                }

                // ← RefreshIndicator يلف CustomScrollView كامل بدل ListView
                // لحاله، هيك السحب يشتغل من أي مكان بالصفحة وحتى لو فاضية
                return RefreshIndicator(
                  onRefresh: controller.refreshUsers,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      if (controller.users!.isEmpty)
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: CustomEmptyState(
                            tital: 'لا يوجد موظفين لعرضهم',
                          ),
                        )
                      else
                        SliverPadding(
                          padding: EdgeInsets.only(
                            top: 0,
                            bottom: context.screenHeight * 0.01,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate((
                              context,
                              index,
                            ) {
                              return GestureDetector(
                                onTap: () {
                                  CustomDialog.show(
                                    title: 'تغير حالة الموظف',
                                    message:
                                        controller.users![index].status ==
                                            UserStatus.active
                                        ? 'هل تريدالغاء تنشيط الموظف'
                                        : 'هل اعادة تنشيط الموظف',
                                    onCancel: () {
                                      Get.back();
                                    },
                                    onConfirm: () async {
                                      Get.back(); // ← سكر ديالوج التأكيد أولاً
                                      showLoadingDialog();

                                      final success =
                                          await UpdateUserStatusService()
                                              .updateUserStatus(
                                                userId:
                                                    controller.users![index].id,
                                                status:
                                                    controller
                                                            .users![index]
                                                            .status ==
                                                        UserStatus.active
                                                    ? 'inactive'
                                                    : 'active',
                                              );

                                      hideLoadingDialog(); // ← بيتسكر بكل الحالات

                                      if (success) {
                                        getUsersListController.refreshUsers();
                                      }
                                    },
                                  );
                                },
                                child: CustomUserContainer(
                                  userItem: controller.users![index],
                                ),
                              );
                            }, childCount: controller.users!.length),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
