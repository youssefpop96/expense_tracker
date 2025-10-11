import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 2) // تأكد أن الـ typeId فريد
class Budget extends HiveObject {
  @HiveField(0)
  String category;

  @HiveField(1)
  double amount;

  Budget({
    required this.category,
    required this.amount,
  });
}