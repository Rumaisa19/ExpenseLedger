import 'package:expense_ledger_app/models/expense.dart';
import 'package:expense_ledger_app/providers/user_prefences_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'providers/expense_provider.dart';
import 'providers/theme_provider.dart';
import 'routes/app_routes.dart';
import 'utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // 1. Register Adapter
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ExpenseAdapter());
  }

  // 2. Open Box Safely with Types
  if (!Hive.isBoxOpen('expenses')) {
    await Hive.openBox<Expense>('expenses');
  }

  if (!Hive.isBoxOpen('settings')) {
    await Hive.openBox('settings'); // Keep dynamic if it's just simple settings
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpenseProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => UserPreferencesProvider(),
        ), // Add this!
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This will now work because ThemeProvider is in the MultiProvider above
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'Expense Ledger',
      debugShowCheckedModeBanner: false,

      // Use the themeMode from your ThemeProvider
      themeMode: themeProvider.themeMode,

      // Light Theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.lBackground,
        cardColor: AppColors.lSurface,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.lSurface,
          onSurface: AppColors.lTextPrimary, // Added for text visibility
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.lTextPrimary),
          bodyMedium: TextStyle(color: AppColors.lTextSecondary),
        ),
      ),

      // Dark Theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.dBackground,
        cardColor: AppColors.dSurface,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.dSurface,
          onSurface: AppColors.dTextPrimary, // Added for text visibility
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.dTextPrimary),
          bodyMedium: TextStyle(color: AppColors.dTextSecondary),
        ),
      ),

      initialRoute: AppRoutes.splashScreen,
      routes: AppRoutes.getRoutes(), // Better practice
      // If you prefer your existing list, keep: routes: AppRoutes.getRoutes(),
    );
  }
}
