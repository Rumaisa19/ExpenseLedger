import 'package:expense_ledger_app/providers/expense_provider.dart';
import 'package:expense_ledger_app/routes/app_routes.dart';
import 'package:expense_ledger_app/utils/app_constants.dart';
import 'package:expense_ledger_app/widgets/category_selector.dart';
import 'package:expense_ledger_app/widgets/custom_card.dart';
import 'package:expense_ledger_app/widgets/empty_state.dart';
import 'package:expense_ledger_app/widgets/transaction_card.dart';
import 'package:expense_ledger_app/widgets/edit_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedFilterCategory;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ExpenseProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredExpenses = _selectedFilterCategory == null
        ? provider.expenses
        : provider.expenses
              .where((e) => e.category == _selectedFilterCategory)
              .toList();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // --- SECTION 1: HEADER & CARDS ---
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isDark),

                  Padding(
                    padding: const EdgeInsets.all(AppSizes.pDefault),
                    child: GradientCard.display(
                      title: 'Total Balance',
                      amount: provider.totalExpenses,
                    ),
                  ),

                  _buildStatsBridge(context, isDark),

                  const SizedBox(height: 24),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSizes.pDefault,
                    ),
                    child: Text(
                      "Categories",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CategorySelector(
                    selectedCategory: _selectedFilterCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedFilterCategory =
                            _selectedFilterCategory == category
                            ? null
                            : category;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildRecentHeader(context),
                ],
              ),
            ),

            // --- SECTION 2: THE LIST (Scrollable Part) ---
            filteredExpenses.isEmpty
                ? SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      message: _selectedFilterCategory == null
                          ? "No expenses recorded yet"
                          : "No transactions in $_selectedFilterCategory",
                    ),
                  )
                : SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.pDefault,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final item = filteredExpenses[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TransactionCard(
                            expense: item,
                            onDelete: () => provider.deleteExpense(item.id),
                            onEdit: () => _showEditSheet(context, item),
                          ),
                        );
                      }, childCount: filteredExpenses.length),
                    ),
                  ),

            // Bottom spacing so FAB doesn't cover last item
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  // --- HELPER WIDGETS TO KEEP CODE CLEAN ---

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSizes.pDefault,
        10,
        AppSizes.pDefault,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello, Rumaisa",
                style: TextStyle(
                  fontSize: 16,
                  color: isDark
                      ? AppColors.dTextTertiary
                      : AppColors.lTextSecondary,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Manage Finances",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.settingScreen),
            icon: const Icon(
              Icons.settings_suggest_rounded,
              color: AppColors.primary,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBridge(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.pDefault),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.stats),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? AppColors.dSurface : AppColors.lSurface,
            borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            border: Border.all(
              color: isDark ? AppColors.dBorder : AppColors.lBorder,
            ),
          ),
          child: const Row(
            children: [
              Icon(Icons.insights_rounded, color: AppColors.primary),
              SizedBox(width: 12),
              Text(
                "Spending Analysis",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.pDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _selectedFilterCategory == null
                ? "Recent Activity"
                : "$_selectedFilterCategory",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.allExpense),
            child: const Text("See All"),
          ),
        ],
      ),
    );
  }

  void _showEditSheet(BuildContext context, dynamic item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditExpenseBottomSheet(expense: item),
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.pushNamed(context, AppRoutes.addExpense),
      backgroundColor: AppColors.primary,
      child: const Icon(Icons.add_rounded, color: Colors.white, size: 32),
    );
  }
}
