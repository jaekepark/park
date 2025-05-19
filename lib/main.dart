import 'package:hackathon/screen/Start.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'firebase_options.dart';
import 'package:hackathon/screen/home.dart';
import 'package:hackathon/screen/shuttle.dart';


void main() async {
  KakaoSdk.init(
    nativeAppKey: '',
    javaScriptAppKey: '',
  ); // Kakao SDK 초기화
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
      home: HomeScreen(university: "상명대학교"), // 로그인 화면으로 시작
      routes: {
        '/shuttle': (context) => ShuttleScreen(),
      },
    );
  }
}
