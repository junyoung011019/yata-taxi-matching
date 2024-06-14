
import 'package:flutter/material.dart';
import 'package:yatatest2/struct/userState.dart';
import 'function/routing.dart';
import 'function/userPost.dart';
import 'function/toastMessage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _nickPressed = false; // 닉네임 중복 색깔
  bool _emailPressed = false;
  final _emailcode = TextEditingController();
  final List<String> _bankList = <String>["국민", "우리", "하나", "카카오뱅크", "신한", "기업", "농협"];
  String _selectbank = "국민";
  final List<TextEditingController> _textControllers =
  List.generate(7, (index) => TextEditingController());
  UserPost user = UserPost();
  List<String> userInfo = [];

  void initState() {
    super.initState();
    _selectbank = _bankList[0];
    _textControllers[6].text = _selectbank;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // 화면 자동 스크롤 비활성화
      appBar: AppBar(
        title: Text(
          '회원가입',
          style: TextStyle(
            fontSize: 20, // 텍스트 크기 조정
            fontWeight: FontWeight.bold, // 굵은 글꼴
            color: Colors.black87, // 텍스트 색상 조정
          ),
        ),

        centerTitle: true,
        // 제목 가운데 정렬
        backgroundColor: Colors.white,
        // 배경색 조정
        elevation: 0,
        // 그림자 없애기
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Color(0xFFFAD232),
                width: 5,
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.07),
                    child: Text(
                      '학교 이메일',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03 > 30
                            ? 30
                            : MediaQuery.of(context).size.width * 0.03,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.07),
                          child: TextFormField(
                            maxLines: null,
                            controller: _textControllers[0],
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _textControllers[0].clear();
                                },
                                icon: const Icon(Icons.clear),
                              ),
                              hintText: 'email',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(width: 2),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_textControllers[0].text == "" ||
                              _textControllers[0].text.contains(' ') ||
                              !(_textControllers[0]
                                  .text
                                  .contains('@nsu.ac.kr'))) {
                            showSnackBar(context, "학교 이메일을 올바르게 입력해주세요!");
                          } else {
                            user.univ_email(_textControllers[0].text);
                            showToast("인증번호 전송!");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFFFAD232), // 글자색 조정
                          padding: EdgeInsets.symmetric(
                            vertical: 20, // 세로 길이 조정
                            horizontal: 20, // 가로 길이 조정
                          ),
                        ),
                        child: Text('인증번호 전송'),
                      ),
                      SizedBox(width: 25), // 오른쪽 마진 추가
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.07),
                          child: TextFormField(
                            maxLines: null,
                            controller: _emailcode,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _emailcode.clear();
                                },
                                icon: const Icon(Icons.clear),
                              ),
                              hintText: '인증코드 입력',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _emailPressed ? null : () async {
                          if (_emailcode.text == "") {
                            showSnackBar(context, "인증번호를 입력하세요");
                            setState(() {
                              _emailPressed = false;
                            });
                          } else {
                            user_state.email_check = await user.univ_email_check(
                                _textControllers[0].text,
                                int.parse(_emailcode.text));
                            if (!user_state.email_check) {
                              showSnackBar(context, "인증번호가 틀렸습니다");
                              setState(() {
                                _emailPressed = false;
                              });
                            } else {
                              setState(() {
                                _emailPressed = true;
                                showToast("인증 성공!");
                              });
                            }
                          }
                        },
                        style: ButtonStyle(
                          foregroundColor: WidgetStateProperty.all<Color>(Colors.white), // 글자색
                          backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              if (states.contains(WidgetState.disabled)) {
                                return Color(0xFFFAD232); // 버튼이 비활성화될 때 오렌지색
                              }
                              return Colors.grey; // 기본 배경색 (활성화 상태)
                            },
                          ),
                          padding: WidgetStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(
                              vertical: 20, // 세로 길이
                              horizontal: 20, // 가로 길이
                            ),
                          ),
                        ),
                        child: Text('인증확인'),
                      ),

                      SizedBox(width: 25), // 오른쪽 마진 추가
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.07),
                          child: TextFormField(
                            maxLines: null,
                            controller: _textControllers[1],
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _textControllers[1].clear();
                                },
                                icon: const Icon(Icons.clear),
                              ),
                              hintText: 'password',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.07),
                          child: TextFormField(
                            maxLines: null,
                            maxLength: 8,
                            controller: _textControllers[3],
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _textControllers[3].clear();
                                },
                                icon: const Icon(Icons.clear),
                              ),
                              hintText: '닉네임(2~8자)',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        key: GlobalKey(),
                        onPressed: () async {
                          if (_textControllers[3].text == "" ||
                              _textControllers[3].text.length < 2 ||
                              _textControllers[3].text.contains(' ')) {
                            showSnackBar(context, '닉네임 사용불가');
                            setState(() {
                              _nickPressed = false;
                            });
                          } else {
                            user_state.nick_available = await user
                                .nickName_check(_textControllers[3].text);
                            if (!user_state.nick_available) {
                              showSnackBar(context, '닉네임이 중복되었습니다.');
                              setState(() {
                                _nickPressed = false;
                              });
                            } else {
                              setState(() {
                                _nickPressed = true;
                                showToast("닉네임 사용가능!");
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor:
                          _nickPressed ? Color(0xFFFAD232) : Colors.grey, // 글자색 조정
                          padding: EdgeInsets.symmetric(
                            vertical: 20, // 세로 길이 조정
                            horizontal: 20, // 가로 길이 조정
                          ),
                        ),
                        child: Text('중복확인'),
                      ),
                      SizedBox(width: 25), // 오른쪽 마진 추가
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.07),
                          child: TextFormField(
                            maxLines: null,
                            controller: _textControllers[2],
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _textControllers[2].clear();
                                  },
                                  icon: const Icon(Icons.clear)),
                              hintText: '이름',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.07),
                          child: TextFormField(
                            maxLines: null,
                            maxLength: 11,
                            controller: _textControllers[4],
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _textControllers[4].clear();
                                  },
                                  icon: const Icon(Icons.clear)),
                              hintText: '전화번호',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.07),
                    child: Text(
                      '은행 선택',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.03 > 30
                            ? 30
                            : MediaQuery.of(context).size.width * 0.03,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.07),
                          child: DropdownButtonFormField(
                            value: _selectbank,
                            items: _bankList
                                .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _selectbank = value;
                                  _textControllers[6].text = _selectbank;
                                });
                              }
                            },
                            // 드롭다운 버튼 테마 설정
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width * 0.07),
                          child: TextFormField(
                            maxLines: null,
                            controller: _textControllers[5],
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    _textControllers[5].clear();
                                  },
                                  icon: const Icon(Icons.clear)),
                              hintText: '계좌번호',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 10),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(width: 4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();//키보드 내리기
                        if (_textControllers[3].text == "" ||
                            _textControllers[3].text.length < 2 ||
                            _textControllers[3].text.contains(' ')) {
                          showSnackBar(context, '닉네임 사용불가');
                        } else {
                          user_state.nick_available =
                          await user.nickName_check(_textControllers[3].text);
                          if (!user_state.nick_available) {
                            showSnackBar(context, '닉네임이 중복되었습니다.');
                          }
                        }
                        if (user_state.nick_available && user_state.email_check) {
                          for (int i = 0; i < _textControllers.length; i++) {
                            userInfo.add(_textControllers[i].text);
                          }
                          user.post_signUp_data(userInfo);
                          user_state.set_loginState(true);
                          Navigator.pop(context);
                          handleAction(context, "회원메인");
                          showToast("회원가입 성공!");
                        } else {
                          showSnackBar(context, "회원정보를 올바르게 입력해주세요.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        backgroundColor: Colors.white, // 배경색을 흰색으로 변경
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30), // 테두리 둥글게
                          side: BorderSide(
                              color: Color(0xFFFAD232),
                              width: 2), // 테두리 색 및 너비 설정
                        ),
                      ),
                      child: Text(
                        '회원가입',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black87, // 글자색을 검정색으로 변경
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}