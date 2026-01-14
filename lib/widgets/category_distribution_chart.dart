import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../utils/app_constants.dart';

class CategoryDistributionChart extends StatelessWidget {
  final List<Expense> expenses;

  const CategoryDistributionChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (expenses.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(child: Text("No Data Available")),
      );
    }

    final Map<String, double> categoryTotals = {};
    double totalSpending = 0;

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
      totalSpending += expense.amount;
    }

    final sortedEntries = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      mainAxisSize: MainAxisSize.min, // Prevents taking infinite height
      children: [
        SizedBox(
          height: 200, // Explicit height to prevent h=0.0 error
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: sortedEntries.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final percentage = (data.value / totalSpending * 100);

                return PieChartSectionData(
                  color: _getSectionColor(index),
                  value: data.value,
                  title: '${percentage.toStringAsFixed(0)}%',
                  radius: 50,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildLegend(sortedEntries, totalSpending, theme),
      ],
    );
  }

  Color _getSectionColor(int index) {
    final List<Color> palette = [
      AppColors.primary,
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFFF59E0B),
      const Color(0xFF10B981),
    ];
    return palette[index % palette.length];
  }

  Widget _buildLegend(
    List<MapEntry<String, double>> entries,
    double total,
    ThemeData theme,
  ) {
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: entries.map((e) {
        final index = entries.indexOf(e);
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: _getSectionColor(index),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              "${e.key}: Rs ${e.value.toInt()}",
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }
}
