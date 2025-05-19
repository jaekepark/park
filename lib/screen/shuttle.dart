import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ShuttleScreen extends StatefulWidget {
  @override
  _ShuttleScreenState createState() => _ShuttleScreenState();
}

class _ShuttleScreenState extends State<ShuttleScreen> {
  String selectedPeriod = '전체';
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final String university = ModalRoute.of(context)?.settings.arguments as String? ?? '학교';

    return Scaffold(
      backgroundColor: Color(0xFF948BFF),
      appBar: AppBar(
        backgroundColor: Color(0xFF948BFF),
        title: Text(
          '$university 셔틀 시간표',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('universities')
            .doc(university)
            .collection('shuttle_schedule')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다.', style: TextStyle(color: Colors.white)));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(child: Text('셔틀 시간표 데이터가 없습니다.', style: TextStyle(color: Colors.white)));
          }

          docs.sort((a, b) {
            final aMap = a.data() as Map<String, dynamic>;
            final bMap = b.data() as Map<String, dynamic>;
            final aBus = aMap['bus_number']?.toString() ?? '0';
            final bBus = bMap['bus_number']?.toString() ?? '0';
            final aNum = int.tryParse(RegExp(r'\d+').firstMatch(aBus)?.group(0) ?? '0') ?? 0;
            final bNum = int.tryParse(RegExp(r'\d+').firstMatch(bBus)?.group(0) ?? '0') ?? 0;
            return aNum.compareTo(bNum);
          });

          final filteredDocs = docs.where((doc) {
            final item = doc.data() as Map<String, dynamic>;
            final time = item['departure_time']?.toString() ?? '';
            if (selectedPeriod == '전체' || time.isEmpty) return true;
            final hour = int.tryParse(time.split(':').first) ?? 0;
            return selectedPeriod == '오전' ? hour < 12 : hour >= 12;
          }).toList();

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              Center(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 8.0,
                  children: ['전체', '오전', '오후'].map((period) {
                    return ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedPeriod = period;
                          _expandedIndex = -1;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedPeriod == period ? Colors.amber : Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(period),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              ...filteredDocs.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value.data() as Map<String, dynamic>;

                final busNumber = item['bus_number'] ?? '';
                final departureTime = item['departure_time'] ?? '';
                final arrivalTime = item['arrival_time'] ?? '';
                final departure = item['departure'] ?? '';
                final arrival = item['arrival'] ?? '';
                final intermediate = item['intermediate_stop'] ?? '';
                final stops = item['stops'];
                final note = item['note'] ?? '';
                final day = item['day'] ?? '';
                final isExpanded = _expandedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Card(
                    color: isExpanded ? Colors.amber.shade100 : Colors.white,
                    elevation: 4,
                    shadowColor: Color(0xFFBDB2FF),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Theme(
                      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        key: PageStorageKey(index),
                        initiallyExpanded: isExpanded,
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _expandedIndex = expanded ? index : -1;
                          });
                        },
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_bus, color: Colors.deepPurpleAccent),
                            SizedBox(width: 6),
                            CircleAvatar(
                              backgroundColor: Colors.deepPurpleAccent,
                              foregroundColor: Colors.white,
                              radius: 16,
                              child: Text('$busNumber', style: TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(),
                            Text(
                              '$departureTime 출발',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('출발역: $departure', style: TextStyle(fontSize: 16)),
                                if (arrival.isNotEmpty) Text('도착역: $arrival', style: TextStyle(fontSize: 16)),
                                if (arrivalTime.isNotEmpty) Text('도착시간: $arrivalTime', style: TextStyle(fontSize: 16)),
                                if (intermediate.isNotEmpty) Text('경유정보: $intermediate', style: TextStyle(fontSize: 16)),
                                Text('운행 요일: $day', style: TextStyle(fontSize: 16)),
                                if (stops != null && stops is List && stops.isNotEmpty) ...[
                                  SizedBox(height: 8),
                                  Text('정차지점:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                  ...stops.map((stop) {
                                    if (stop is Map<String, dynamic>) {
                                      return Text('- ${stop['location']} (${stop['time']})', style: TextStyle(fontSize: 15));
                                    } else if (stop is String) {
                                      return Text('- $stop', style: TextStyle(fontSize: 15));
                                    } else {
                                      return SizedBox.shrink(); // 예외 처리
                                    }
                                  }).toList(),
                                ],
                                if (note.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text('비고: $note', style: TextStyle(fontSize: 14, color: Colors.redAccent)),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}