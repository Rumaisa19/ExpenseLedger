import 'package:expense_ledger_app/models/expense.dart';
import 'package:expense_ledger_app/providers/expense_provider.dart';
import 'package:expense_ledger_app/utils/app_constants.dart';
import 'package:expense_ledger_app/widgets/category_picker.dart';
import 'package:expense_ledger_app/widgets/custom_app_bar.dart';
import 'package:expense_ledger_app/widgets/custom_card.dart';
import 'package:expense_ledger_app/widgets/custom_date_picker_field.dart';
import 'package:expense_ledger_app/widgets/custom_save_button.dart';
import 'package:expense_ledger_app/widgets/custom_section_label.dart';
import 'package:expense_ledger_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = ''; // Set default category
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    // 1. First, dismiss the keyboard to prevent UI overflow errors
    FocusScope.of(context).unfocus();

    // 2. Validate the Form fields (Title, etc.)
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form is invalid
    }

    // 3. Amount Validation
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid amount greater than 0'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Stop if amount is invalid
    }

    // 4. Create the new expense object
    final newExpense = Expense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    // 5. Add to Provider and Navigate back
    // Using listen: false is correct here because we are in a function
    Provider.of<ExpenseProvider>(context, listen: false).addExpense(newExpense);

    // 6. Success Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Expense saved successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1), // Shorter duration for better UX
      ),
    );

    // 7. Finally, go back to Home Screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Add Expense'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.pDefault),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Amount field
                    const SectionLabel('Amount'),
                    GradientCard.input(controller: _amountController),
                    const SizedBox(height: 24),

                    // Title field - REQUIRED
                    const SectionLabel('Title'),
                    CustomTextField(
                      controller: _titleController,
                      hint: 'e.g., Lunch at restaurant',
                      icon: Icons.edit_outlined,
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Title is required';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    // Category - REQUIRED
                    const SectionLabel('Category'),

                    CategoryPicker(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (cat) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // Date - REQUIRED (has default value)
                    const SectionLabel('Date'),
                    DatePickerField(
                      selectedDate: _selectedDate,
                      onDateChanged: (date) =>
                          setState(() => _selectedDate = date),
                    ),

                    const SizedBox(height: 24),

                    // Description - OPTIONAL
                    const SectionLabel('Description (Optional)'),
                    CustomTextField(
                      controller: _descriptionController,
                      hint: 'Add any notes...',
                      icon: Icons.notes_outlined,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 32),

                    // Save button
                    PrimaryButton(
                      text: 'Save Expense',
                      onPressed: _saveExpense,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
