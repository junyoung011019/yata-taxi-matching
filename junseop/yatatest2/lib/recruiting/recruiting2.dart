import 'package:flutter/material.dart';
import 'package:yatatest2/function/routing.dart';

class Recruiting2 extends StatefulWidget {
  final String roomTitle;
  final int partyCount;

  const Recruiting2(
      {super.key, required this.roomTitle, required this.partyCount});

  @override
  State<Recruiting2> createState() => _Recruiting2State();
}

class _Recruiting2State extends State<Recruiting2> {
  int selectedRouteButtonIndex = 0; // 경로 버튼의 선택 상태를 추적
  int selectedTimeButtonIndex = 0;
  String destination = "school";
  int startTime = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('모집하기2'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          print('모집하기2 화면');
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFFFBFFCC),
            border: Border.all(
              color: Color(0xFFFAD232),
              width: 5,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                // Container(
                //   width: MediaQuery.of(context).size.width * 0.7,
                //   height: MediaQuery.of(context).size.height * 0.08,
                //   decoration: BoxDecoration(
                //     color: Color(0xFFFAD232),
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   padding: EdgeInsets.all(10),
                //   child: Center(
                //     child: Text(
                //       '모집 설정',
                //       style: TextStyle(
                //         fontSize: 24,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Text(
                  '경로 설정',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05 > 30
                        ? 30
                        : MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 2,
                  color: Color(0xFFFAD232),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        destination = "school";
                        setState(() {
                          selectedRouteButtonIndex = 0;
                        });
                        print('성환역 -> 남서울대학교 버튼 선택');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: selectedRouteButtonIndex == 0
                            ? Color(0xFFFAD232)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      child: Text(
                        '성환역 -> 남서울대학교',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    ElevatedButton(
                      onPressed: () {
                        destination = "station";
                        setState(() {
                          selectedRouteButtonIndex = 1;
                        });
                        print('남서울대학교 -> 성환역 버튼 선택');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: selectedRouteButtonIndex == 1
                            ? Color(0xFFFAD232)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.7,
                          MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      child: Text(
                        '남서울대학교 -> 성환역',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                Text(
                  '예상 탑승 시간',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.05 > 30
                        ? 30
                        : MediaQuery.of(context).size.width * 0.04,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 2,
                  color: Color(0xFFFAD232),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        startTime = 5;
                        setState(() {
                          selectedTimeButtonIndex = 0;
                        });
                        print('5분 후 선택');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: selectedTimeButtonIndex == 0
                            ? Color(0xFFFAD232)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      child: Text(
                        '5분 후',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        startTime = 10;
                        setState(() {
                          selectedTimeButtonIndex = 1;
                        });
                        print('10분 후 선택');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: selectedTimeButtonIndex == 1
                            ? Color(0xFFFAD232)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      child: Text(
                        '10분 후',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        startTime = 15;
                        setState(() {
                          selectedTimeButtonIndex = 2;
                        });
                        print('15분 후 선택');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: selectedTimeButtonIndex == 2
                            ? Color(0xFFFAD232)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      child: Text(
                        '15분 후',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        startTime = 20;
                        setState(() {
                          selectedTimeButtonIndex = 3;
                        });
                        print('20분 후 선택');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: selectedTimeButtonIndex == 3
                            ? Color(0xFFFAD232)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      child: Text(
                        '20분 후',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        startTime = 25;
                        setState(() {
                          selectedTimeButtonIndex = 4;
                        });
                        print('25분 후 선택');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: selectedTimeButtonIndex == 4
                            ? Color(0xFFFAD232)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      child: Text(
                        '25분 후',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        startTime = 30;
                        setState(() {
                          selectedTimeButtonIndex = 5;
                        });
                        print('30분 후 선택');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: selectedTimeButtonIndex == 5
                            ? Color(0xFFFAD232)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.2,
                          MediaQuery.of(context).size.height * 0.08,
                        ),
                      ),
                      child: Text(
                        '30분 후',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        handleAction(
                          context,
                          "모집하기3",
                          roomTitle: widget.roomTitle,
                          partyCount: widget.partyCount,
                          destination: destination,
                          startTime: startTime,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xFFFAD232),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      child: Text(
                        '다음',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        print('취소');
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Color(0xFF666666),
                        backgroundColor: Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        minimumSize: Size(
                          MediaQuery.of(context).size.width * 0.25,
                          MediaQuery.of(context).size.height * 0.06,
                        ),
                      ),
                      child: Text(
                        '이전',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
