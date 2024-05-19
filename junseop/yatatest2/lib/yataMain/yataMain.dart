import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yatatest2/signup_page.dart';
import 'package:yatatest2/struct/userState.dart';
import '../function/toastMessage.dart';
import '../function/userPost.dart';
import '../function/routing.dart';
class YataMain extends StatefulWidget {
  const YataMain({super.key});

  @override
  State<YataMain> createState() => _YataMainState();
}

class _YataMainState extends State<YataMain> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          print('로그인 후 메인화면');
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color(0xFFFBFFCC),
            border: Border.all(
              color: Color(0xFFFAD232),
              width: 4,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Image.asset(
                      'assets/yatataxi.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => showSnackBar(context, "로그인 필요"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(0xFFFAD232),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.7, // 버튼의 너비 지정
                        MediaQuery.of(context).size.height *
                            0.08, // 버튼의 높이 지정
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '모집하기',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => showSnackBar(context, "로그인 필요"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(0xFFFAD232),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.7, // 버튼의 너비 지정
                        MediaQuery.of(context).size.height *
                            0.08, // 버튼의 높이 지정
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '모집 방',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => showSnackBar(context, "로그인 필요"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(0xFFFAD232),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.7, // 버튼의 너비 지정
                        MediaQuery.of(context).size.height *
                            0.08, // 버튼의 높이 지정
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '빠른매칭',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // 버튼을 가운데 정렬
                  children: [
                    Flexible(
                      flex: 1, // 화면의 절반을 차지하도록 함
                      child: ElevatedButton(
                        onPressed: () => handleAction(context, "로그인"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.25, // 버튼의 너비 지정
                            MediaQuery.of(context).size.height * 0.05, // 버튼의 높이 지정
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '로그인',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.15), // 버튼 사이 간격 조정
                    Flexible(
                      flex: 1, // 화면의 절반을 차지하도록 함
                      child: ElevatedButton(
                        onPressed: () => handleAction(context, "회원가입"),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          minimumSize: Size(
                            MediaQuery.of(context).size.width * 0.25, // 버튼의 너비 지정
                            MediaQuery.of(context).size.height * 0.05, // 버튼의 높이 지정
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '회원가입',
                            style: TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                TextButton(onPressed: () async {
                  final storage = new FlutterSecureStorage();
                  final accessToken = await storage.read(key: 'ACCESS_TOKEN');
                  final refreshToken = await storage.read(key: 'REFRESH_TOKEN');
                  print('ACCESS_TOKEN: $accessToken');
                  print('REFRESH_TOKEN: $refreshToken');
                  user_state.set_loginState(true);
                  handleAction(context, "회원메인");
                }, child: Text("로그인해버리기"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

