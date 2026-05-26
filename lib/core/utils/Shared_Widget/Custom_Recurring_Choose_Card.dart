// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomRecurringChooseCard extends StatelessWidget {
  const CustomRecurringChooseCard({super.key});

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.27,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text('يومي', style: TextStyle(color: Colors.grey,fontFamily: 'Cairo')),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.27,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text('أسبوعي', style: TextStyle(color: Colors.grey,fontFamily: 'Cairo')),
                  ),
                ),
                    Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.27,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text('شهري', style: TextStyle(color: Colors.grey,fontFamily: 'Cairo')),
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
