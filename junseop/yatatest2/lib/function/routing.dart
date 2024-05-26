import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatatest2/chatRoom.dart';
import 'package:yatatest2/function/toastMessage.dart';
import 'package:yatatest2/yataMain/member_yataMain.dart';
import 'package:yatatest2/signup_page.dart';
import '../logIn_page.dart';
import '../recruiting/recruiting1_page.dart';
import '../recruiting/recruiting2.dart';
import '../recruiting/recruiting3.dart';
import '../recruitmentRoom_page.dart';
import '../struct/userState.dart';
import '../yataMain/yataMain.dart';



void handleAction(BuildContext context, String action,
    {String roomTitle = "",
      int MaxCount = 2,
      int HeadCount = 1,
      String destination = "남서울대학교",
      int startTime = 5, String accessToken = "",
      String roomId = "",
      bool creation = true,
    }) {
  if (!user_state.loginState) {
    switch (action) {
      case "로그인":
        Navigator.push(
            context, MaterialPageRoute(
            settings: RouteSettings(name: "login"),
            builder: (context) => LogIn()));
        break;

      case "회원가입":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp()));
        break;
      case "모집하기":
      case "모집방":
      case "빠른매칭":
      case "회원메인":
      case "로그아웃":
      case "채팅창바로가기":
      case "모집하기1":
      case "모집하기2":
      case "모집하기3":
        showSnackBar(context, "로그인 필요");
        break;
    }


  }
    if (user_state.loginState) {
    switch (action) {
      case "메인":
        Navigator.push(context,
            MaterialPageRoute(
                settings: RouteSettings(name: "ymain"),
                builder: (context) => YataMain()));
        break;
      case "로그인 만료":
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('로그인 만료'),
              content: Text('로그인이 만료되었습니다. 다시 로그인해주세요.'),
              actions: [
                CupertinoDialogAction(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.popUntil(context, ModalRoute.withName("memberMain"));
                    Navigator.pop(context);
                    // Navigator.pop(context); // 대화 상자 닫기
                    // 로그인 페이지로 이동
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: RouteSettings(name: "login"),
                        builder: (context) => LogIn(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
        break;
      case "모집방":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RecruitmentRoom()));
        break;
      case "회원메인":
        Navigator.push(context,
            MaterialPageRoute(
                settings: RouteSettings(name: "memberMain"),
                builder: (context) => Member_yataMain()));
        break;
      // case "채팅창바로가기":
      //   Navigator.push(context,
      //       MaterialPageRoute(builder: (context) => Member_yataMain()));
      //   break;
      case "로그아웃":
        Navigator.pop(context);
        break;
      case "모집하기1":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Recruiting1()));
        break;
      case "모집하기2":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Recruiting2(
              roomTitle: roomTitle,
              MaxCount: MaxCount,
            )));
        break;
      case "모집하기3":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Recruiting3(
              roomTitle: roomTitle,
              MaxCount: MaxCount,
              destination: destination,
              startTime: startTime,
            )));
        break;
      case "채팅방":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ChatRoom(
              roomTitle: roomTitle,
              MaxCount: MaxCount,
              HeadCount: HeadCount,
              destination: destination,
              startTime: startTime,
              accessToken: accessToken,
              roomId: roomId,
              creation: creation,
            )));
        break;

    }
  }


}


