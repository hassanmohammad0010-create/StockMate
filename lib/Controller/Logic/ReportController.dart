// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportController extends GetxController {
 final formKey = GlobalKey<FormState>();
 final reportTitle = TextEditingController();
final description = TextEditingController();

void clearFields() {
  reportTitle.clear();
  description.clear();
}

@override
void onClose() {
  reportTitle.dispose();
  description.dispose();
  super.onClose();
}
}