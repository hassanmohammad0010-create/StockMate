// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_My_DropDown.dart';
// import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_My_TextFormFaild.dart';

// class CustomAddNewOrderCard extends StatelessWidget {
//   const CustomAddNewOrderCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ignore: sized_box_for_whitespace
//     return  Container(
//             width: MediaQuery.of(context).size.width * 0.95,
//             height: MediaQuery.of(context).size.height * 0.4,
//             child: Card(
//               child: Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 16, top: 12),
//                       child: Text(
//                         'تفاصيل الطلب',
//                         style: TextStyle(fontSize: 20, fontFamily: 'Cairo'),
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: MediaQuery.of(context).size.width * 0.03,
//                     ),
//                     child: Divider(),
//                   ),
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: MediaQuery.of(context).size.width * 0.03,
//                     ),
//                     child: CustomDropdown(
//                       items: ['Apple', 'Banana', 'Cherry'],
//                       labelBuilder: (v) => v,
//                       label: 'اسم المادة',
//                       hint: 'المادة المطلوبة',
//                       searchable: true,
//                       onChanged: (value) => {},
//                     ),
//                   ),
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.015),

//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: MediaQuery.of(context).size.width * 0.03,
//                     ),
//                     child: CustomMyTextFormField(
//                       keyboardType: TextInputType.number,
//                       label: 'الكمية',
//                       hint: 'ادخل الكمية المطلوبة',
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'الرجاء ادخال الكمية';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.015),

//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: MediaQuery.of(context).size.width * 0.03,
//                     ),
//                     child: CustomDropdown(
//                       items: ['Apple', 'Banana', 'Cherry'],
//                       labelBuilder: (v) => v,
//                       label: 'الوكيل / الماركة',
//                       hint: 'اختر الوكيل / الماركة',
//                       searchable: true,
//                       onChanged: (value) => {},
//                     ),
//                   ),
//                   SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//                 ],
//               ),
//             ),
//           );
//   }
// }


// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_My_DropDown.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_My_TextFormFaild.dart';

class CustomAddNewOrderCard extends StatelessWidget {
  const CustomAddNewOrderCard({
    super.key,
    required this.order, // ← استقبل الـ order
  });

  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Card(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 12),
                child: Text(
                  'تفاصيل الطلب',
                  style: TextStyle(fontSize: 20, fontFamily: 'Cairo'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: const Divider(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            // ─── اسم المادة ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: CustomDropdown(
                items: ['Apple', 'Banana', 'Cherry'],
                labelBuilder: (v) => v,
                label: 'اسم المادة',
                hint: 'المادة المطلوبة',
                searchable: true,
                onChanged: (value) {
                  if (value != null) order.medicine.value = value; // ← احفظ القيمة
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),

            // ─── الكمية ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: CustomMyTextFormField(
                keyboardType: TextInputType.number,
                label: 'الكمية',
                hint: 'ادخل الكمية المطلوبة',
                onChanged: (value) {
                  order.quantity.value = int.tryParse(value) ?? 1; // ← احفظ القيمة
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء ادخال الكمية';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.015),

            // ─── الوكيل / الماركة ───
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: CustomDropdown(
                items: ['Apple', 'Banana', 'Cherry'],
                labelBuilder: (v) => v,
                label: 'الوكيل / الماركة',
                hint: 'اختر الوكيل / الماركة',
                searchable: true,
                onChanged: (value) {
                  if (value != null) order.medicine.value = value; // ← احفظ القيمة
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}