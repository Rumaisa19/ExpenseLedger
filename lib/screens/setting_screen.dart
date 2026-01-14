import 'package:expense_ledger_app/providers/user_prefences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/app_constants.dart';
import '../routes/app_routes.dart';
import '../providers/theme_provider.dart';
import '../providers/expense_provider.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Edit Profile Dialog
  void _showEditProfileDialog(BuildContext context) {
    final userPref = context.read<UserPreferencesProvider>();
    // Pre-filling controllers with provider data
    final nameController = TextEditingController(text: "Rumaisa Mushtaq");
    final emailController = TextEditingController(
      text: "romaisamushtaq@gmail.com",
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Profile'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              userPref.updateUserProfile(
                nameController.text.trim(),
                emailController.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UserPreferencesProvider>().clearAllData();
              Navigator.pop(ctx);
              Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.pDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 1. ACCOUNT SECTION
              _buildSectionTitle("Account"),

              // Custom Profile Card with requested Name and Email
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.dSurface : AppColors.lSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark ? AppColors.dBorder : AppColors.lBorder,
                  ),
                ),
                child: ListTile(
                  onTap: () => _showEditProfileDialog(context),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                  title: const Text(
                    "Rumaisa Mushtaq",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('romaisamushtaq@gmail.com'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),

              const SizedBox(height: 24),

              // 2. PREFERENCES SECTION
              _buildSectionTitle("Preferences"),
              _buildSettingTile(
                icon: Icons.palette_outlined,
                title: "Appearance",
                subtitle: themeProvider.themeMode == ThemeMode.dark
                    ? 'Dark Mode'
                    : 'Light Mode',
                onTap: () => _showAppearanceDialog(context),
                isDark: isDark,
              ),

              const SizedBox(height: 24),

              // 3. DATA & SECURITY
              _buildSectionTitle("Data & Security"),
              _buildSettingTile(
                icon: Icons.cloud_upload_outlined,
                title: "Export Data",
                onTap: () => _exportDataAsCSV(context),
                isDark: isDark,
              ),

              const SizedBox(height: 40),

              // 4. LOGOUT
              Center(
                child: TextButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                  ),
                  label: const Text(
                    "Log Out",
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.dSurface : AppColors.lSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.dBorder : AppColors.lBorder,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: subtitle != null
            ? Text(subtitle, style: const TextStyle(fontSize: 13))
            : null,
        trailing: Icon(
          Icons.chevron_right_rounded,
          color: isDark ? Colors.white30 : Colors.black26,
        ),
      ),
    );
  }
}

void _showAppearanceDialog(BuildContext context) {
  final themeProvider = context.read<ThemeProvider>();

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Choose Theme'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: themeProvider.themeMode,
            onChanged: (value) {
              themeProvider.setThemeMode(value!);
              Navigator.pop(ctx);
            },
            activeColor: AppColors.primary,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: themeProvider.themeMode,
            onChanged: (value) {
              themeProvider.setThemeMode(value!);
              Navigator.pop(ctx);
            },
            activeColor: AppColors.primary,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System Default'),
            value: ThemeMode.system,
            groupValue: themeProvider.themeMode,
            onChanged: (value) {
              themeProvider.setThemeMode(value!);
              Navigator.pop(ctx);
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    ),
  );
}

Future<void> _exportDataAsCSV(BuildContext context) async {
  final expenses = context.read<ExpenseProvider>().expenses;

  if (expenses.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('No expenses to export'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    return;
  }

  try {
    // 1. Create CSV Header and Content
    String csvContent = 'Date,Title,Category,Amount,Description\n';
    for (var expense in expenses) {
      // Sanitize strings by removing commas to avoid breaking CSV format
      final title = expense.title.replaceAll(',', ' ');
      final category = expense.category.replaceAll(',', ' ');
      final description = (expense.description ?? '').replaceAll(',', ' ');

      csvContent +=
          '${expense.date.toString().split(' ')[0]},'
          '"$title",'
          '$category,'
          '${expense.amount},'
          '"$description"\n';
    }

    // 2. Get the temporary directory to save the file
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/Rumaisa_Expense_Report.csv');

    // 3. Write the string to the file
    await file.writeAsString(csvContent);

    // 4. Share the file using share_plus
    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'My Expense Report - Generated by Ledger App');
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Export failed: $e'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
