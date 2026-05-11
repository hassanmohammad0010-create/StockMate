import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/Controller/Auth/Splash_View_Controller.dart';

class SplashViewPage extends StatelessWidget {
  SplashViewPage({super.key});
  final String pageName = '/SplashViewPage';
  final SplashViewController splashViewController = Get.put(
    SplashViewController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constColor,
      body: GetBuilder<SplashViewController>(
        builder: (controller) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  constDarkBlue, // top blue
                  constColor, // bottom dark navy
                ],
              ),
            ),
            child: Center(child: Image.asset(fullLogo)),
          );
        },
      ),
    );
  }
}
