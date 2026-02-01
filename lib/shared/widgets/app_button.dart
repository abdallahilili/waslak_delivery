import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final bool fullWidth;
  final double? width;
  final double? height;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.fullWidth = false,
    this.width = 150,
    this.height = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // If no specific color is asked, we use the theme's button style (usually Primary Color)
    // If a specific color is asked, we override it.
    
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // Use theme default (null) if no prop provided
        backgroundColor: backgroundColor, 
        foregroundColor: textColor,
        minimumSize: fullWidth
            ? const Size(double.infinity, 50)
            : Size(width ?? 150, height ?? 50),
        elevation: 0, 
        // Corner radius is handled by theme, but we can keep explicit if needed or remove to use theme
        // Theme uses 12, this used 20. Let's stick to theme generally, but if we pass null it uses theme.
        shape: backgroundColor != null ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)) : null,
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                // Inherits font family from theme (Poppins)
                fontWeight: FontWeight.bold,
                fontSize: 16, // Standardize size
                color: textColor, // Inherits from foregroundColor if null
              ),
            ),
    );
  }
}
