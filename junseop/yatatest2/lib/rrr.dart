// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// void main() {
//   runApp(MaterialApp(
//     home: LoginScreen(),
//   ));
// }
//
// class LoginScreen extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Enter your username',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ChatRoom(
//                       roomTitle: 'Room1',
//                       partyCount: 5,
//                       destination: 'Destination',
//                       startTime: 10,
//                       userName: _usernameController.text,
//                     ),
//                   ),
//                 );
//               },
//               child: Text('Enter Chat Room'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ChatRoom extends StatefulWidget {
//   final String roomTitle;
//   final int partyCount;
//   final String destination;
//   final int startTime;
//   final String userName;
//
//   const ChatRoom({
//     super.key,
//     required this.roomTitle,
//     required this.partyCount,
//     required this.destination,
//     required this.startTime,
//     required this.userName,
//   });
//
//   @override
//   State<ChatRoom> createState() => _ChatRoomState();
// }
//
// class _ChatRoomState extends State<ChatRoom> {
//   late IO.Socket socket;
//   List<Map<String, dynamic>> messages = [];
//   final TextEditingController _controller = TextEditingController();
//   String myID = "";
//   int participantCount = 0;
//   int i = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     socket = IO.io('http://127.0.0.1:3000', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });
//     socket.connect();
//
//     socket.onConnect((_) {
//       print('connected');
//       socket.emit('join_room', {'room': widget.roomTitle, 'maxParticipants': widget.partyCount});
//       loadMessages();
//     });
//
//     // 소켓 ID를 받는 이벤트
//     socket.on('socket_id', (id) {
//       setState(() {
//         myID = id;
//       });
//     });
//
//     //서버에서 socket.emit('update_participant_count')으로 받았음
//     // 참여 인원 수 업데이트 이벤트
//     socket.on('update_participant_count', (count) {
//       setState(() {
//         participantCount = count;
//       });
//     });
//
//     //서버에서 socket.emit('join_error')으로 받았음
//     // 최대 인원 초과 시 에러 메시지 이벤트
//     socket.on('join_error', (message) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.pop(context); // 채팅 화면에서 로그인 화면으로 돌아감
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     });
//
//     socket.on('receive_message', (data) {
//       setState(() {
//         messages.add({'message': data['message'], 'sender': data['sender']});
//         if (i == 0) {
//           print("내 소켓 아이디 : ${data['sender']}");
//           myID = data['sender'];
//           i++;
//         }
//       });
//     });
//
//     socket.onDisconnect((_) {
//       print('disconnected');
//     });
//   }
//
//   void loadMessages() async {
//     final response = await http.get(Uri.parse('http://127.0.0.1:3000/MessagesInfo/${widget.roomTitle}'));
//     if (response.statusCode == 200) {
//       final List<dynamic> messageList = json.decode(response.body);
//       setState(() {
//         messages = messageList.map((msg) => {'message': msg['message'], 'sender': msg['sender']}).toList();
//       });
//     } else {
//       print('Failed to load messages');
//     }
//   }
//
//   @override
//   void dispose() {
//     socket.dispose();
//     super.dispose();
//   }
//
//   void sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       socket.emit('send_message', {
//         'room': widget.roomTitle,
//         'message': _controller.text,
//         'sender': widget.userName
//       });
//       _controller.clear();
//     }
//   }
//
//   Widget buildMessage(Map<String, dynamic> message) {
//     bool isMe = message['sender'] == myID;
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         padding: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blue[100] : Colors.grey[300],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(
//               message['message'],
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 5),
//             Text(
//               'Sent by: ${message['sender']}',
//               style: TextStyle(fontSize: 12, color: Colors.black54),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(widget.roomTitle),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Text("참여 인원 : $participantCount/${widget.partyCount}"),
//           Divider(),
//           Text("목적지 : ${widget.destination}"),
//           Divider(),
//           Text("예상 출발 시간 : ${widget.startTime}분 후"),
//           Expanded(
//             child: ListView.builder(
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return buildMessage(messages[index]);
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       labelText: '메시지를 입력하세요',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
