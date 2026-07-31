import 'package:flutter/material.dart';
import 'package:stock_mate_project/View/Screens/OnBording/Widgets/Custom_View_Component.dart';

// ignore: must_be_immutable
class CustomAppPageView extends StatelessWidget {
  CustomAppPageView({super.key, @required this.pageController});
  PageController? pageController;
  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      children: [
        CustomViewComponent(
          imagePath: 'assets/Image/Login.png',
          title: 'أهلاً بك في StockMate',
          text:
              'إدارة ذكية وشاملة لمستودع مستشفى الهلال الأحمر الطبي  — كل ما تحتاجه لمتابعة المخزون في مكان واحد',
        ),
        CustomViewComponent(
          imagePath: 'assets/Image/Analysis-bro.png',
          title: 'بيانات تتحدث   وقرارات أدق',
          text:
              'تحليل أنماط الاستهلاك لمساعدتك على التنبؤ بالاحتياجات المستقبلية وتجنب النقص أو الفائض',
        ),
        CustomViewComponent(
          imagePath: 'assets/Image/dataanalysis.png',
          title: 'حماية كاملة لمواردك',
          text:
              'ظام ذكي يراقب الحركات غير الطبيعية ويكشف أي تلاعب أو تجاوزات في المخزون فور حدوثها',
        ),
        CustomViewComponent(
          imagePath: 'assets/Image/chat.png',
          title: 'مساعدك الذكي دائماً بجانبك',
          text:
              ' اسأل، استفسر، واحصل على إجابات فورية حول النظام من خلال مساعد ذكي يفهم احتياجاتك',
        ),
      ],
    );
  }
}
