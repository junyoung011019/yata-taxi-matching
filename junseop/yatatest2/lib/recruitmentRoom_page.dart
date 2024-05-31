import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yatatest2/function/routing.dart';
import 'package:yatatest2/function/userPost.dart';
import 'main.dart'; // routeObserver가 정의된 파일을 임포트

class RecruitmentRoom extends StatefulWidget {
  const RecruitmentRoom({super.key});

  @override
  State<RecruitmentRoom> createState() => _RecruitmentRoomState();
}

class _RecruitmentRoomState extends State<RecruitmentRoom> with RouteAware {
  UserPost user = UserPost();
  List<Map<String, dynamic>> roomList = [];

  @override
  void initState() {
    super.initState();
    fetchRooms();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    fetchRooms();
  }

  Future<void> fetchRooms() async {
    List<Map<String, dynamic>> fetchedRooms = await user.post_recruitmentRoomList_data(context);
    setState(() {
      roomList = fetchedRooms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFFCC),
      appBar: AppBar(
        title: Text(
          '모집 방',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchRooms,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchRooms,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 48,
                child: ListView.builder(
                  itemCount: roomList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (roomList.isEmpty) {
                      return Text("현재 생성된 방이 없습니다!");
                    } else {
                      return roomContainer(
                        context,
                        roomList[index]['roomTitle'],
                        roomList[index]['MaxCount'],
                        roomList[index]['HeadCount'],
                        roomList[index]['destination'],
                        roomList[index]['startTime'],
                        roomList[index]['roomId'],
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                child: Text("이메일 인증 초기화"),
                onPressed: () { user.univ_init(); },
              ),
            ],
          ),
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

Widget roomContainer(BuildContext context, String roomTitle, int MaxCount, int HeadCount, String destination, int startTime, String roomId) {
  return Column(
    children: [
      SizedBox(height: 20,),
      Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Color(0xFFFAD232),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(roomTitle),
            Text('모집 인원: $HeadCount/$MaxCount'),
            Text('경로: $destination'),
            Text('출발 시간: $startTime분 후'),
            ElevatedButton(onPressed: () async {
              final storage = new FlutterSecureStorage();
              String? accessToken = await storage.read(key: 'ACCESS_TOKEN');
              if(accessToken == null) accessToken = '';

              handleAction(context, "채팅방",
                  roomTitle: roomTitle,
                  MaxCount: MaxCount,
                  HeadCount: HeadCount,
                  destination: destination,
                  roomId: roomId,
                  accessToken: accessToken,
                  creation: false,
                  startTime: startTime); }, child: Text('참가하기', style:  TextStyle(color: Colors.black),),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: BorderSide(
                      color: Color(0xFFFAD232),
                      width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
