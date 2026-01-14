import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // Uses a hint of the primary color for the shadow to look cleaner in Light Mode
            color: theme.colorScheme.primary.withOpacity(isDark ? 0.12 : 0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        maxLines: widget.maxLines,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        obscureText: widget.isPassword && !_isPasswordVisible,

        // Fix: Reset focus when tapping outside to help avoid keyboard sync bugs
        onTapOutside: (event) => FocusScope.of(context).unfocus(),

        style: TextStyle(
          fontSize: 16,
          color: onSurface,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: onSurface.withOpacity(0.4),
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: theme.colorScheme.primary,
            size: 22,
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 20,
                    color: theme.colorScheme.primary.withOpacity(0.7),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.transparent,

          // Borders
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),

          // Error Styling
          errorStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.redAccent,
            height: 1.0,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
