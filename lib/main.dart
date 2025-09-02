import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_page.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';
import 'screens/edit_profile_page.dart';
import 'screens/image_upload_page.dart';
import 'screens/scraping_page.dart';
import 'services/user_data_service.dart';
import 'services/auth_storage_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;
  bool _isLoading = true;
  final AuthStorageService _authStorage = AuthStorageService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // 로그인 상태 확인
  Future<void> _checkLoginStatus() async {
    try {
      // 토큰과 사용자 데이터 모두 확인
      final hasToken = await _authStorage.isLoggedIn();
      final hasUserData = await UserDataService.hasUserData();
      
      setState(() {
        _isLoggedIn = hasToken && hasUserData;
        _isLoading = false;
      });
      
      print('🔍 로그인 상태 확인: ${_isLoggedIn ? '로그인됨' : '로그인 안됨'}');
    } catch (e) {
      print('❌ 로그인 상태 확인 실패: $e');
      setState(() {
        _isLoggedIn = false;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyBiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      home: _isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _isLoggedIn
              ? MainPage(onLogout: _onLogout)
              : LoginPage(onLoginSuccess: _onLoginSuccess),
      routes: {
        '/login': (context) => LoginPage(onLoginSuccess: _onLoginSuccess),
        '/signup': (context) => const SignupPage(),
        '/main': (context) => const MainPage(),
        '/edit_profile': (context) => const EditProfilePage(),
        '/image_upload': (context) => const ImageUploadPage(),
        '/scraping': (context) => const ScrapingPage(),
      },
    );
  }

  // 로그인 성공 시 호출되는 콜백
  void _onLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  // 로그아웃 시 호출되는 콜백
  void _onLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }
}

 