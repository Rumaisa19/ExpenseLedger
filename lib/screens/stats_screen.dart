import 'package:expense_ledger_app/providers/expense_provider.dart';
import 'package:expense_ledger_app/utils/app_constants.dart';
import 'package:expense_ledger_app/widgets/category_distribution_chart.dart';
import 'package:expense_ledger_app/widgets/custom_app_bar.dart';
import 'package:expense_ledger_app/widgets/custom_section_label.dart';
import 'package:expense_ledger_app/widgets/custom_card.dart';
import 'package:expense_ledger_app/widgets/weekly_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: 'Insights', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.pDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionLabel("Overview"),
            const SizedBox(height: 14),
            GradientCard.display(
              title: 'Total Spending',
              amount: provider.totalExpenses,
              icon: Icons.trending_up,
              subtitle: 'All time',
            ),
            const SizedBox(height: 24),

            const SectionLabel("Spending by Category"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: theme.brightness == Brightness.light
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha:   0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              padding: const EdgeInsets.all(16),
              child: CategoryDistributionChart(expenses: provider.expenses),
            ),

            const SizedBox(height: 24),

            const SectionLabel("Weekly Trends"),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: theme.brightness == Brightness.light
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              padding: const EdgeInsets.all(16),
              child: WeeklyBarChart(expenses: provider.expenses),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
