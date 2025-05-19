import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String university;

  HomeScreen({required this.university});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'asset/img/${university}.png',
              height: 50,
            ),
            IconButton(
              icon: Icon(Icons.chat_bubble_outline),
              onPressed: () {
                // 채팅 버튼 기능 추가
              },
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 유저 프로필
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Color(0xFF948BFF), // 배경색 연보라색
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('asset/img/상명대학교.png'),
                  ),
                  SizedBox(width: 16), // 이미지와 텍스트 사이 간격
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User Name", // 유저 이름을 넣으세요
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Text(
                        "University Name", // 학교 이름을 넣으세요
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24), // 프로필 아래 여백

            // 날씨 위젯 추가
            WeatherWidget(),

            SizedBox(height: 30),

            // 교통수단 선택 (4개의 버튼을 2행 2열로 배치)
            GridView.count(
              crossAxisCount: 2, // 2열로 버튼 배치
              crossAxisSpacing: 16, // 버튼 간격
              mainAxisSpacing: 16, // 버튼 간격
              shrinkWrap: true, //
              children: [
                _buildGridButton(context, '실시간 교통 상황', '/traffic'),
                _buildGridButton(context, '셔틀 시간표', '/shuttle'),
                _buildGridButton(context, '지금 출발한다면?', '/길찾기'),
                _buildGridButton(context, 'ㅁㄹ','/ㅁㄹ'),
              ],
            ),
          ],
        ),
      ),
      // 하단 바 색상 변경 및 선택 시 색상 조정
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF948BFF), // 하단 바 배경색
        currentIndex: 0, //
        selectedItemColor: Colors.white, // 선택된 아이템 색상
        unselectedItemColor: Colors.white70, // 선택되지 않은 아이템 색상
        onTap: (index) {
          if (index == 0) {
            // 목록
          } else if (index == 1) {
            // 홈
          } else if (index == 2) {
            // 세팅
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '목록',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
    );
  }

  Widget _buildGridButton(BuildContext context, String title, String? route) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),  // 버튼들 사이 간격 조정
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFA7C7E7),  // 버튼 색상을 동일하게 설정
          padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32), // 버튼 패딩 크기 조정
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
        onPressed: route != null
            ? () {
          Navigator.pushNamed(context, route!, arguments: university,);
        }
            : null,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,  // 텍스트 색상 통일
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class WeatherWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 날씨
    String temperature = "25°C";
    String condition = "맑음";
    String city = "서울";

    return Container(
      padding: EdgeInsets.all(30.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.wb_sunny, size: 40, color: Colors.white),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                city,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "$temperature, $condition",
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
