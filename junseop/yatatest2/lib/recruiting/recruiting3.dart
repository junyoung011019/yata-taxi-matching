import 'package:flutter/material.dart';
import 'package:yatatest2/function/routing.dart';
import 'package:yatatest2/function/toastMessage.dart';
import '../function/userPost.dart';
class Recruiting3 extends StatefulWidget {
  final String roomTitle;
  final int partyCount;
  final String destination;
  final int startTime;
  const Recruiting3({super.key,
    required this.roomTitle, required this.partyCount, required this.destination, required this.startTime});

  @override
  State<Recruiting3> createState() => _Recruiting3State();
}

class _Recruiting3State extends State<Recruiting3> {
  UserPost user = new UserPost();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '모집 확인', // 중앙에 표시할 텍스트
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // 뒤로가기 아이콘
          onPressed: () {
            Navigator.of(context).pop(); // 뒤로가기 기능
          },
        ),
      ),
      body: GestureDetector(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                '방 제목:', // 상단 중앙에 표시할 텍스트
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 흰색 배경
                  borderRadius: BorderRadius.circular(20), // 테두리를 둥글게 만듦
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.3,
                ),
                child: Text(
                  widget.roomTitle, // 텍스트 내용
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black, // 검정색 글자
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                '인원 수', // 상단 중앙에 표시할 텍스트
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 흰색 배경
                  borderRadius: BorderRadius.circular(20), // 테두리를 둥글게 만듦
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.33,
                ),
                child: Text(
                  widget.partyCount.toString(), // 텍스트 내용
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black, // 검정색 글자
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                '목적지', // 상단 중앙에 표시할 텍스트
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 흰색 배경
                  borderRadius: BorderRadius.circular(20), // 테두리를 둥글게 만듦
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.19,
                ),
                child: Text(
                  widget.destination, // 텍스트 내용
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black, // 검정색 글자
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                '탑승 시간', // 상단 중앙에 표시할 텍스트
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, // 흰색 배경
                  borderRadius: BorderRadius.circular(20), // 테두리를 둥글게 만듦
                ),
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.01,
                  horizontal: MediaQuery.of(context).size.width * 0.28,
                ),
                child: Text(
                  '${widget.startTime.toString()}분후 탑승', // 텍스트 내용
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black, // 검정색 글자
                  ),
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      user.post_recruiting_dataa(widget.roomTitle, widget.partyCount, widget.destination, widget.startTime);
                      Navigator.popUntil(context, ModalRoute.withName("memberMain"));
                      handleAction(context, "채팅방",
                          roomTitle: widget.roomTitle,
                          partyCount: widget.partyCount,
                          destination: widget.destination,
                          startTime: widget.startTime);

                      showToast("방만들기 성공!");
                      print('확인 선택');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.25,
                        MediaQuery.of(context).size.height * 0.06,
                      ),
                      backgroundColor: Color(0xFFFAD232), // 확인 버튼 배경색 변경
                    ),
                    child: Text(
                      '확인',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black, // 검정색으로 변경
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
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
                      '취소',
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
    );
  }
}
