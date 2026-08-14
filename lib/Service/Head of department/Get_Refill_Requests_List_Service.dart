// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_mate_project/Service/Dispatcher.dart';
import 'package:stock_mate_project/core/models/Order_Item.dart';

/// سيرفس جلب قائمة الطلبات — List Refill Requests
/// GET /department-refills/requests
class GetRefillRequestsListService {
  static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

  final Dispatcher _dispatcher = Dispatcher();

  Future<RefillRequestsPageData?> getRequests({
    required String departmentId,
    int page = 1,
    int limit = 20,
  }) async {
    return _dispatcher.send<RefillRequestsPageData?>(
      request: (token) {
        final uri = Uri.parse(
          '$baseUrl/department-refills/requests'
          '?page=$page'
          '&limit=$limit'
          '&departmentId=$departmentId',
        );

        return http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      },

      onSuccess: (body) {
        final jsonData = jsonDecode(body);

        if (jsonData['success'] == true && jsonData['data'] != null) {
          return RefillRequestsPageData.fromJson(
            jsonData['data'] as Map<String, dynamic>,
          );
        }

        print('❌ List Requests | success = false: ${jsonData['message']}');
        return null;
      },

      fallback: null,
    );
  }
}

// // ignore_for_file: file_names

// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:stock_mate_project/Service/Dispatcher.dart';
// import 'package:stock_mate_project/core/models/Order_Item.dart';

// /// سيرفس جلب قائمة الطلبات — List Refill Requests
// /// GET /department-refills/requests
// ///
// /// ⚠️ ملاحظة مهمة (تم التأكد من الباك اند):
// /// - status يقبل قيمة واحدة فقط في كل طلب (وليس عدة قيم مفصولة بفاصلة).
// /// - نفس الأمر ينطبق على requestType.
// /// - لذلك لو فلتر الواجهة يقابل أكثر من status/requestType واحد،
// ///   يجب إرسال عدة طلبات ودمج نتائجها (انظر fetchMergedRequests أدناه).
// class GetRefillRequestsListService {
//   static const String baseUrl = 'https://stock-mate-qb40.onrender.com/api';

//   final Dispatcher _dispatcher = Dispatcher();

//   /// جلب صفحة واحدة، مع إمكانية تمرير status و/أو requestType كفلتر اختياري.
//   /// - status: قيمة واحدة فقط من enum الباك اند (مثل 'draft', 'preparing', ...)
//   /// - requestType: قيمة واحدة فقط ('daily', 'weekly', 'monthly', 'normal', ...)
//   Future<RefillRequestsPageData?> getRequests({
//     required String departmentId,
//     int page = 1,
//     int limit = 20,
//     String? status,
//     String? requestType,
//   }) async {
//     return _dispatcher.send<RefillRequestsPageData?>(
//       // ─── الطلب الفعلي: Dispatcher بيمرر التوكن جاهز، إحنا بس نبني الطلب ───
//       request: (token) {
//         final queryParams = <String, String>{
//           'page': '$page',
//           'limit': '$limit',
//           'departmentId': departmentId,
//           if (status != null && status.isNotEmpty) 'status': status,
//           if (requestType != null && requestType.isNotEmpty)
//             'requestType': requestType,
//         };

//         final uri = Uri.parse('$baseUrl/department-refills/requests')
//             .replace(queryParameters: queryParams);

//         return http.get(
//           uri,
//           headers: {
//             'Content-Type': 'application/json',
//             'Accept': 'application/json',
//             'Authorization': 'Bearer $token',
//           },
//         );
//       },

//       // ─── عند نجاح الطلب (status 200): نحوّل الـ body لـ RefillRequestsPageData ───
//       onSuccess: (body) {
//         final jsonData = jsonDecode(body);

//         // نتحقق من الـ success flag قبل التحويل
//         if (jsonData['success'] == true && jsonData['data'] != null) {
//           return RefillRequestsPageData.fromJson(
//             jsonData['data'] as Map<String, dynamic>,
//           );
//         }

