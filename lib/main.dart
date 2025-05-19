import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hackathon/screen/Start.dart';
import 'package:hackathon/screen/home.dart';
import 'package:hackathon/screen/chat_message.dart';
import 'package:hackathon/screen/Real_time_traffic.dart';
import 'package:hackathon/screen/shuttle.dart'; // ✅ 셔틀 스크린 추가
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'firebase_options.dart';

void main() async {
  KakaoSdk.init(
    nativeAppKey: '', // 카카오 네이티브 앱 키 입력
    javaScriptAppKey: '', // 필요 시 자바스크립트 앱 키 입력
  );

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(), // 시작 화면
      onGenerateRoute: (RouteSettings settings) {
        final args = settings.arguments;

        // ✅ 셔틀버스 시간표 화면
        if (settings.name == '/shuttle') {
          if (args is String) {
            return MaterialPageRoute(
              builder: (context) => ShuttleScreen(), // 내부에서 university 가져올 수 있게 되어 있지
              settings: RouteSettings(arguments: args),
            );
          } else {
            return _errorPage('대학교 이름이 잘못 전달되었습니다');
          }
        }

        // ✅ 소통 채팅 화면
        if (settings.name == '/소통') {
          if (args is Map<String, dynamic> && args.containsKey('university')) {
            return MaterialPageRoute(
              builder: (context) => ChatPage(university: args['university']),
            );
          } else {
            return _errorPage('대학 이름이 전달되지 않았습니다');
          }
        }

        // ✅ 실시간 교통 화면
        if (settings.name == '/traffic') {
          if (args is String) {
            return MaterialPageRoute(
              builder: (context) => RealTimeTrafficScreen(university: args),
            );
          } else {
            return _errorPage('대학교 이름이 잘못 전달되었습니다');
          }
        }

        return null;
      },
    );
  }

  // ✅ 에러 메시지용 공통 페이지
  MaterialPageRoute _errorPage(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text(message, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}