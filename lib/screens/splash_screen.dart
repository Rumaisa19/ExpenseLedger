import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/app_constants.dart';
import '../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Navigate to Home after 3 seconds
    // Inside _SplashScreenState -> initState
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Change AppRoutes.home to AppRoutes.login
        Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dBackground : AppColors.lBackground,
      body: Stack(
        children: [
          // Subtle Background Gradient Circle
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.primaryGradient,
                color: AppColors.primary,
              ),
            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo Container
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 64,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // App Name
                    Text(
                      "Expense Ledger",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: isDark
                            ? AppColors.dTextPrimary
                            : AppColors.lTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Smart Financial Tracking",
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.dTextTertiary
                            : AppColors.lTextSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Version or Loading indicator
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    SizedBox(
                      width: 40,
                      child: LinearProgressIndicator(
                        backgroundColor: AppColors.primary.withValues(
                          alpha: 0.1,
                        ),
                        color: AppColors.primary,
                        minHeight: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "v 1.0.0",
                      style: TextStyle(
                        color: isDark
                            ? AppColors.dTextTertiary
                            : AppColors.lTextTertiary,
                        fontSize: 12,
                      ),
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
