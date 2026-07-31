import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:stock_mate_project/Constant/Const.dart';

class CustomDotsIndicator extends StatelessWidget {
  const CustomDotsIndicator({super.key, required this.dotsIndex});
  final double dotsIndex;

  @override
  Widget build(BuildContext context) {
    return DotsIndicator(
      decorator: DotsDecorator(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: constColor),
        ),
        activeColor: constBlue,
        color: constLightBlue,
      ),
      dotsCount: 4,
      position: dotsIndex,
    );
  }
}
