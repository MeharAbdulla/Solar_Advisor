import 'package:flutter/material.dart';

class AppColors {
  static const Color brandGreen = Color(0xFF10B981);
  static const Color brandBlue = Color(0xFF3B82F6);
  static const Color bgLight = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textGray = Color(0xFF64748B);
  static const Color cardBorder = Color(0xFFE2E8F0);
  
  static LinearGradient get brandGradient => const LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [brandGreen, brandBlue],
  );
}
