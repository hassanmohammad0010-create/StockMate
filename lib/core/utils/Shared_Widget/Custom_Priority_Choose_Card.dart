// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:stock_mate_project/Constant/Const.dart';

// class CustomPriorityChooseCard extends StatelessWidget {
//   const CustomPriorityChooseCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // ignore: sized_box_for_whitespace
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.95,
//       height: MediaQuery.of(context).size.height * 0.15,
//       child: Card(
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.centerRight,
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 16, top: 12),
//                 child: Text(
//                   'الأولوية',
//                   style: TextStyle(fontSize: 20, fontFamily: 'Cairo'),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 horizontal: MediaQuery.of(context).size.width * 0.03,
//               ),
//               child: Divider(),
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.01),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.05,
//                   width: MediaQuery.of(context).size.width * 0.3,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: constRed),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     child: Text('ضروري', style: TextStyle(color: constRed,fontFamily: 'Cairo')),
//                   ),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.05,
//                   width: MediaQuery.of(context).size.width * 0.3,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: constBlue),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     child: Text('عادي', style: TextStyle(color: constBlue,fontFamily: 'Cairo')),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.01),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Logic/AddOrdinaryOrder_Controller.dart';

class CustomPriorityChooseCard extends StatelessWidget {
  const CustomPriorityChooseCard({
    super.key,
    required this.order, // استقبل الطلب مباشرة
  });

  final OrderItem order;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.95,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // ─── العنوان ───
              const Padding(
                padding: EdgeInsets.only(left: 252, top: 12),
                child: Text(
                  'الأولوية',
                  style: TextStyle(fontSize: 20, fontFamily: 'Cairo'),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03,
                ),
                child: const Divider(),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              // ─── الأزرار ───
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _PriorityButton(
                    label: 'ضروري',
                    activeColor: constRed,
                    isSelected: order.priority.value == 'ضروري',
                    onTap: () => order.priority.value = 'ضروري',
                  ),
                  _PriorityButton(
                    label: 'عادي',
                    activeColor: constBlue,
                    isSelected: order.priority.value == 'عادي',
                    onTap: () => order.priority.value = 'عادي',
                  ),
                ],
              )),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── زر الأولوية ───
class _PriorityButton extends StatelessWidget {
  const _PriorityButton({
    required this.label,
    required this.activeColor,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final Color activeColor;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          // اذا محدد: لون كامل — اذا غير محدد: شفاف مع border فقط
          color: isSelected ? activeColor : Colors.transparent,
          border: Border.all(color: activeColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
              // اذا محدد: النص أبيض — اذا غير محدد: لون الـ border
              color: isSelected ? Colors.white : activeColor,
            ),
          ),
        ),
      ),
    );
  }
}