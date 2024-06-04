import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yatatest2/function/routing.dart';
import 'package:yatatest2/function/userPost.dart';

class QuickMatch extends StatefulWidget {
  const QuickMatch({Key? key}) : super(key: key);

  @override
  _QuickMatchState createState() => _QuickMatchState();
}

class _QuickMatchState extends State<QuickMatch> {
  String _selectedPriority1 = '학교'; // 선택된 우선순위를 추적하기 위한 변수
  String _selectedPriority2 = 'HighestCount';
  UserPost user = new UserPost();
  final storage = new FlutterSecureStorage();
  late Map<String, dynamic> roomData;

  Future<void> fetchRoomData(String destination, String matchingMethod) async {
    Map<String, dynamic>? fetchedRoomData = await user.post_matching_data(context, destination, matchingMethod);
    if (fetchedRoomData != null) {
      setState(() {
        roomData = fetchedRoomData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('빠른매칭 설정'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xFFFBFFCC),
          border: Border.all(
            color: Color(0xFFFAD232),
            width: 5,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '목적지 설정',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedPriority1 = '학교'; // 성환역 -> 남서울대학교 버튼이 눌렸을 때 다른 버튼 색상 초기화
                      });
                      print('성환역 -> 남서울대학교');
                    },
                    icon: Icon(Icons.local_taxi),
                    label: Text('성환역 -> 남서울대학교'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPriority1 == '학교' ? Color(0xFFFAD232) : null, // 선택된 우선순위일 때 파란색으로 변경
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedPriority1 = '성환역'; // 남서울대학교 -> 성환역 버튼이 눌렸을 때 다른 버튼 색상 초기화
                      });
                      print('남서울대학교 -> 성환역');
                    },
                    icon: Icon(Icons.local_taxi),
                    label: Text('남서울대학교 -> 성환역'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPriority1 == '성환역' ? Color(0xFFFAD232) : null, // 선택된 우선순위일 때 파란색으로 변경
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    '우선순위 설정',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedPriority2 = 'HighestCount'; // 인원 우선 버튼이 눌렸을 때 다른 버튼 색상 초기화
                      });
                      print('인원 우선');
                    },
                    icon: Icon(Icons.people),
                    label: Text('인원 우선'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor : _selectedPriority2 == 'HighestCount' ? Color(0xFFFAD232) : null, // 선택된 우선순위일 때 파란색으로 변경
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedPriority2 = 'EarliestTime'; // 시간 우선 버튼이 눌렸을 때 다른 버튼 색상 초기화
                      });
                      print('시간 우선');
                    },
                    icon: Icon(Icons.access_time),
                    label: Text('시간 우선'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedPriority2 == 'EarliestTime' ? Color(0xFFFAD232) : null, // 선택된 우선순위일 때 파란색으로 변경
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    String? accessToken = await storage.read(key: 'ACCESS_TOKEN');
                    if(accessToken == null) accessToken = '';
                    print('매칭시작');
                    print(_selectedPriority1);
                    print(_selectedPriority2);
                    await fetchRoomData(_selectedPriority1, _selectedPriority2);
                    print(roomData);
                    print("룸 타이틀: ${roomData['roomTitle']}");
                    handleAction(context, "채팅방",
                        roomTitle: roomData['roomTitle'],
                        MaxCount: roomData['MaxCount'],
                        destination: roomData['destination'],
                        startTime: roomData['startTime'],
                        accessToken: accessToken,
                        roomId: roomData['roomId'],
                        creation: false,
                        );
                  },
                  child: Text('매칭시작'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    print('취소');
                  },
                  child: Text('취소'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
