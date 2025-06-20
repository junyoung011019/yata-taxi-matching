import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatatest2/chatRoom.dart';
import 'package:yatatest2/quickMatch_page.dart';
import 'package:yatatest2/yataMain/member_yataMain.dart';
import 'package:yatatest2/signup_page.dart';
import '../logIn_page.dart';
import '../recruiting/recruiting1_page.dart';
import '../recruiting/recruiting2.dart';
import '../recruiting/recruiting3.dart';
import '../recruitmentRoom_page.dart';
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

      case "notRoom":
        print("빠른매칭에 방이 없어염");
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('생성된 방이 없습니다...'),
              content: Text('잠시 후 다시 실행하거나\n방을 생성해주세요!'),
              actions: [
                CupertinoDialogAction(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        break;

      case "Channel is full":
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('채널 가득 참'),
              content: Text('방이 가득 찼습니다. 다른 방을 참가해주세요'),
              actions: [
                CupertinoDialogAction(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        break;
        case "Channel does not exist":
        showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('채널이 존재하지 않음'),
              content: Text('방이 존재하지 않습니다. 다른 방을 참가해주세요'),
              actions: [
                CupertinoDialogAction(
                  child: Text('확인'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        break;
      case "빠른매칭":
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuickMatch()));
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
              destination: destination,
              startTime: startTime,
              accessToken: accessToken,
              roomId: roomId,
              creation: creation,
            )));
        break;

    }


}


