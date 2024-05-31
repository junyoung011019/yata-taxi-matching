import 'package:flutter/material.dart';
import 'package:yatatest2/function/toastMessage.dart';
import 'package:yatatest2/struct/userState.dart';
import 'function/routing.dart';
import 'function/userPost.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  List<TextEditingController> _textControllers =
  List.generate(2, (index) => TextEditingController());
  bool _isPasswordVisible = false;
  UserPost user = new UserPost();
  List<String> userInfo = ['',''];
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          print('로그인 후 메인화면');
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFFFAD232),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Image.asset(
                    'assets/yata_l.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height *
                        0.7, // 이미지의 최소 크기 설정// 이미지를 화면에 맞게 조절하되, 확대될 때는 원래 크기보다 작게 유지
                  ),
                ),
              ),
              Container(
                height: 70,
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                child: TextField(
                  controller: _textControllers[0],
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        _textControllers[0].clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                    hintText: '아이디(이메일) 입력',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              // 아이디와 비밀번호 입력 블럭 사이의 간격 조절
              Container(
                height: 100,
                padding: EdgeInsets.symmetric(horizontal: 60.0),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: _textControllers[1],
                      decoration: InputDecoration(
                        hintText: '비밀번호',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      obscureText:
                      !_isPasswordVisible, // _isPasswordVisible 변수의 반전값 사용
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible; // 상태를 토글
                        });
                        // 비밀번호 보이기 로직 구현
                        // TextField의 obscureText 속성을 토글하여 비밀번호 보이기/감추기
                      },
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_sharp
                          : Icons.visibility_off),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.38,
                    height: MediaQuery.of(context).size.height *
                        0.07, // 아이디 입력 블럭의 가로 길이와 동일하게 설정
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus(); //키보드 내리기
                        print('로그인');
                        userInfo[0] = _textControllers[0].text;
                        userInfo[1] = _textControllers[1].text;
                        bool logIn = await user.post_logIn_data(userInfo);
                        if(logIn) {
                          String? accessToken = await storage.read(key: 'ACCESS_TOKEN');
                          String? refreshToken = await storage.read(key: 'REFRESH_TOKEN');
                          print('ACCESS_TOKEN: $accessToken');
                          print('REFRESH_TOKEN: $refreshToken');

                          user_state.set_loginState(true);
                          Navigator.pop(context);
                          handleAction(context,"회원메인");
                          showToast("로그인 성공!");
                        }
                        else{
                          showSnackBar(context, "회원정보 불일치.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF765039), // #765039 색상 지정
                      ),
                      child: Text(
                        '로그인',
                        style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18,),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.38,
                    height: MediaQuery.of(context).size.height *
                        0.07, // 아이디 입력 블럭의 가로 길이와 동일하게 설정
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        print('이전');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70, // #765039 색상 지정
                      ),
                      child: Text(
                        '이전',
                        style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18,),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