//         print('❌ List Requests | success = false: ${jsonData['message']}');
//         return null;
//       },

//       // ─── القيمة المرتجعة عند أي فشل (null بدل رمي Exception) ───
//       fallback: null,
//     );
//   }

//   /// ✅ دمج نتائج عدة قيم status/requestType في طلب واحد منطقي.
//   ///
//   /// يُستخدم عندما يقابل فلتر واحد في الواجهة أكثر من قيمة واحدة في الباك اند
//   /// (مثال: فلتر "معلق" = draft + pending_hospital_approval).
//   ///
//   /// يرسل طلبًا منفصلاً لكل قيمة بالتوازي (Future.wait)، ثم يدمج كل الـ items
//   /// في صفحة واحدة. الـ pagination هنا تُحسب تقريبيًا (مجموع total لكل الطلبات)
//   /// لأن الباك اند لا يدعم دمج القيم في استعلام واحد.
//   ///
//   /// - statusValues: قائمة قيم status لدمجها (اتركها فارغة لتجاهلها)
//   /// - requestTypeValues: قائمة قيم requestType لدمجها (اتركها فارغة لتجاهلها)
//   ///
//   /// إن مررت كلا القائمتين معًا، سيتم إرسال طلب لكل قيمة status بشكل منفصل
//   /// عن كل قيمة requestType (استخدم واحدة منهما فقط عادةً حسب طبيعة الفلتر).
//   Future<RefillRequestsPageData?> getRequestsMerged({
//     required String departmentId,
//     int page = 1,
//     int limit = 20,
//     List<String> statusValues = const [],
//     List<String> requestTypeValues = const [],
//   }) async {
//     // بناء قائمة الطلبات المطلوبة
//     final futures = <Future<RefillRequestsPageData?>>[];

//     if (statusValues.isNotEmpty) {
//       for (final s in statusValues) {
//         futures.add(
//           getRequests(
//             departmentId: departmentId,
//             page: page,
//             limit: limit,
//             status: s,
//           ),
//         );
//       }
//     } else if (requestTypeValues.isNotEmpty) {
//       for (final rt in requestTypeValues) {
//         futures.add(
//           getRequests(
//             departmentId: departmentId,
//             page: page,
//             limit: limit,
//             requestType: rt,
//           ),
//         );
//       }
//     } else {
//       // لا يوجد فلتر إطلاقاً -> طلب واحد عادي ("الكل")
//       futures.add(
//         getRequests(departmentId: departmentId, page: page, limit: limit),
//       );
//     }

//     final results = await Future.wait(futures);

//     final allItems = <OrdertItem>[];
//     int totalSum = 0;

//     for (final r in results) {
//       if (r != null) {
//         allItems.addAll(r.items);
//         totalSum += r.total;
//       }
//     }

//     if (allItems.isEmpty && results.every((r) => r == null)) {
//       // كل الطلبات فشلت
//       return null;
//     }

//     // ✅ ترتيب النتائج المدموجة حسب تاريخ الإنشاء (الأحدث أولاً)
//     allItems.sort((a, b) => b.createdAt.compareTo(a.createdAt));

//     return RefillRequestsPageData(
//       items: allItems,
//       total: totalSum,
//       page: page,
//       limit: limit,
//       // ⚠️ عند الدمج، لا يوجد totalPages دقيق لأن كل استعلام له pagination خاصة به.
//       // نفترض عدم وجود صفحة تالية لتفادي تعقيد "تحميل المزيد" مع نتائج مدموجة.
//       // إن احتجت pagination دقيقة مع الفلاتر المدموجة، يفضّل حينها تعديل الباك
//       // اند ليقبل status بصيغة مصفوفة (?status=a,b) بدل هذا الحل من الواجهة.
//       totalPages: page,
//     );
//   }
// }