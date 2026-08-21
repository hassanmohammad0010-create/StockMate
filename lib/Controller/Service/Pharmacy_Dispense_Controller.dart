// ignore_for_file: file_names

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:stock_mate_project/core/models/Dispense_Queue_Item.dart';
import 'package:stock_mate_project/Service/Head%20of%20department/Get_Dispense_Queue_Service.dart';

class PharmacyDispenseController extends GetxController {
  PharmacyDispenseController({this.statuses});

  final List<String>? statuses;

  final GetDispenseQueueService _queueService = GetDispenseQueueService();

  final RxList<DispenseQueueItem> prescriptions = <DispenseQueueItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  final RxInt total = 0.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;

  bool get hasMore => currentPage.value < totalPages.value;

  final ScrollController scrollController = ScrollController();

  static const double _scrollThreshold = 200.0;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
    fetchPrescriptions();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;

    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.position.pixels;

    if (currentScroll >= maxScroll - _scrollThreshold) {
      loadMore();
    }
  }

  List<String> get _activeStatuses => statuses ?? ['ready'];

  Future<void> fetchPrescriptions({int page = 1}) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final allItems = <DispenseQueueItem>[];
      int maxTotal = 0;
      int maxTotalPages = 1;

      for (final status in _activeStatuses) {
        final result = await _queueService.getDispenseQueue(
          status: status,
          page: page,
        );

        if (result != null) {
          allItems.addAll(result.items);
          maxTotal += result.total;
          if (result.totalPages > maxTotalPages) {
            maxTotalPages = result.totalPages;
          }
        }
      }

      allItems.sort((a, b) => b.readySince.compareTo(a.readySince));

      prescriptions.assignAll(allItems);
      total.value = maxTotal;
      currentPage.value = page;
      totalPages.value = maxTotalPages;

    } catch (e) {
      errorMessage.value = 'تعذر تحميل الوصفات';
      prescriptions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || isLoading.value || !hasMore) return;

    isLoadingMore.value = true;

    try {
      final allItems = <DispenseQueueItem>[];
      int maxTotalPages = totalPages.value;

      for (final status in _activeStatuses) {
        final result = await _queueService.getDispenseQueue(
          status: status,
          page: currentPage.value + 1,
        );

        if (result != null) {
          allItems.addAll(result.items);
          if (result.totalPages > maxTotalPages) {
            maxTotalPages = result.totalPages;
          }
        }
      }

      allItems.sort((a, b) => b.readySince.compareTo(a.readySince));

      prescriptions.addAll(allItems);
      currentPage.value = currentPage.value + 1;
      totalPages.value = maxTotalPages;
    } finally {
      isLoadingMore.value = false;
    }
  }

  void removeFromList(String id) {
    prescriptions.removeWhere((p) => p.id == id);
  }

  void updateItemStatus(String id, CycleStatus newStatus) {
    final i = prescriptions.indexWhere((p) => p.id == id);
    if (i != -1) {
      final old = prescriptions[i];
      prescriptions[i] = DispenseQueueItem(
        id: old.id,
        patientId: old.patientId,
        nationalId: old.nationalId,
        familyBookNumber: old.familyBookNumber,
        patientName: old.patientName,
        prescriptionId: old.prescriptionId,
        cycleNumber: old.cycleNumber,
        medicationSummary: old.medicationSummary,
        status: newStatus,
        readySince: old.readySince,
        updatedAt: DateTime.now(),
      );
      prescriptions.refresh();
    }
  }
}