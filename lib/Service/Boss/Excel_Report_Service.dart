// lib/Service/Excel_Report_Service.dart
// ignore_for_file: file_names

import 'dart:io';
import 'package:excel/excel.dart' as xls;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stock_mate_project/core/models/Adjustment_Type_Model.dart';
import 'package:stock_mate_project/core/models/Inventory_Movement_Report_Model.dart';

class ExcelReportService {
  /// يبني ملف Excel من تقرير حركة المخزون، يحفظه، ويرجّع المسار
  static Future<String> generateInventoryMovementExcel({
    required InventoryMovementReport report,
    required String fromDate,
    required String toDate,
  }) async {
    final excel = xls.Excel.createExcel();

    // ─── حذف الشيت الافتراضي الفاضي ─────────────────────────
    excel.delete('Sheet1');

    _buildSummarySheet(excel, report, fromDate, toDate);
    _buildTransactionTypeSheet(excel, report);
    _buildDepartmentSheet(excel, report);
    _buildSeriesSheet(excel, report);
    _buildRowsSheet(excel, report);

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('فشل توليد ملف الإكسل');
    }

    Directory? dir;
    if (Platform.isAndroid) {
      dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) {
        dir = await getDownloadsDirectory();
      }
    } else if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir =
          await getDownloadsDirectory() ??
          await getApplicationDocumentsDirectory();
    }

    if (dir == null) {
      dir = await getTemporaryDirectory();
    }

    final fileName =
        'تقرير_حركة_المخزون_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    var filePath = '${dir.path}/$fileName';

    try {
      final file = File(filePath);
      await file.writeAsBytes(bytes);
    } catch (e) {
      // Fallback in case of permission issues on older Android versions or missing directories
      final tempDir = await getTemporaryDirectory();
      filePath = '${tempDir.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
    }

    return filePath;
  }

  static Future<void> openFile(String path) async {
    await OpenFilex.open(path);
  }

  // ─── ورقة الملخص ────────────────────────────────────────────
  static void _buildSummarySheet(
    xls.Excel excel,
    InventoryMovementReport report,
    String fromDate,
    String toDate,
  ) {
    final sheet = excel['الملخص'];

    sheet.appendRow([xls.TextCellValue('تقرير حركة المخزون')]);
    sheet.appendRow([xls.TextCellValue('الفترة: $fromDate إلى $toDate')]);
    sheet.appendRow([]);
    sheet.appendRow([xls.TextCellValue('المؤشر'), xls.TextCellValue('القيمة')]);
    sheet.appendRow([
      xls.TextCellValue('إجمالي عدد الحركات'),
      xls.IntCellValue(report.summary.totalTransactions),
    ]);
    sheet.appendRow([
      xls.TextCellValue('إجمالي الكمية الداخلة'),
      xls.IntCellValue(report.summary.totalQuantityIn),
    ]);
    sheet.appendRow([
      xls.TextCellValue('إجمالي الكمية الخارجة'),
      xls.IntCellValue(report.summary.totalQuantityOut),
    ]);
    sheet.appendRow([
      xls.TextCellValue('صافي الكمية'),
      xls.IntCellValue(report.summary.netQuantity),
    ]);
  }

  // ─── ورقة حسب نوع الحركة ────────────────────────────────────
  static void _buildTransactionTypeSheet(
    xls.Excel excel,
    InventoryMovementReport report,
  ) {
    final sheet = excel['حسب نوع الحركة'];

    sheet.appendRow([
      xls.TextCellValue('نوع الحركة'),
      xls.TextCellValue('عدد العمليات'),
      xls.TextCellValue('إجمالي الكمية'),
    ]);

    for (final t in report.summary.byTransactionType) {
      sheet.appendRow([
        xls.TextCellValue(t.arabicLabel),
        xls.IntCellValue(t.count),
        xls.IntCellValue(t.totalQuantity),
      ]);
    }
  }

  // ─── ورقة حسب القسم ─────────────────────────────────────────
  static void _buildDepartmentSheet(
    xls.Excel excel,
    InventoryMovementReport report,
  ) {
    final sheet = excel['حسب القسم'];

    sheet.appendRow([
      xls.TextCellValue('القسم'),
      xls.TextCellValue('عدد العمليات'),
      xls.TextCellValue('الكمية الداخلة'),
      xls.TextCellValue('الكمية الخارجة'),
      xls.TextCellValue('الصافي'),
    ]);

    for (final d in report.byDepartment) {
      sheet.appendRow([
        xls.TextCellValue(d.departmentName),
        xls.IntCellValue(d.count),
        xls.IntCellValue(d.quantityIn),
        xls.IntCellValue(d.quantityOut),
        xls.IntCellValue(d.net),
      ]);
    }
  }

  // ─── ورقة السلسلة الزمنية ───────────────────────────────────
  static void _buildSeriesSheet(
    xls.Excel excel,
    InventoryMovementReport report,
  ) {
    final sheet = excel['السلسلة الزمنية'];

    sheet.appendRow([
      xls.TextCellValue('التاريخ'),
      xls.TextCellValue('الكمية الداخلة'),
      xls.TextCellValue('الكمية الخارجة'),
      xls.TextCellValue('الصافي'),
    ]);

    for (final s in report.series) {
      sheet.appendRow([
        xls.TextCellValue(s.bucket),
        xls.IntCellValue(s.quantityIn),
        xls.IntCellValue(s.quantityOut),
        xls.IntCellValue(s.net),
      ]);
    }
  }

  // ─── ورقة تفاصيل الحركات ────────────────────────────────────
  static void _buildRowsSheet(xls.Excel excel, InventoryMovementReport report) {
    final sheet = excel['تفاصيل الحركات'];

    sheet.appendRow([
      xls.TextCellValue('التاريخ'),
      xls.TextCellValue('نوع الحركة'),
      xls.TextCellValue('الصنف'),
      xls.TextCellValue('SKU'),
      xls.TextCellValue('رقم الدفعة'),
      xls.TextCellValue('القسم'),
      xls.TextCellValue('الكمية'),
      xls.TextCellValue('الرصيد بعد الحركة'),
      xls.TextCellValue('المستخدم'),
      xls.TextCellValue('ملاحظات'),
    ]);

    for (final row in report.rows.items) {
      sheet.appendRow([
        xls.TextCellValue(row.transactionDate.toString()),
        xls.TextCellValue(row.arabicTypeLabel),
        xls.TextCellValue(row.variant?.variantName ?? '-'),
        xls.TextCellValue(row.variant?.sku ?? '-'),
        xls.TextCellValue(row.batch?.batchNumber ?? '-'),
        xls.TextCellValue(row.department?.name ?? '-'),
        xls.IntCellValue(row.quantity),
        xls.IntCellValue(row.balanceAfter),
        xls.TextCellValue(row.performedBy?.fullName ?? '-'),
        xls.TextCellValue(row.notes ?? '-'),
      ]);
    }
  }

  // ✅ أضيفي هذا التابع داخل نفس class ExcelReportService الموجود
  static Future<String> generateAdjustmentsExcel({
    required AdjustmentsReport report,
    required String fromDate,
    required String toDate,
  }) async {
    final excel = xls.Excel.createExcel();
    excel.delete('Sheet1');

    _buildAdjustmentsSummarySheet(excel, report, fromDate, toDate);
    _buildAdjustmentsTypeSheet(excel, report);
    _buildAdjustmentsDepartmentSheet(excel, report);
    _buildAdjustmentsSeriesSheet(excel, report);
    _buildAdjustmentsRowsSheet(excel, report);

    final bytes = excel.encode();
    if (bytes == null) {
      throw Exception('فشل توليد ملف الإكسل');
    }

    final dir = await getTemporaryDirectory();
    final fileName =
        'تقرير_التسويات_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final filePath = '${dir.path}/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return filePath;
  }

  // ─── ورقة الملخص ────────────────────────────────────────────
  static void _buildAdjustmentsSummarySheet(
    xls.Excel excel,
    AdjustmentsReport report,
    String fromDate,
    String toDate,
  ) {
    final sheet = excel['الملخص'];

    sheet.appendRow([xls.TextCellValue('تقرير التسويات')]);
    sheet.appendRow([xls.TextCellValue('الفترة: $fromDate إلى $toDate')]);
    sheet.appendRow([]);
    sheet.appendRow([xls.TextCellValue('المؤشر'), xls.TextCellValue('القيمة')]);
    sheet.appendRow([
      xls.TextCellValue('إجمالي عدد التسويات'),
      xls.IntCellValue(report.summary.totalAdjustments),
    ]);
    sheet.appendRow([
      xls.TextCellValue('إجمالي الكمية'),
      xls.IntCellValue(report.summary.totalQuantity),
    ]);
  }

  // ─── ورقة حسب نوع التسوية ────────────────────────────────────
  static void _buildAdjustmentsTypeSheet(
    xls.Excel excel,
    AdjustmentsReport report,
  ) {
    final sheet = excel['حسب نوع التسوية'];

    sheet.appendRow([
      xls.TextCellValue('نوع التسوية'),
      xls.TextCellValue('عدد العمليات'),
      xls.TextCellValue('إجمالي الكمية'),
    ]);

    for (final t in report.summary.byAdjustmentType) {
      sheet.appendRow([
        xls.TextCellValue(t.arabicLabel),
        xls.IntCellValue(t.count),
        xls.IntCellValue(t.totalQuantity),
      ]);
    }
  }

  // ─── ورقة حسب القسم ─────────────────────────────────────────
  static void _buildAdjustmentsDepartmentSheet(
    xls.Excel excel,
    AdjustmentsReport report,
  ) {
    final sheet = excel['حسب القسم'];

    sheet.appendRow([
      xls.TextCellValue('القسم'),
      xls.TextCellValue('عدد العمليات'),
      xls.TextCellValue('الكمية المضافة'),
      xls.TextCellValue('الكمية المنقوصة'),
    ]);

    for (final d in report.byDepartment) {
      sheet.appendRow([
        xls.TextCellValue(d.departmentName),
        xls.IntCellValue(d.count),
        xls.IntCellValue(d.quantityIncreased),
        xls.IntCellValue(d.quantityDecreased),
      ]);
    }
  }

  // ─── ورقة السلسلة الزمنية ───────────────────────────────────
  static void _buildAdjustmentsSeriesSheet(
    xls.Excel excel,
    AdjustmentsReport report,
  ) {
    final sheet = excel['السلسلة الزمنية'];

    sheet.appendRow([
      xls.TextCellValue('التاريخ'),
      xls.TextCellValue('الكمية المضافة'),
      xls.TextCellValue('الكمية المنقوصة'),
    ]);

    for (final s in report.series) {
      sheet.appendRow([
        xls.TextCellValue(s.bucket),
        xls.IntCellValue(s.quantityIncreased),
        xls.IntCellValue(s.quantityDecreased),
      ]);
    }
  }

  // ─── ورقة تفاصيل التسويات ────────────────────────────────────
  static void _buildAdjustmentsRowsSheet(
    xls.Excel excel,
    AdjustmentsReport report,
  ) {
    final sheet = excel['تفاصيل التسويات'];

    sheet.appendRow([
      xls.TextCellValue('التاريخ'),
      xls.TextCellValue('نوع التسوية'),
      xls.TextCellValue('الصنف'),
      xls.TextCellValue('SKU'),
      xls.TextCellValue('رقم الدفعة'),
      xls.TextCellValue('القسم'),
      xls.TextCellValue('الكمية'),
      xls.TextCellValue('المستخدم'),
      xls.TextCellValue('ملاحظات'),
    ]);

    for (final row in report.rows.items) {
      sheet.appendRow([
        xls.TextCellValue(row.createdAt.toString()),
        xls.TextCellValue(row.arabicTypeLabel),
        xls.TextCellValue(row.variant?.variantName ?? '-'),
        xls.TextCellValue(row.variant?.sku ?? '-'),
        xls.TextCellValue(row.batch?.batchNumber ?? '-'),
        xls.TextCellValue(row.department?.name ?? '-'),
        xls.IntCellValue(row.quantity),
        xls.TextCellValue(row.reportedBy?.fullName ?? '-'),
        xls.TextCellValue(row.notes ?? '-'),
      ]);
    }
  }
}
