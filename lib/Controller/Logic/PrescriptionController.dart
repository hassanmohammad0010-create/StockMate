// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/PrescriptionModel.dart';
import 'package:stock_mate_project/main.dart';

class PrescriptionController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final patientNameController = TextEditingController();
  final doctorNameController = TextEditingController();
  final conditionController = TextEditingController();
  final medicationsController = TextEditingController();

  static const String _storageKey = 'archived_prescriptions';

  final RxList<PrescriptionModel> archivedPrescriptions = <PrescriptionModel>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPrescriptions();
  }

  Future<void> _loadPrescriptions() async {
    final raw = shareprefs?.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      final List decoded = jsonDecode(raw);
      archivedPrescriptions.assignAll(
        decoded.map((e) => PrescriptionModel.fromJson(e)).toList(),
      );
    }
  }

  Future<void> _savePrescriptions() async {
    final encoded = jsonEncode(
      archivedPrescriptions.map((e) => e.toJson()).toList(),
    );
    await shareprefs?.setString(_storageKey, encoded);
  }

  void addPrescriptionToArchive() {
    final newPrescription = PrescriptionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      patientName: patientNameController.text.trim(),
      doctorName: doctorNameController.text.trim(),
      condition: conditionController.text.trim(),
      medications: medicationsController.text.trim(),
      date: DateTime.now(),
    );

    archivedPrescriptions.insert(0, newPrescription);
    _savePrescriptions();

    // TODO: إرسال الوصفة إلى الباك اند ليصل إلى صيدلية المشفى — سيتم تنفيذها لاحقاً
    // _sendPrescriptionToBackend(newPrescription);
  }

  void deletePrescription(String id) {
    archivedPrescriptions.removeWhere((p) => p.id == id);
    _savePrescriptions();
  }

  String _normalizeArabic(String text) {
    return text
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  List<PrescriptionModel> get filteredPrescriptions {
    if (searchQuery.value.trim().isEmpty) return archivedPrescriptions;
    final query = _normalizeArabic(searchQuery.value.trim().toLowerCase());
    return archivedPrescriptions
        .where((p) => _normalizeArabic(p.patientName.toLowerCase()).contains(query))
        .toList();
  }

  void clearFields() {
    patientNameController.clear();
    doctorNameController.clear();
    conditionController.clear();
    medicationsController.clear();
  }

  @override
  void onClose() {
    patientNameController.dispose();
    doctorNameController.dispose();
    conditionController.dispose();
    medicationsController.dispose();
    super.onClose();
  }
}