// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomPriorityChooseCard extends StatelessWidget {
  const CustomPriorityChooseCard({super.key});

  @override
  Widget build(BuildContext context) {
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
                  'الأولوية',
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    border: Border.all(color: constRed),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text('ضروري', style: TextStyle(color: constRed,fontFamily: 'Cairo')),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.4,
                  decoration: BoxDecoration(
                    border: Border.all(color: constBlue),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text('عادي', style: TextStyle(color: constBlue,fontFamily: 'Cairo')),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          ],
        ),
      ),
    );
  }
}
