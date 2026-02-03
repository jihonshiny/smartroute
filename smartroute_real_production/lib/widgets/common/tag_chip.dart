import 'package:flutter/material.dart';
import '../../app/theme.dart';

class TagChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  final bool isSelected;

  const TagChip({
    super.key,
    required this.label,
    this.onTap,
    this.color,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppTheme.accent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : chipColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? chipColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isSelected ? Colors.white : chipColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
