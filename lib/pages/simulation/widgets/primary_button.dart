
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? backgroundColor;
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
          color: backgroundColor,
        ),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(label, style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}
