import 'package:flutter/material.dart';
import 'package:yatatest2/function/routing.dart';
import 'package:yatatest2/function/toastMessage.dart';
import '../function/userPost.dart';
class Recruiting3 extends StatefulWidget {
  final String roomTitle;
  final int partyCount;
  final String destination;
  final int startTime;
  const Recruiting3({super.key,
    required this.roomTitle, required this.partyCount, required this.destination, required this.startTime});

  @override
  State<Recruiting3> createState() => _Recruiting3State();
}

class _Recruiting3State extends State<Recruiting3> {
  UserPost user = new UserPost();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('모집하기3'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: Column(
        children: [
          Text(widget.roomTitle),
          Text(widget.partyCount.toString()),
          Text(widget.destination),
          Text(widget.startTime.toString()),
          TextButton(
              child: Text("확인"),
              onPressed: () {

                user.post_recruiting_dataa(widget.roomTitle, widget.partyCount, widget.destination, widget.startTime);
                Navigator.popUntil(context, ModalRoute.withName("memberMain"));
                handleAction(context, "채팅방",
                    roomTitle: widget.roomTitle,
                    partyCount: widget.partyCount,
                    destination: widget.destination,
                    startTime: widget.startTime);

                showToast("방만들기 성공!");
              }
          ),
          TextButton(
              child: Text("취소"),
              onPressed: () {
                Navigator.pop(context);
              }
          ),
        ],

      ),
    );
  }
}
