import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/expense.dart';
import '../utils/app_constants.dart';

class WeeklyBarChart extends StatelessWidget {
  final List<Expense> expenses;

  const WeeklyBarChart({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (expenses.isEmpty) {
      return _buildEmptyState(theme);
    }

    final dailyTotals = _calculateDailyTotals();
    final maxY = _calculateMaxY(dailyTotals);

    return Padding(
      padding: const EdgeInsets.only(top: 24, right: 16, left: 4),
      child: SizedBox(
        height: 250,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: maxY,
            barTouchData: _buildTouchData(theme),
            titlesData: _buildTitlesData(theme, maxY), // Pass maxY here
            gridData: _buildGridData(theme, maxY), // Pass maxY here
            borderData: FlBorderData(show: false),
            barGroups: _generateBarGroups(dailyTotals, theme),
          ),
        ),
      ),
    );
  }

  // ... _calculateDailyTotals stays the same ...
  Map<int, double> _calculateDailyTotals() {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));

    final Map<int, double> dailyTotals = {
      0: 0,
      1: 0,
      2: 0,
      3: 0,
      4: 0,
      5: 0,
      6: 0,
    };

    for (var expense in expenses) {
      final expDate = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      final diff = expDate.difference(startOfWeek).inDays;
      if (diff >= 0 && diff < 7) {
        dailyTotals[diff] = (dailyTotals[diff] ?? 0) + expense.amount;
      }
    }
    return dailyTotals;
  }

  List<BarChartGroupData> _generateBarGroups(
    Map<int, double> dailyTotals,
    ThemeData theme,
  ) {
    return dailyTotals.entries.map((entry) {
      final bool hasValue = entry.value > 0;
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value,
            gradient: hasValue ? AppColors.primaryGradient : null,
            color: hasValue ? null : theme.colorScheme.surfaceVariant,
            width: 18,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    }).toList();
  }

  double _calculateMaxY(Map<int, double> totals) {
    final maxVal = totals.values.reduce((a, b) => a > b ? a : b);
    return maxVal == 0 ? 100 : maxVal * 1.3;
  }

  BarTouchData _buildTouchData(ThemeData theme) => BarTouchData(
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: theme.colorScheme.onSurface.withOpacity(0.9),
      getTooltipItem: (group, groupIdx, rod, rodIdx) => BarTooltipItem(
        'Rs ${rod.toY.toInt()}',
        TextStyle(
          color: theme.colorScheme.surface,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  FlTitlesData _buildTitlesData(ThemeData theme, double maxY) => FlTitlesData(
    show: true,
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    leftTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 45,
        // FIX: Calculate interval so we only show ~5 labels regardless of amount
        interval: maxY / 5 > 0 ? (maxY / 5) : 20,
        getTitlesWidget: (value, meta) {
          if (value == meta.max) return const SizedBox(); // Hide top-most label

          String text;
          if (value >= 1000) {
            text =
                '${(value / 1000).toStringAsFixed(value % 1000 == 0 ? 0 : 1)}K';
          } else {
            text = value.toInt().toString();
          }

          return SideTitleWidget(
            axisSide: meta.axisSide,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          );
        },
      ),
    ),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        reservedSize: 30,
        getTitlesWidget: (value, meta) {
          const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
          final index = value.toInt();
          if (index < 0 || index >= days.length) return const SizedBox();
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 12,
            child: Text(
              days[index],
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          );
        },
      ),
    ),
  );

  FlGridData _buildGridData(ThemeData theme, double maxY) => FlGridData(
    show: true,
    drawVerticalLine: false,
    // FIX: Match grid lines to the labels
    horizontalInterval: maxY / 5 > 0 ? (maxY / 5) : 20,
    getDrawingHorizontalLine: (val) =>
        FlLine(color: theme.dividerColor.withOpacity(0.1), strokeWidth: 1),
  );

  Widget _buildEmptyState(ThemeData theme) => Center(
    child: Text(
      "No data recorded this week",
      style: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    ),
  );
}
