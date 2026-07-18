// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:get/instance_manager.dart';
// import 'package:stock_mate_project/Constant/Const.dart';
// import 'package:stock_mate_project/Controller/Logic/Filter_Controller.dart';
// import 'package:stock_mate_project/core/router/app_routes.dart';

// class CustomSearchField extends StatelessWidget {
//   CustomSearchField({super.key});

//   final FilterController filterController = Get.find(
//     tag: AppRoutes.DepartmentHeadsInventoryPage,
//   );

//   final TextEditingController _searchController = TextEditingController();
//   String normalizeArabic(String text) {
//     return text
//         .replaceAll('أ', 'ا')
//         .replaceAll('إ', 'ا')
//         .replaceAll('آ', 'ا')
//         .replaceAll('ة', 'ه')
//         .replaceAll('ى', 'ي');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final h = context.screenHeight;
//     final w = context.screenWidth;

//     return Padding(
//       padding: EdgeInsets.only(
//         left: w * 0.03,
//         right: w * 0.03,
//         top: h * 0.005,
//         bottom: h * 0.01,
//       ),
//       child: TextField(
//         controller: _searchController,
//         textDirection: TextDirection.rtl,
//         onChanged: (value) => filterController.updateSearch(value),
//         style: TextStyle(fontFamily: cairo, fontSize: 14),
//         decoration: InputDecoration(
//           hintText: 'ابحث بالاسم أو الرقم  .....',
//           hintStyle: TextStyle(
//             fontFamily: cairo,
//             fontSize: 14,
//             color: Colors.grey.shade400,
//           ),
//           hintTextDirection: TextDirection.rtl,
//           prefixIcon: Icon(
//             Icons.search_rounded,
//             color: Colors.grey.shade400,
//             size: 22,
//           ),
//           suffixIcon: Obx(
//             () => filterController.searchQuery.value.isNotEmpty
//                 ? GestureDetector(
//                     onTap: () {
//                       _searchController.clear();
//                       filterController.updateSearch('');
//                     },
//                     child: Icon(
//                       Icons.close_rounded,
//                       color: Colors.grey.shade400,
//                       size: 20,
//                     ),
//                   )
//                 : const SizedBox.shrink(),
//           ),
//           filled: true,
//           fillColor: Colors.grey.shade100,
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: w * 0.04,
//             vertical: h * 0.015,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade200),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.grey.shade200),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: constBlue, width: 1.5),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
//           const SizedBox(height: 16),
//           Text(
//             'لا توجد نتائج',
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.grey.shade500,
//               fontFamily: cairo,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'جرّب كلمة بحث مختلفة',
//             style: TextStyle(
//               fontSize: 13,
//               color: Colors.grey.shade400,
//               fontFamily: cairo,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stock_mate_project/Constant/Const.dart';

/// دالة عامة لتوحيد الحروف العربية المتشابهة (أ/إ/آ -> ا، ة -> ه، ى -> ي)
/// عشان تستخدمها أي صفحة عند الفلترة أو المقارنة، بدون علاقة بالويدجت.
String normalizeArabic(String text) {
  return text
      .replaceAll('أ', 'ا')
      .replaceAll('إ', 'ا')
      .replaceAll('آ', 'ا')
      .replaceAll('ة', 'ه')
      .replaceAll('ى', 'ي');
}

/// حقل بحث عام وقابل لإعادة الاستخدام.
/// لا يعرف أي شيء عن FilterController أو GetX أو أي صفحة معيّنة.
/// كل ما يحتاجه يُمرَّر من الخارج عند الاستدعاء.
class CustomSearchField extends StatefulWidget {
  const CustomSearchField({
    super.key,
    required this.controller,
    this.onChanged,
    this.onClear,
    this.onSubmitted,
    this.focusNode,
    this.hintText = 'ابحث بالاسم أو الرقم  .....',
    this.textDirection = TextDirection.rtl,
    this.autofocus = false,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 12,
    this.padding,
    this.textStyle,
    this.hintStyle,
  });

  /// الكونترولر يُمرَّر من الصفحة المستدعية (مطلوب).
  final TextEditingController controller;

  /// يُستدعى مع كل تغيير في النص.
  final ValueChanged<String>? onChanged;

  /// يُستدعى إضافياً عند الضغط على زر المسح (بعد تصفير الكونترولر واستدعاء onChanged('')).
  final VoidCallback? onClear;

  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;

  final String hintText;
  final TextDirection textDirection;
  final bool autofocus;

  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  void initState() {
    super.initState();
    // نستمع للكونترولر نفسه عشان نظهر/نخفي زر المسح
    // بدون أي اعتماد على أي state management خارجي.
    widget.controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant CustomSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    // لإعادة بناء الويدجت فقط عشان يظهر/يختفي زر المسح
    setState(() {});
  }

  void _handleClear() {
    widget.controller.clear();
    widget.onChanged?.call('');
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final h = context.screenHeight;
    final w = context.screenWidth;
    final hasText = widget.controller.text.isNotEmpty;

    return Padding(
      padding: widget.padding ??
          EdgeInsets.only(
            left: w * 0.03,
            right: w * 0.03,
            top: h * 0.005,
            bottom: h * 0.01,
          ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        textDirection: widget.textDirection,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: widget.textStyle ??  TextStyle(fontFamily: cairo, fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              TextStyle(
                fontFamily: cairo,
                fontSize: 14,
                color: Colors.grey.shade400,
              ),
          hintTextDirection: widget.textDirection,
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade400,
            size: 22,
          ),
          suffixIcon: hasText
              ? GestureDetector(
                  onTap: _handleClear,
                  child: Icon(
                    Icons.close_rounded,
                    color: Colors.grey.shade400,
                    size: 20,
                  ),
                )
              : const SizedBox.shrink(),
          filled: true,
          fillColor: widget.fillColor ?? Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * 0.04,
            vertical: h * 0.015,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.borderColor ?? Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.borderColor ?? Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color: widget.focusedBorderColor ?? constBlue, width: 1.5),
          ),
        ),
      ),
    );
  }
}

/// حالة "لا توجد نتائج" فُصلت كويدجت مستقل لأنها لا تعتمد على الكونترولر
/// أو أي بيانات، فتقدر تستخدمها في أي مكان بدون علاقة بحقل البحث.
class SearchEmptyState extends StatelessWidget {
  const SearchEmptyState({
    super.key,
    this.title = 'لا توجد نتائج',
    this.subtitle = 'جرّب كلمة بحث مختلفة',
    this.icon = Icons.search_off_rounded,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade500,
              fontFamily: cairo,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade400,
              fontFamily: cairo,
            ),
          ),
        ],
      ),
    );
  }
}