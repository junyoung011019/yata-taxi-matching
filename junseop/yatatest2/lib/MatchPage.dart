// import 'package:flutter/material.dart';
// import '../function/userPost.dart'; // userPost.dart 파일을 import
//
// class MatchPage extends StatelessWidget {
//   const MatchPage({super.key});
//
//   void _showMessage(BuildContext context, String message) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     UserPost userPost = UserPost();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Destination'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await userPost.quickMatch(context, '성환역'); // 인스턴스를 통해 메소드 호출
//                   _showMessage(context, '성환역을 선택하셨습니다.');
//                 } catch (e) {
//                   _showMessage(context, '성환역을 선택하셨습니다. 오류: $e');
//                 }
//               },
//               child: Text('성환역'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await userPost.quickMatch(context, '남서울대학교'); // 인스턴스를 통해 메소드 호출
//                   _showMessage(context, '남서울대학교를 선택하셨습니다.');
//                 } catch (e) {
//                   _showMessage(context, '남서울대학교를 선택하셨습니다. 오류: $e');
//                 }
//               },
//               child: Text('남서울 대학교'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }