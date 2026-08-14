import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/App/Create_User_Page_Controller.dart';
import 'package:stock_mate_project/Controller/App/Get_Departments_Controller.dart';
import 'package:stock_mate_project/Controller/App/Get_Users_List_Controller.dart';
import 'package:stock_mate_project/Controller/Loading%20Indecator%20Controller/Loading_Indicator_Controller.dart';
import 'package:stock_mate_project/Service/Boss/Create_User_Service.dart';
import 'package:stock_mate_project/Service/Boss/Get_Departments_Without_Manger_Controller.dart';
import 'package:stock_mate_project/Service/Boss/Update_UserStatus_Service.dart';
import 'package:stock_mate_project/View/Widget/App/Custom_User_Container.dart';
import 'package:stock_mate_project/core/Function/Custom_Dialog.dart';
import 'package:stock_mate_project/core/Function/Validation.dart';
import 'package:stock_mate_project/core/Function/show_Loading_Dialog.dart';
import 'package:stock_mate_project/core/models/Department_Model.dart';
import 'package:stock_mate_project/core/models/User_Model.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Dialog/Custom_Dialog.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Back_Container.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Empty_State.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Head_Card.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Loading_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Main_Buttom.dart';

class UserMangmentPage extends StatelessWidget {
  UserMangmentPage({super.key});
  final String pageName = '/CreateUserPage';
  final GlobalKey<FormState> createUserPageKey = GlobalKey();
  final LoadingIndicatorController loadingIndicatorController = Get.put(
    LoadingIndicatorController(),
  );
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController specialtyController = TextEditingController();
  Createuserpagecontroller createuserpagecontroller = Get.put(
    Createuserpagecontroller(),
  );
  final GetUsersListController getUsersListController = Get.put(
    GetUsersListController(),
  );
  final GetDepartmentsWithoutMangerController getDepartmentsController =
      Get.put(GetDepartmentsWithoutMangerController());
  String? name, email, specialty, role;
  void _openCreateUserSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // حتى يقدر يطلع فوق الكيبورد
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
                                          validator: (data) => data == null
                                              ? 'الحقل ضروري'
                                              : null,
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
                                          child: GetBuilder<LoadingIndicatorController>(
                                            builder: (controller) {
                                              return CustomMainButtom(
                                                widget:
                                                    loadingIndicatorController
                                                        .load
                                                    ? CustomLoadingIndicator(
                                                        color: constLightBlue,
                                                      )
                                                    : null,
                                                title: 'تأكيد',
                                                color: constBlue,
                                                fontcolor: Colors.white,
                                                onPressed: () async {
                                                  if (createUserPageKey
                                                      .currentState!
                                                      .validate()) {
                                                    if (createuserpagecontroller
                                                            .selectedRole
                                                            .value !=
                                                        null) {
                                                      role = createuserpagecontroller
                                                          .getRoleId(
                                                            roleName:
                                                                createuserpagecontroller
                                                                    .selectedRole
                                                                    .value!,
                                                          );
                                                      loadingIndicatorController
                                                          .isLoad();
                                                      bool response =
                                                          await UserService.createUser(
                                                            fullName: name!,
                                                            email: email!,
                                                            roleId: role!,
                                                            specialty:
                                                                specialty,
                                                          );
                                                      if (response) {
                                                        nameController.clear();
                                                        emailController.clear();
                                                        specialtyController
                                                            .clear();
                                                        createuserpagecontroller
                                                                .selectedRole
                                                                .value =
                                                            null;
                                                        name = null;
                                                        email = null;
                                                        specialty = null;
                                                        role = null;
                                                        // ✅ إغلاق الشيت + تحديث قائمة المستخدمين
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                        getUsersListController
                                                            .refreshUsers();
                                                      }
                                                      loadingIndicatorController
                                                          .isntLoad();
                                                    }
                                                  }
                                                },
                                              );
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

  void _openDepartmentsSheet(BuildContext context) {
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
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.9,
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
                              'ربط قسم مع موظف',
                              style: TextStyle(
                                color: constBlue,
                                fontFamily: lateef,
                                fontSize: context.screenHeight * 0.026,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: context.screenHeight * 0.01),

                        // ✅ الـ Dropdown بيعرض حالة التحميل لحد ما توصل البيانات
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

                          if (getDepartmentsController.departments.isEmpty) {
                            return CustomEmptyState(
                              tital: 'لا يوجد أقسام لعرضها',
                            );
                          }

                          return CustomDropdown<DepartmentModel>(
                            items: getDepartmentsController.departments,
                            labelBuilder: (d) => d.name,
                            label: 'القسم',
                            hint: '',
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

                        SizedBox(height: context.screenHeight * 0.02),

                        Align(
                          alignment: Alignment.center,
                          child: CustomMainButtom(
                            title: 'تأكيد',
                            color: constBlue,
                            fontcolor: Colors.white,
                            onPressed: () {
                              // TODO: حدد الوظيفة لاحقًا
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
            heroTag: 'confirmBtn',
            backgroundColor: constGreen,
            onPressed: () => _openDepartmentsSheet(context), // ✅
            child: const Icon(Icons.check, color: Colors.white),
          ),
          SizedBox(height: 12), // مسافة بين الزرين
          FloatingActionButton(
            heroTag: 'addUserBtn', // ✅ tag مختلف كمان
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
                if (controller.users!.isEmpty) {
                  return CustomEmptyState(tital: 'لا يوجد موظفين لعرضهم');
                }
                return RefreshIndicator(
                  onRefresh: controller.refreshUsers,
                  child: ListView.builder(
                    padding: EdgeInsets.only(
                      top: 0,
                      bottom: context.screenHeight * 0.01,
                    ),
                    itemCount: controller.users!.length,
                    itemBuilder: (context, index) {
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
                              showLoadingDialog();

                              await UpdateUserStatusService().updateUserStatus(
                                userId: controller.users![index].id,
                                status:
                                    controller.users![index].status ==
                                        UserStatus.active
                                    ? 'inactive'
                                    : 'active',
                              );
                            },
                          );
                        },
                        child: CustomUserContainer(
                          userItem: controller.users![index],
                        ),
                      );
                    },
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
