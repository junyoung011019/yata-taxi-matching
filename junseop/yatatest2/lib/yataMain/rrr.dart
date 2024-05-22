// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:yatatest2/function/routing.dart';
// import 'package:yatatest2/struct/recruitRoomStruct.dart';
//
// import 'function/userPost.dart';
//
//
// class RecruitmentRoom extends StatefulWidget {
//   const RecruitmentRoom({super.key});
//
//   @override
//   State<RecruitmentRoom> createState() => _RecruitmentRoomState();
// }
//
// class _RecruitmentRoomState extends State<RecruitmentRoom> {
//   UserPost user = UserPost();
//   List<Map<String, dynamic>> roomList = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchRooms();
//   }
//
//   void fetchRooms() async {
//     List<Map<String, dynamic>> fetchedRooms = await user.fetchRecruitmentRoomList();
//     setState(() {
//       roomList = fetchedRooms;
//     });
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold (
//       backgroundColor: Color(0xFFFBFFCC),
//       appBar: AppBar(
//         title: Text(
//           '모집 방',
//           style: TextStyle(
//             fontSize: 20, // 텍스트 크기 조정
//             fontWeight: FontWeight.bold, // 굵은 글꼴
//             color: Colors.black87, // 텍스트 색상 조정
//           ),
//         ),
//         centerTitle: true,
//         // 제목 가운데 정렬
//         backgroundColor: Colors.white,
//         // 배경색 조정
//         elevation: 0,
//         // 그림자 없애기
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             // 뒤로가기 버튼을 눌렀을 때 실행되는 동작
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column (
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height - 48, // 48은 이전 버튼의 높이입니다. 필요에 따라 조절할 수 있습니다.
//               child: ListView.builder (
//                   itemCount: roomList.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return roomContainer(
//                       context,
//                       roomList[index]['roomTitle'],
//                       roomList[index]['partyCount'],
//                       roomList[index]['destination'],
//                       roomList[index]['startTime'],
//                     );
//                   }
//               ),
//             ),
//
//             ElevatedButton(
//               child: Text("이메일 인증 초기화"),
//               onPressed: () { user.univ_init(); },
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         height: 50,
//         child: TextButton(
//           child: Text("이전"),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//     );
//   }
//
// }
//
// Widget roomContainer(BuildContext context, roomTitle, int partyCount, String destination, int startTime) {
//   return Column(
//     // mainAxisSize: MainAxisAlignment.start,
//     children: [
//       SizedBox(height: 20,),
//       Container(
//         padding: EdgeInsets.all(10), // 텍스트 블록의 패딩 설정
//         width: MediaQuery.of(context).size.width * 0.85, // 화면 너비와 같게 설정
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(
//             color: Color(0xFFFAD232),
//             width: 2,
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min, // 자식의 최소 높이만 사용
//           children: [
//             Text(roomTitle),
//             Text('모집 인원: $partyCount  '),
//             Text('    경로: $destination'),
//             Text('출발 시간: $startTime분 후'),
//             ElevatedButton(onPressed: () { handleAction(context, "채팅방",
//                 roomTitle: roomTitle,
//                 partyCount: partyCount,
//                 destination: destination,
//                 startTime: startTime); }, child: Text('참가하기', style:  TextStyle(color: Colors.black),),
//               style: ElevatedButton.styleFrom(
//                 padding: EdgeInsets.symmetric(
//                   vertical: 10,
//                   horizontal: 10,
//                 ),
//                 backgroundColor: Colors.white, // 배경색을 흰색으로 변경
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30), // 테두리 둥글게
//                   side: BorderSide(
//                       color: Color(0xFFFAD232),
//                       width: 2), // 테두리 색 및 너비 설정
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
//
// //
// // Text("모집방"),