import 'package:expense_ledger_app/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GradientCard extends StatelessWidget {
  final String title;
  final double? amount;
  final String? subtitle;
  final IconData? icon;
  final TextEditingController? amountController;
  final bool isInputCard;

  const GradientCard({
    super.key,
    required this.title,
    this.amount,
    this.subtitle,
    this.icon,
    this.amountController,
    this.isInputCard = false,
  });

  // Factory constructor for display cards (Home & Stats screens)
  factory GradientCard.display({
    required String title,
    required double amount,
    String? subtitle,
    IconData? icon,
  }) {
    return GradientCard(
      title: title,
      amount: amount,
      subtitle: subtitle,
      icon: icon,
      isInputCard: false,
    );
  }

  // Factory constructor for input card (Add Expense screen)
  factory GradientCard.input({required TextEditingController controller}) {
    return GradientCard(
      title: 'How much?',
      amountController: controller,
      isInputCard: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isInputCard ? _buildInputContent() : _buildDisplayContent(),
    );
  }

  Widget _buildDisplayContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ] else ...[
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Amount display
        Text(
          'Rs ${amount?.toStringAsFixed(1) ?? '0.0'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),

        // Subtitle
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Colors.white.withValues(alpha: 0.5),
                size: 14,
              ),
              const SizedBox(width: 6),
              Text(
                subtitle!,
                style: TextStyle(
                  color: Colors.white.withValues(),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInputContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            hintText: '0',
            prefixText: 'Rs ',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            prefixStyle: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            hintStyle: TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
            errorStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Enter amount' : null,
        ),
      ],
    );
  }
}
