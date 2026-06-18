// ignore_for_file: file_names

enum PrescriptionStatus { newRx, processed, rejected }

class PrescriptionMedicine {
  final String name;
  final int quantity;
  final String unit;
  final String dosage;
  final String notes;

  const PrescriptionMedicine({
    required this.name,
    required this.quantity,
    required this.unit,
    required this.dosage,
    this.notes = '',
  });
}

class Prescription {
  final String id;
  final String doctorName;
  final String department;
  final String patientName;
  final String patientId;
  final String date;
  final PrescriptionStatus status;
  final List<PrescriptionMedicine> medicines;
  final String notes;

  const Prescription({
    required this.id,
    required this.doctorName,
    required this.department,
    required this.patientName,
    required this.patientId,
    required this.date,
    required this.status,
    required this.medicines,
    this.notes = '',
  });
}

// ─── بيانات تجريبية ───────────────────────────────────────────

final List<Prescription> allPrescriptions = [
  Prescription(
    id: 'RX-001',
    doctorName: 'د. أحمد الخطيب',
    department: 'قسم الجراحة',
    patientName: 'محمد عبد الله',
    patientId: 'P-10234',
    date: '2026-06-19',
    status: PrescriptionStatus.newRx,
    notes: 'المريض يعاني من حساسية للبنسلين',
    medicines: [
      PrescriptionMedicine(
        name: 'باراسيتامول 500mg',
        quantity: 20,
        unit: 'حبة',
        dosage: 'حبة كل 8 ساعات',
      ),
      PrescriptionMedicine(
        name: 'أموكسيسيلين 250mg',
        quantity: 14,
        unit: 'كبسولة',
        dosage: 'كبسولة كل 12 ساعة',
        notes: 'تؤخذ بعد الأكل',
      ),
      PrescriptionMedicine(
        name: 'إيبوبروفين 400mg',
        quantity: 10,
        unit: 'حبة',
        dosage: 'حبة كل 8 ساعات عند الألم',
      ),
    ],
  ),
  Prescription(
    id: 'RX-002',
    doctorName: 'د. سارة النجار',
    department: 'قسم الأطفال',
    patientName: 'ليلى محمود',
    patientId: 'P-10501',
    date: '2026-06-18',
    status: PrescriptionStatus.processed,
    medicines: [
      PrescriptionMedicine(
        name: 'سيتريزين شراب',
        quantity: 2,
        unit: 'زجاجة',
        dosage: '5ml مرتين يومياً',
      ),
      PrescriptionMedicine(
        name: 'فيتامين C 1000mg',
        quantity: 30,
        unit: 'حبة',
        dosage: 'حبة يومياً',
      ),
    ],
  ),
  Prescription(
    id: 'RX-003',
    doctorName: 'د. خالد عمر',
    department: 'قسم الباطنية',
    patientName: 'يوسف إبراهيم',
    patientId: 'P-10876',
    date: '2026-06-17',
    status: PrescriptionStatus.rejected,
    notes: 'الدواء غير متوفر في المستودع',
    medicines: [
      PrescriptionMedicine(
        name: 'ميترونيدازول 500mg',
        quantity: 21,
        unit: 'حبة',
        dosage: 'حبة 3 مرات يومياً',
        notes: 'تؤخذ مع الطعام',
      ),
    ],
  ),
];