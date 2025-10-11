import 'package:hive/hive.dart';

part 'loan.g.dart';

@HiveType(typeId: 1) // رقم معرف فريد
class Loan extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  double originalAmount;

  @HiveField(2)
  double remainingAmount;

  @HiveField(3)
  DateTime dueDate;

  @HiveField(4)
  bool isBorrowing; // true إذا كنت تقترض، false إذا كنت تقرض

  Loan({
    required this.description,
    required this.originalAmount,
    required this.remainingAmount,
    required this.dueDate,
    required this.isBorrowing,
  });
}