import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/ad_creation_page.dart';
import 'screens/revenue_analysis_page.dart';
import 'screens/review_analysis_page.dart';
import 'screens/mypage.dart';
import 'screens/government_policy_page.dart';
import 'screens/naver_link_page.dart';
import 'screens/image_upload_page.dart';
import 'screens/scraping_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.inter().fontFamily,
        scaffoldBackgroundColor: const Color(0xFFF4F5FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/main': (context) => const MainPage(),
        '/ad_creation': (context) => const AdCreationPage(),
        '/revenue_analysis': (context) => const RevenueAnalysisPage(),
        '/review_analysis': (context) => const ReviewAnalysisPage(),
        '/mypage': (context) => const MyPage(),
        '/government_policy': (context) => const GovernmentPolicyPage(),
        '/naver_link': (context) => const NaverLinkPage(),
        '/image_upload': (context) => const ImageUploadPage(),
        '/scraping': (context) => const ScrapingPage(),
      },
    );
  }
}

 