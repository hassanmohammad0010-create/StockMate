// // ignore_for_file: file_names

// import 'package:flutter/material.dart';

// class CustomRecurringChooseCard extends StatelessWidget {
//   const CustomRecurringChooseCard({super.key});

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
//                   'التكرار',
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
//                   width: MediaQuery.of(context).size.width * 0.27,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     child: Text('يومي', style: TextStyle(color: Colors.grey,fontFamily: 'Cairo')),
//                   ),
//                 ),
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.05,
//                   width: MediaQuery.of(context).size.width * 0.27,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     child: Text('أسبوعي', style: TextStyle(color: Colors.grey,fontFamily: 'Cairo')),
//                   ),
//                 ),
//                     Container(
//                   height: MediaQuery.of(context).size.height * 0.05,
//                   width: MediaQuery.of(context).size.width * 0.27,
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: MaterialButton(
//                     onPressed: () {},
//                     child: Text('شهري', style: TextStyle(color: Colors.grey,fontFamily: 'Cairo')),
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
import 'package:stock_mate_project/Controller/Logic/Recurring_Controller.dart';


class CustomRecurringChooseCard extends StatelessWidget {
  const CustomRecurringChooseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final RecurringController controller = Get.put(RecurringController());

    final List<Map<String, String>> options = [
      {'label': 'يومي', 'value': 'daily'},
      {'label': 'أسبوعي', 'value': 'weekly'},
      {'label': 'شهري', 'value': 'monthly'},
    ];

    // ignore: sized_box_for_whitespace
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.15,
      child: Card(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16, top: 12),
                child: Text(
                  'التكرار',
                  style: TextStyle(fontSize: 20, fontFamily: 'Cairo'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03,
              ),
              child: Divider(),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: options.map((option) {
                  final bool isSelected =
                      controller.selectedRecurring.value == option['value'];

                  return GestureDetector(
                    onTap: () => controller.selectRecurring(option['value']!),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.27,
                      decoration: BoxDecoration(
                        color: isSelected ? constBlue : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? constBlue : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        option['label']!,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}