// ignore_for_file: sized_box_for_whitespace, file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Drop_Down/Custom_My_Drop_Down.dart';
import 'package:stock_mate_project/core/utils/Departments_Heads/Custom_Text_Field/Custom_My_TextFormFaild.dart';

class OrdinaryOrderCard extends StatelessWidget {
  const OrdinaryOrderCard({super.key, required this.orderIndex});

  final int orderIndex;

  AddOrdinaryOrderController get _c => Get.find<AddOrdinaryOrderController>();

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;

    if (orderIndex >= _c.orders.length) return const SizedBox.shrink();

    // ✅ تم حذف LayoutBuilder + IntrinsicHeight + ConstrainedBox(minHeight)
    // كانوا بيجبروا Flutter يحسب الـ layout مرتين لكل الأطفال (double layout pass)،
    // وده بيتكرر في كل frame وقت ظهور/اختفاء الكيبورد بسبب resizeToAvoidBottomInset،
    // وهو السبب الرئيسي في إحساس "الثقل" و"البطء".
    // SingleChildScrollView وحده كافي هنا لأن مفيش داعي فعلي لفرض ارتفاع أدنى.
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          SizedBox(height: h * 0.008),
          Form(
            key: _c.formKey(orderIndex),
            child: Container(
              width: w * 0.95,
              child: Card(
                color: Colors.white.withOpacity(0.9),
                elevation: 3.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: w * 0.05,
                          top: h * 0.015,
                        ),
                        child: Text(
                          _c.orders.length > 1
                              ? 'تفاصيل الطلب ${orderIndex + 1}'
                              : 'تفاصيل الطلب',
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: const Divider(),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.006,
                      ),
                      child: Text(
                        'اختر المادة المطلوية:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    // ─── Dropdown الأدوية ─────────
                    Obx(() {
                      if (orderIndex >= _c.orders.length) {
                        return const SizedBox.shrink();
                      }

                      // ✅ حالات الخطأ والتحميل
                      final hasError = _c.medicinesError.value.isNotEmpty;
                      final errorMsg = _c.medicinesError.value;

                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                        child: CustomDropdown<String>(
                          items: _c.medicineNames,
                          isLoading: _c.isMedicinesLoading.value,
                          hasError: hasError,
                          errorMessage: errorMsg,
                          onRetry: () => _c.fetchMedicines(),
                          labelBuilder: (v) => v,
                          label: 'اسم الدواء *',
                          hint: 'اختر الدواء المطلوب',
                          icon: Icons.medication_outlined,
                          searchable: true,
                          value: _c.orders[orderIndex].selectedMedicine?.name,
                          validator: (v) =>
                              v == null ? 'الرجاء اختيار اسم الدواء' : null,
                          onChanged: (v) =>
                              _c.updateMedicineName(orderIndex, v),
                        ),
                      );
                    }),
                    SizedBox(height: h * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: w * 0.04,
                        vertical: h * 0.006,
                      ),
                      child: Text(
                        'ادخل الكمية المطلوبة:',
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w * 0.03),
                      child: CustomMyTextFormField(
                        prefixIcon: Icons.numbers_outlined,
                        keyboardType: TextInputType.number,
                        label: 'الكمية *',
                        hint: 'أدخل الكمية المطلوبة',
                        controller: _c.quantityCtrl(orderIndex),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'الرجاء إدخال الكمية';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: h * 0.03),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: h * 0.008),
        ],
      ),
    );
  }
}
