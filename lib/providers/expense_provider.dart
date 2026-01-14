import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseProvider with ChangeNotifier {
  // Reference to our opened Hive box

  final box = Hive.box<Expense>('expenses');

  // Internal list of expenses
  List<Expense> _expenses = [];

  // Getter to allow UI to see the expenses
  List<Expense> get expenses => _expenses;

  // 1. Load Expenses from Hive
  void loadExpenses() {
    _expenses = box.values.toList();
    notifyListeners(); // Tells the UI to refresh
  }

  // 2. Add Expense
  void addExpense(Expense newExpense) {
    box.put(newExpense.id, newExpense); // Save to Disk
    _expenses.add(newExpense); // Update Memory
    notifyListeners(); // Refresh UI
  }

  // 3. Edit Expense
  void updateExpense(Expense updatedExpense) {
    final index = _expenses.indexWhere((exp) => exp.id == updatedExpense.id);
    if (index != -1) {
      _expenses[index] = updatedExpense;
      notifyListeners();
      // If you have persistence (SharedPreferences/Database), save here
      // _saveExpenses();
    }
  }

  // 4. Delete Expense
  void deleteExpense(String id) {
    box.delete(id); // Remove from Disk
    _expenses.removeWhere((e) => e.id == id); // Remove from Memory
    notifyListeners(); // Refresh UI
  }

  // 5. Logic: Calculate Total
  double get totalExpenses {
    return _expenses.fold(0.0, (sum, item) => sum + item.amount);
  }
}
