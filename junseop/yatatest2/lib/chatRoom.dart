import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:yatatest2/function/socketService.dart';

class ChatRoom extends StatefulWidget {
  final String roomTitle;
  final int MaxCount;
  final int HeadCount;
  final String destination;
  final int startTime;
  final String accessToken;
  final String roomId;
  // final String roomId;
  const ChatRoom({super.key,
    required this.roomTitle,
    required this.MaxCount,
    required this.HeadCount,
    required this.destination,
    required this.startTime,
    required this.accessToken,
    required this.roomId
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _controller = TextEditingController();

  late Map<String, dynamic> decodedToken;
  late String myNick;
  late SocketService socket;
  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    decodedToken = JwtDecoder.decode(widget.accessToken);
    myNick = decodedToken["NickName"];
    print("내 닉네임: $myNick");
    socket = SocketService(widget.accessToken, widget.roomId); //widget.roomId
    socket.onMessage((data) {
      if (mounted) {
        setState(() {
          messages.add(data);
        });
      }
    });
  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      socket.sendMessage(widget.roomId, _controller.text);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    _controller.dispose();
    super.dispose();
  }

  void _exitChatRoom() {
    setState(() {
      messages = [];
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.roomTitle),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _exitChatRoom,
        ),
      ),
      body: Column(
        children: [
          Text("참여 인원 : ${widget.HeadCount}/${widget.MaxCount}"),
          Divider(),
          Text("목적지 : ${widget.destination}"),
          Divider(),
          Text("예상 출발 시간 : ${widget.startTime}분 후"),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return buildMessage(messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: '메시지를 입력하세요',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMessage(Map<String, dynamic> message) {
    bool isMe = message['nickname'] == myNick;
    bool isSystem = message['nickname'] == "System";
    return Align(
      alignment: isMe ? Alignment.centerRight : isSystem ? Alignment.center : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe ? Color(0xFFFAD232) : isSystem ? null : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : isSystem ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              message['message'],
              style: isSystem ? TextStyle(fontSize: 10, color: Colors.red) : TextStyle(fontSize: 16,),
            ),
            SizedBox(height: 5),
            if(!isSystem)
            Text(
              'Sent by: ${message['nickname']}',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
