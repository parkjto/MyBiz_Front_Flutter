import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class CommonStyles {
  // Colors
  static const Color primaryColor = Color(0xFF0084FF);
  static const Color primaryLightColor = Color(0xFF00AEFF);
  static const Color borderColor = Color(0xFFE0E0E0);
  
  // Brand Gradient
  static const LinearGradient brandGradient = LinearGradient(
    colors: [Color(0xFF2D6EFF), Color(0xFF6AA8FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Spacing
  static const double sectionGap = 12.0;
  static const EdgeInsets sectionPadding = EdgeInsets.all(20.0);
  
  // Border Radius Standards
  static const double inputRadius = 12.0;        // Input fields, buttons
  static const double cardRadius = 12.0;         // Cards, containers
  static const double dialogRadius = 16.0;       // Dialogs, modals
  static const double buttonRadius = 8.0;       // Action buttons
  static const double chipRadius = 8.0;          // Chips, tags
  static const double avatarRadius = 24.0;       // Profile images, large icons
  
  // Text Styles
  static final TextStyle titleStyle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.55,
    color: const Color(0xFF333333),
  );
  
  static final TextStyle labelStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.55,
    color: const Color(0xFF9AA0A6),
  );
  
  static final TextStyle contentStyle = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.55,
    color: const Color(0xFF333333),
  );
  
  // Decorations
  static BoxDecoration sectionBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(cardRadius),
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