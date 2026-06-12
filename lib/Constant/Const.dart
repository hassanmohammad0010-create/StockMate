import 'package:flutter/material.dart';

// ─── الألوان ───────────────────────────────────────────
const Color constColor = Color(0xff192132);
const Color constBlue = Color(0xff0983C0);
const Color constLightBlue = Color(0xffE3F2FD);
const Color constGray = Color(0xff7988A7);
const Color constLightGray = Color(0xffE3FDED);

const Color constGreen = Color(0xff09C05E);
const Color constlightGreen = Color(0xffE3FDED);

const Color constOrange = Color(0xffEE771D);
const Color constLightOrange = Color(0xffFFF1E6);

const Color constRed = Color(0xffE53935);
const Color constLightRed = Color(0xffFFEBEE);

// ─── الخطوط ───────────────────────────────────────────
String cairo = 'Cairo';
String lateef = 'Lateef';
// ─── الصور ────────────────────────────────────────────
String fullLogo = 'assets/Image/Logo/Full_Logo.png';
String semiLogo = 'assets/Image/Logo/Semi_Logo.png';
String textLogo = 'assets/Image/Logo/Text_Logo.png';

List<String> specialties = [
  'اذنية',
  'مفاصل',
  'جلدية',
  'داخلية',
  'هضمية',
  'عمليات',
  'عناية',
  'جراحة',
  'اسعاف',
  'كلية',
  'عيادات',
  'مخبر',
  'صيدلية',
  'تعقيم',
];
List<IconData> specialtiesIcons = [
  Icons.hearing,
  Icons.accessibility_new,
  Icons.face_retouching_natural,
  Icons.monitor_heart,
  Icons.bubble_chart,
  Icons.medical_services,
  Icons.bed,
  Icons.content_cut,
  Icons.emergency,
  Icons.filter_drama,
  Icons.local_hospital,
  Icons.science,
  Icons.local_pharmacy,
  Icons.cleaning_services,
];

// ─── Extension للقيم الديناميكية ──────────────────────
extension AppSize on BuildContext {
  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get keyboard => MediaQuery.of(this).viewInsets.bottom;
}
