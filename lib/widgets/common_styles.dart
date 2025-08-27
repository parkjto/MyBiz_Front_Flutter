import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonStyles {
  // Colors
  static const Color primaryColor = Color(0xFF0084FF);
  static const Color primaryLightColor = Color(0xFF00AEFF);
  static const Color borderColor = Color(0xFFE0E0E0);
  
  // Brand Gradient
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF00AEFF), Color(0xFF0084FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  // Spacing
  static const double sectionGap = 12.0;
  static const EdgeInsets sectionPadding = EdgeInsets.all(20.0);
  
  // Text Styles
  static final TextStyle titleStyle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
    color: const Color(0xFF333333),
  );
  
  static final TextStyle labelStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.8,
    color: const Color(0xFF9AA0A6),
  );
  
  static final TextStyle contentStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.8,
    color: const Color(0xFF333333),
  );
  
  // Decorations
  static BoxDecoration sectionBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }
  
  static Widget divider() {
    return Container(
      height: 1,
      color: const Color(0xFFF0F0F0),
      margin: const EdgeInsets.symmetric(vertical: 10),
    );
  }
} 