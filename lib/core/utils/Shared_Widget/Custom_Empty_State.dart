import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomEmptyState extends StatelessWidget {
  const CustomEmptyState({super.key, required this.tital});
  final String tital;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset('assets/Image/Empty.png'),
        Text(tital, style: TextStyle(fontFamily: cairo, fontSize: 24)),
      ],
    );
  }
}
