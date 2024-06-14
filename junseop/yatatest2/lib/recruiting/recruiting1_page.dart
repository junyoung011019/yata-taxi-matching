import 'package:flutter/material.dart';
import 'package:yatatest2/function/toastMessage.dart';
import '../function/routing.dart';

class Recruiting1 extends StatefulWidget {
  const Recruiting1({super.key});

  @override
  State<Recruiting1> createState() => _Recruiting1State();
}

class _Recruiting1State extends State<Recruiting1> {
  int selectedButtonIndex = 0; // 선택된 버튼의 인덱스를 추적
  final _textController = TextEditingController();
  int MaxCount = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('모집하기'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Text(
                    '방 제목 설정',
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
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 80),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Color(0xFFD9D7DC),
                              width: 4,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                              maxLength: 10,
                              maxLines: null,
                              controller: _textController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "방 제목",
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        _textController.clear();
                                      },
                                      icon: const Icon(Icons.clear)))
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  // 입력된 제목이 없을 때 메시지를 보여줌
                  SizedBox(height: MediaQuery.of(context).size.height * 0.13),
                  Text(
                    '인원수 설정',
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
                          MaxCount = 2;
                          setState(() {
                            selectedButtonIndex = 0; // 2명 버튼이 선택됨
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: selectedButtonIndex == 0
                              ? Color(0xFFFAD232)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.15,
                            MediaQuery.of(context).size.height * 0.06,
                          ),
                        ),
                        child: Text(
                          '2명',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          MaxCount = 3;
                          setState(() {
                            selectedButtonIndex = 1; // 3명 버튼이 선택됨
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: selectedButtonIndex == 1
                              ? Color(0xFFFAD232)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.15,
                            MediaQuery.of(context).size.height * 0.06,
                          ),
                        ),
                        child: Text(
                          '3명',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          MaxCount = 4;
                          setState(() {
                            selectedButtonIndex = 2; // 4명 버튼이 선택됨
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: selectedButtonIndex == 2
                              ? Color(0xFFFAD232)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.15,
                            MediaQuery.of(context).size.height * 0.06,
                          ),
                        ),
                        child: Text(
                          '4명',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // 다음 버튼이 눌렸을 때 동작
                          if(_textController.text.length < 1 || _textController.text.trim().isEmpty)
                            showSnackBar(context, "방제목을 올바르게 입력해주세요");
                          else {
                            handleAction(context, "모집하기2", roomTitle: _textController.text, MaxCount: MaxCount);
                          }
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
                          // 취소 버튼이 눌렸을 때 동작
                          Navigator.pop(context);
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
        ),
      ),
    );
  }
}
