import 'dart:async';
import 'dart:io';

import 'package:stock_mate_project/Constant/Const.dart';
import 'package:stock_mate_project/core/Function/Custom_Snakbar.dart';

class ApiErrorHandler {
  /// يعالج الاستثناءات الشائعة (Socket, Timeout, Format, غيرها)
  /// استخدمها جوا catch blocks
  static void handleException(Object error) {
    if (error is SocketException) {
      customSnackBar(
        title: 'لا يوجد اتصال',
        message: 'تأكد من اتصالك بالانترنت وحاول مرة أخرى',
        color: constRed,
        messageColor: constLightRed,
      );
    } else if (error is TimeoutException) {
      customSnackBar(
        title: 'انتهت المهلة',
        message: 'الخادم لا يستجيب، حاول لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
    } else if (error is FormatException) {
      customSnackBar(
        title: 'خطأ في البيانات',
        message: 'حدث خطأ غير متوقع في استجابة الخادم',
        color: constRed,
        messageColor: constLightRed,
      );
    } else {
      customSnackBar(
        title: 'حدث خطأ',
        message: 'الرجاء المحاولة لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }

  /// يعالج status codes غير الناجحة (غير 200)
  static void handleStatusCode(int statusCode) {
    if (statusCode == 401 || statusCode == 403) {
      customSnackBar(
        title: 'انتهت الجلسة',
        message: 'الرجاء تسجيل الدخول من جديد',
        color: constRed,
        messageColor: constLightRed,
      );
    } else if (statusCode == 404) {
      customSnackBar(
        title: 'غير موجود',
        message: 'البيانات المطلوبة غير موجودة',
        color: constRed,
        messageColor: constLightRed,
      );
    } else if (statusCode == 409) {
      customSnackBar(
        title: 'خطأ ادخال',
        message: 'البيانات المدخلة موجودة بالفعل',
        color: constRed,
        messageColor: constLightRed,
      );
    } else if (statusCode == 429) {
      customSnackBar(
        title: 'طلبات كثيرة',
        message:
            'تم إرسال عدد كبير من الطلبات، الرجاء الانتظار دقيقة والمحاولة مرة أخرى',
        color: constRed,
        messageColor: constLightRed,
      );
    } else if (statusCode >= 500) {
      customSnackBar(
        title: 'خطأ في الخادم',
        message: 'حدث خطأ من جهة الخادم، حاول لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
    } else {
      customSnackBar(
        title: 'حدث خطأ',
        message: 'الرجاء التحقق من اتصالك بالانترنت والمحاولة لاحقاً',
        color: constRed,
        messageColor: constLightRed,
      );
    }
  }
}
