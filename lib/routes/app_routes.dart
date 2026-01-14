import 'package:expense_ledger_app/screens/all_expenses_screen.dart';
import 'package:expense_ledger_app/screens/login_screen.dart';
import 'package:expense_ledger_app/screens/setting_screen.dart';
import 'package:expense_ledger_app/screens/sign_up_screen.dart';
import 'package:expense_ledger_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/add_expense_screen.dart';
import '../screens/stats_screen.dart';

class AppRoutes {
  // 1. Route Name Constants
  static const String home = '/';
  static const String addExpense = '/add-expense';
  static const String splashScreen = '/splash_screen';
  static const String allExpense = '/all_expenses';
  static const String stats = '/stats';
  static const String loginScreen = '/login';
  static const String signupScreen = '/sign_up';
  static const String settingScreen = '/settings';

  // 2. The Route Map
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      loginScreen: (context) => const LoginScreen(),
      settingScreen: (context) => const SettingsScreen(),
      signupScreen: (context) => const SignupScreen(),
      splashScreen: (context) => const SplashScreen(),
      home: (context) => const HomeScreen(),
      addExpense: (context) => const AddExpenseScreen(),

      allExpense: (context) => const AllExpensesScreen(),
      stats: (context) => const StatsScreen(),
    };
  }
}
