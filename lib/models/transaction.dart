import 'package:hive/hive.dart';

part 'transaction.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  double amount;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool isExpense;

  @HiveField(4)
  String category;

  Transaction({
    required this.description,
    required this.amount,
    required this.date,
    required this.isExpense,
    required this.category,
  });
}