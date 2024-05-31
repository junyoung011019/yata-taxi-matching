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
  final bool creation;
  const ChatRoom({
    super.key,
    required this.roomTitle,
    required this.MaxCount,
    required this.HeadCount,
    required this.destination,
    required this.startTime,
    required this.accessToken,
    required this.roomId,
    required this.creation,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late int headCount;
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
    headCount = widget.HeadCount;
    socket = SocketService(widget.accessToken, widget.roomId, widget.creation, widget.MaxCount);

    socket.onMessage((data) {
      print("메시지 수신: $data");
      if (mounted) {
        setState(() {
          messages.add(data);
        });
        _scrollToBottom();
      }
    });

    socket.onHeadCount((data) {
      if (mounted) {
        setState(() {
          headCount = data['headCount'];
          print("현재 인원은? -> $headCount");
        });
      }
    });

  }

  void sendMessage() {
    if (_controller.text.isNotEmpty) {
      print("sendMessage호출!!!!");
      socket.sendMessage(widget.roomId, _controller.text);
      _controller.clear();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    _controller.dispose();
    _scrollController.dispose();
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
          Text("참여 인원 : $headCount/${widget.MaxCount}"),
          Divider(),
          Text("목적지 : ${widget.destination}"),
          Divider(),
          Text("예상 출발 시간 : ${widget.startTime}분 후"),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
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
      alignment: isMe
          ? Alignment.centerRight
          : isSystem
          ? Alignment.center
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isMe
              ? Colors.white//Color(0xFFFAD232)
              : isSystem
              ? null
              : Colors.white,//Colors.grey[300],

          border: isSystem
              ? null
              : isMe
              ? Border.all( color: const Color(0xFFFAD232), width: 2.0,)
              : Border.all( color: const Color(0xFFC79467), width: 2.0,),

          borderRadius: isMe ?
          BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(0.0),
          ) :
          BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(10.0),
          ),
          // BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : isSystem
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            Text(
              message['message'],
              style: isSystem
                  ? TextStyle(fontSize: 10, color: Colors.red)
                  : TextStyle(fontSize: 16),
            ),
            SizedBox(height: 5),
            if (!isSystem)
              Text(
                '${message['nickname']}',
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
          ],
        ),
      ),
    );
  }
}
