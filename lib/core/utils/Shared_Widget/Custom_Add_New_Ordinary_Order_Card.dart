// ignore_for_file: sized_box_for_whitespace, file_names

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_My_DropDown.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_My_TextFormFaild.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Priority_Choose_Card.dart';

class OrdinaryOrderCard extends StatelessWidget {
  const OrdinaryOrderCard({super.key, required this.orderIndex});

  final int orderIndex;

  AddOrdinaryOrderController get _c => Get.find<AddOrdinaryOrderController>();

  static const List<String> _medicines = [
    'باراسيتامول',
    'أموكسيسيلين',
    'إيبوبروفين',
    'أزيثروميسين',
    'فلام-ك',
  ];

  static const List<String> _units = ['قطعة', 'لتر', 'كيلوغرام', 'كيت (دزينة)'];

  static const List<String> _brands = [
    'شركة تاميكو',
    'شركة فارما',
    'الشركة الطبية السورية',
  ];

  @override
  Widget build(BuildContext context) {
    if (orderIndex >= _c.orders.length) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.008),
                  Form(
                    key: _c.formKey(orderIndex),
                    child: Container(
                      // height: size.height * 0.48,
                      width: size.width * 0.95,
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // عنوان الكارد
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                  top: 12,
                                ),
                                child: Text(
                                  'تفاصيل الطلب ${orderIndex + 1}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                              ),
                              child: const Divider(),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Obx(() {
                              if (orderIndex >= _c.orders.length) {
                                return const SizedBox.shrink();
                              }
                              final isInvalid = _c.isFieldInvalid(
                                orderIndex,
                                'medicineName',
                              );
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdown<String>(
                                      items: _medicines,
                                      labelBuilder: (v) => v,
                                      label: 'اسم الدواء *',
                                      hint: 'اختر الدواء المطلوب',
                                      searchable: true,
                                      value: _c.orders[orderIndex].medicineName,
                                      // نمرر errorBorder للـ dropdown إذا كان invalid
                                      errorBorder: isInvalid,
                                      onChanged: (v) =>
                                          _c.updateMedicineName(orderIndex, v),
                                    ),
                                    if (isInvalid)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          top: 4,
                                        ),
                                        child: Text(
                                          'الرجاء اختيار اسم الدواء',
                                          style: TextStyle(
                                            color: constRed,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: size.height * 0.015),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.03,
                              ),
                              child: CustomMyTextFormField(
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
                            SizedBox(height: size.height * 0.015),
                            Obx(() {
                              if (orderIndex >= _c.orders.length) {
                                return const SizedBox.shrink();
                              }
                              final isInvalid = _c.isFieldInvalid(
                                orderIndex,
                                'unit',
                              );
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdown<String>(
                                      items: _units,
                                      labelBuilder: (v) => v,
                                      label: 'الوحدة *',
                                      hint: 'اختر الوحدة',
                                      searchable: false,
                                      value: _c.orders[orderIndex].unit,
                                      errorBorder: isInvalid,
                                      onChanged: (v) =>
                                          _c.updateUnit(orderIndex, v),
                                    ),
                                    if (isInvalid)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          top: 4,
                                        ),
                                        child: Text(
                                          'الرجاء اختيار الوحدة',
                                          style: TextStyle(
                                            color: constRed,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),
                            SizedBox(height: size.height * 0.015),
                            Obx(() {
                              if (orderIndex >= _c.orders.length) {
                                return const SizedBox.shrink();
                              }
                              final isInvalid = _c.isFieldInvalid(
                                orderIndex,
                                'brand',
                              );
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.03,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomDropdown<String>(
                                      items: _brands,
                                      labelBuilder: (v) => v,
                                      label: 'الوكيل / الماركة *',
                                      hint: 'اختر الوكيل / الماركة',
                                      searchable: true,
                                      value: _c.orders[orderIndex].brand,
                                      errorBorder: isInvalid,
                                      onChanged: (v) =>
                                          _c.updateBrand(orderIndex, v),
                                    ),
                                    if (isInvalid)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          right: 12,
                                          top: 4,
                                        ),
                                        child: Text(
                                          'الرجاء اختيار الوكيل / الماركة',
                                          style: TextStyle(
                                            color: constRed,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }),

                            SizedBox(height: size.height * 0.015),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.008),
                  PriorityChooseCard(orderIndex: orderIndex),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
