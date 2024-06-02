import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:yatatest2/function/routing.dart';
import 'package:yatatest2/function/socketService.dart';
import 'package:yatatest2/function/userPost.dart';

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
  bool showButtons = false; // 토글 버튼 상태를 저장하는 변수
  bool showSettlementForm = false; // 정산 폼의 표시 상태를 저장하는 변수

  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _headController = TextEditingController();

  UserPost user = new UserPost();
  late String accountName;
  late String accountNumber;
  @override
  void initState() {
    super.initState();

    user.post_account_data(context);

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

    socket.onError((data) {
      if (mounted) {
        setState(() {
          print(data);
          if (data['message'] == "Channel is full") handleAction(context, "Channel is full");
          if (data['message'] == "Channel does not exist") handleAction(context, "Channel does not exist");
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

  void _showSettlementForm() {
    setState(() {
      showSettlementForm = !showSettlementForm;
    });
  }

  void _submitSettlementForm() {
    // 여기서 제출된 데이터를 처리합니다.
    String bank = _bankController.text;
    String accountNumber = _accountNumberController.text;
    String amount = _amountController.text;
    String head = _headController.text;

    print("은행: $bank, 계좌번호: $accountNumber, 비용: $amount");

    // 제출 후 폼을 숨깁니다.
    setState(() {
      showSettlementForm = false;
      _bankController.clear();
      _accountNumberController.clear();
      _amountController.clear();
      _headController.clear();
    });

    // 데이터를 채팅 메시지로 보내기
    socket.sendMessage(widget.roomId, '- 정산 정보 -\n은행: $bank\n계좌번호: $accountNumber\n비용: ${int.parse(amount) / int.parse(head)}');
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
          Visibility(
            visible: showButtons,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 택시 호출하기 기능 구현
                    _scrollToBottom();
                    print("택시 호출하기 버튼 클릭");
                  },
                  child: Text("택시 호출하기"),
                ),
                ElevatedButton(
                  onPressed:() {
                    _scrollToBottom();
                    _showSettlementForm();
                  },
                  child: Text("정산하기"),
                ),
              ],
            ),
          ),
          Visibility(
            visible: showSettlementForm,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: _bankController,
                    decoration: InputDecoration(
                      labelText: '은행',
                    ),
                  ),
                  TextField(
                    controller: _accountNumberController,
                    decoration: InputDecoration(
                      labelText: '계좌번호',
                    ),
                  ),
                  TextField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: '비용',
                    ),
                  ),
                  TextField(
                    controller: _headController,
                    decoration: InputDecoration(
                      labelText: '인원',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitSettlementForm,
                    child: Text('제출하기'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _scrollToBottom();
                    setState(() {
                      _bankController.clear();
                      _accountNumberController.clear();
                      _amountController.clear();
                      _headController.clear();
                      if(showSettlementForm == true)
                      {
                        _showSettlementForm();
                      }
                      showButtons = !showButtons;
                    });
                  },
                ),
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
              ? Colors.white // Color(0xFFFAD232)
              : isSystem
              ? null
              : Colors.white, // Colors.grey[300],

          border: isSystem
              ? null
              : isMe
              ? Border.all(
            color: const Color(0xFFFAD232),
            width: 2.0,
          )
              : Border.all(
            color: const Color(0xFFC79467),
            width: 2.0,
          ),

          borderRadius: isMe
              ? BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(0.0),
          )
              : BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(10.0),
          ),
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
