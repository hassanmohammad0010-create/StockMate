import 'package:get/get.dart';

class Validation {
  emailValidate(String email) {
    if (email.isEmpty) {
      return 'الحقل ضروري';
    } else if (!GetUtils.isEmail(email) || !email.endsWith('@gmail.com')) {
      return 'البريد غير صالح';
    } else if (email.length < 5) {
      return 'لا يمكن ان يكون اقل من خمسة احرف';
    } else if (email.length > 30) {
      return 'لا يمكن ان يكون اكثر من 30 حرف';
    } else {
      return null;
    }
  }

  passwordValidator(String password) {
    if (password.isEmpty) {
      return 'الحقل ضروري';
    } else if (password.length < 6) {
      return "لا يمكن ان يكون اقل من 6 احرف";
    } else if (password.length > 20) {
      return "لا يمكن ان يكون اكثر من 20 حرف";
    }
    return null;
  }

  nameValidator(String name) {
    if (name.isEmpty) {
      return 'الحقل ضروري';
    } else if (!GetUtils.isUsername(name)) {
      return 'الاسم غير صالح';
    } else {
      return null;
    }
  }

  generalValidation(String data) {
    if (data.isEmpty) {
      return 'الحقل ضروري';
    } else {
      return null;
    }
  }
}
