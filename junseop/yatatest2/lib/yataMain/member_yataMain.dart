import 'package:flutter/material.dart';
import 'package:yatatest2/function/toastMessage.dart';
import '../function/routing.dart';
import '../function/userPost.dart';
import '../struct/userState.dart';
class Member_yataMain extends StatefulWidget {
  const Member_yataMain({super.key});

  @override
  State<Member_yataMain> createState() => _Member_yataMainState();
}

class _Member_yataMainState extends State<Member_yataMain> {
  UserPost user = new UserPost();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          print('로그인 후 메인화면');
        },
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
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
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.1),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => handleAction(context, "모집하기1"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(0xFFFAD232),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: Size(
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.7, // 버튼의 너비 지정
                        MediaQuery
                            .of(context)
                            .size
                            .height *
                            0.08, // 버튼의 높이 지정
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '모집하기',
                        style: TextStyle(
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => handleAction(context, "모집방"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(0xFFFAD232),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: Size(
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.7, // 버튼의 너비 지정
                        MediaQuery
                            .of(context)
                            .size
                            .height *
                            0.08, // 버튼의 높이 지정
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '모집 방',
                        style: TextStyle(
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () => handleAction(context, "빠른매칭"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(0xFFFAD232),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: Size(
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.7, // 버튼의 너비 지정
                        MediaQuery
                            .of(context)
                            .size
                            .height *
                            0.08, // 버튼의 높이 지정
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '빠른매칭',
                        style: TextStyle(
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      handleAction(context, "로그아웃");
                      user_state.set_loginState(false);
                      showToast("로그아웃!");
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(10),
                      backgroundColor: Color(0xFFFAD232),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      minimumSize: Size(
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.7, // 버튼의 너비 지정
                        MediaQuery
                            .of(context)
                            .size
                            .height *
                            0.08, // 버튼의 높이 지정
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: MediaQuery
                              .of(context)
                              .size
                              .width * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.04),
                ElevatedButton(onPressed: () {user.postAccess();} , child: Text("테스트토큰"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}