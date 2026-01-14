import 'package:hive/hive.dart';

// This is required for Hive to generate the 'expense.g.dart' file
part 'expense.g.dart';

@HiveType(typeId: 0) // Each model needs a unique typeId
class Expense extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final String category;

  @HiveField(5) // Added description field
  final String? description; // Optional field

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.description, // Optional parameter
  });
}