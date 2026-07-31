import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/View/Screens/OnBording/Custom_App_Page_View.dart';
import 'package:stock_mate_project/View/Screens/OnBording/Widgets/Custom_Dots_Indicator.dart';
import 'package:stock_mate_project/core/utils/Shared_Widget/Custom_Buttom.dart';

extension AppSize on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get keyboard => MediaQuery.of(this).viewInsets.bottom;
}

// ignore: must_be_immutable
class OnBordingAppViewPage extends StatefulWidget {
  OnBordingAppViewPage({super.key});
  String pageName = '/OnBordingDoctorView';
  @override
  State<OnBordingAppViewPage> createState() => _OnBordingDoctorViewPageState();
}

class _OnBordingDoctorViewPageState extends State<OnBordingAppViewPage> {
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomAppPageView(pageController: pageController),

          // مؤشر النقاط (Dots Indicator) - نسبة من ارتفاع الشاشة بدل 750 ثابتة
          Padding(
            padding: EdgeInsets.only(top: AppSize(context).screenHeight * 0.85),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CustomDotsIndicator(
                dotsIndex: pageController!.hasClients
                    ? (pageController!.page ?? 0.0)
                    : 0.0,
              ),
            ),
          ),

          // زر السهم الدائري - حجمه ومكانه نسبة من الشاشة
          Padding(
            padding: EdgeInsets.only(
              bottom: AppSize(context).screenHeight * 0.04,
              left: AppSize(context).screenWidth * 0.08,
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: AppSize(context).screenWidth * 0.18,
                height: AppSize(context).screenWidth * 0.18,
                decoration: BoxDecoration(
                  color: constLightBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.keyboard_double_arrow_left_outlined,
                  color: constBlue,
                  size: AppSize(context).screenWidth * 0.08,
                ),
              ),
            ),
          ),

          // نص "التخطي" - المسافات والخط نسبة من الشاشة
          Visibility(
            visible: pageController!.hasClients
                ? (pageController?.page == 3 ? false : true)
                : true,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: AppSize(context).screenWidth * 0.08,
                  top: AppSize(context).screenHeight * 0.06,
                ),
                child: GestureDetector(
                  onTap: () {
                    // onBordingPreferences!.setBool('1', true);
                  },
                  child: Text(
                    'التخطي',
                    style: TextStyle(
                      fontFamily: lateef,
                      fontSize: AppSize(context).screenWidth * 0.085,
                      color: constGray,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
