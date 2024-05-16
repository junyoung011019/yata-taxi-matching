import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String roomTitle;
  final int partyCount;
  final String destination;
  final int startTime;
  const ChatRoom({super.key,
    required this.roomTitle, required this.partyCount, required this.destination, required this.startTime});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.roomTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName("memberMain"));
              },
          ),
        ),
      body: Column(
        children: [
              Text("참여 인원 : ?/${widget.partyCount}"),
              Divider(),
              Text("목적지 : ${widget.destination}"),
              Divider(),
              Text("예상 출발 시간 : ${widget.startTime}분 후"),
        ],
      ),
    );
  }
}
