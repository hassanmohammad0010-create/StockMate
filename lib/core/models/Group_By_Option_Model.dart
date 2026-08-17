// lib/core/models/Group_By_Option_Model.dart
// ignore_for_file: file_names

class GroupByOption {
  final String label;
  final String? value; // ← null يعني بدون تجميع (ما نبعتها بالطلب أصلاً)

  const GroupByOption({required this.label, required this.value});

  static const List<GroupByOption> all = [
    GroupByOption(label: 'بدون تجميع', value: null),
    GroupByOption(label: 'يومي', value: 'day'),
    GroupByOption(label: 'أسبوعي', value: 'week'),
    GroupByOption(label: 'شهري', value: 'month'),
  ];
}
