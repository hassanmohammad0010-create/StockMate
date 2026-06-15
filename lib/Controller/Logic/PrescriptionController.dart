// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrescriptionController extends GetxController {
 final formKey = GlobalKey<FormState>();

final patientNameController = TextEditingController();
final doctorNameController = TextEditingController();
final medicationsController = TextEditingController();

void clearFields() {
  patientNameController.clear();
  doctorNameController.clear();
  medicationsController.clear();
}

@override
void onClose() {
  patientNameController.dispose();
  doctorNameController.dispose();
  medicationsController.dispose();
  super.onClose();
}
}