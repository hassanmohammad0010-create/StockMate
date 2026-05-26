import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomMainButtom extends StatelessWidget {
  const CustomMainButtom({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return   Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: constBlue,
                  ),
                  child: MaterialButton(
                    onPressed: () {},
                    child: Text(title, style: TextStyle(color: Colors.white,fontFamily: 'Cairo')),
                  ),
                );
  }
}