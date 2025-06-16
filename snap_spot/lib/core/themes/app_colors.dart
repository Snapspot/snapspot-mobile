// lib/core/themes/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Màu nền chính
  static const Color background = Color(0xFFFAFAF0); // Lightened Be/Cream
  // static const Color background = Color(0xFF212529); //Dark mode

  // Màu chủ đạo
  static const Color primary = Color(0xFF006D77); // Xanh biển đậm
  static const Color accent = Color(0xFF83C5BE); // Xanh biển nhạt
  static const Color green = Color(0xFF215858); // Xanh đậm (used for drawer header)

  // Màu văn bản
  static const Color textPrimary = Color(0xFF1A252F); // Darker, more saturated
  static const Color textSecondary = Color(0xFF5A6772); // Slightly desaturated grey

  // Màu trắng/đen tiêu chuẩn
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Màu xám dùng cho icon hoặc border
  static const Color gray = Color(0xFFA0AEC0); // Mid-tone grey
  static const Color lightGray = Color(0xFFE2E8F0); // Lighter grey for borders/dividers

  // Màu overlay
  static const Color overlay = Colors.black54; // Standard overlay

  // Màu shadow nhẹ
  static const Color shadow = Color(0x1A000000); // 10% black (same as original)

  // Màu vàng cho sao đánh giá
  static const Color starYellow = Color(0xFFFFC107); // Standard Amber

  // Màu cho nút "Xem vị trí" và "Viết đánh giá"
  static const Color buttonBlue = Color(0xFF007BFF); // Standard blue (same as original)
  static const Color buttonRed = Color(0xFFDC3545); // Standard red for destructive actions
  static const Color buttonGreen = Color(0xFF28A745); // Standard green for positive actions
}