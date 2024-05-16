import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yatatest2/function/routing.dart';
import 'package:yatatest2/struct/recruitRoomStruct.dart';

import 'function/userPost.dart';


class RecruitmentRoom extends StatefulWidget {
  const RecruitmentRoom({super.key});

  @override
  State<RecruitmentRoom> createState() => _RecruitmentRoomState();
}

class _RecruitmentRoomState extends State<RecruitmentRoom> {
  UserPost user = new UserPost();
  List<RoomStruct> roomList = [];
  @override
  void initState() {
    super.initState();
    // initState()에서 사용자의 방 목록을 가져옵니다.
    roomList = user.post_recruitmentRoomList_data();
    print(roomList[0].roomTitle);
    print(roomList[0].partyCount);
    print(roomList[0].destination);
    print(roomList[0].startTime);
  }
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        centerTitle: true,
        title: Text("모집 방"),
      ),
      body: SingleChildScrollView(
        child: Column (
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 48, // 48은 이전 버튼의 높이입니다. 필요에 따라 조절할 수 있습니다.
              child: ListView.builder (
                  itemCount: roomList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return roomContainer(
                        context,
                        roomList[index].roomTitle,
                        roomList[index].partyCount,
                        roomList[index].destination,
                        roomList[index].startTime
                    );
                  }
              ),
            ),

            TextButton(
              child: Text("이메일 인증 초기화"),
              onPressed: () { user.univ_init(); },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 50,
        child: TextButton(
          child: Text("이전"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

}

Widget roomContainer(BuildContext context, roomTitle, int partyCount, String destination, int startTime) {
  return Container(

    color: Colors.green,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(),
        Text(roomTitle),
        Text("모집인원: $partyCount"),
        Text("목적지: $destination"),
        Text("출발시간: $startTime분 후"),
        TextButton(
            child: Text("참가하기"),
            onPressed: ()   { handleAction(context, "채팅방",
                roomTitle: roomTitle,
                partyCount: partyCount,
                destination: destination,
                startTime: startTime); }
        ),
        Divider(),
      ],
    ),
  );
}

//
// Text("모집방"),
