import 'package:http/http.dart' as Http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'auth_dio.dart';
import 'package:yatatest2/struct/recruitRoomStruct.dart';
class UserPost {
  String userPost = '.9';
  String output = "";
  final univ_key = dotenv.get("UNIV_KEY");
  final univ_url = dotenv.get("UNIV_URL");
  final url = dotenv.get("URL");


  //USER 회원가입 post 요청
  void post_signUp_data(List<String> user) async {
    try {
      final response = await Http.post(Uri.parse(url + "/SignUp"), body: {
        "Email": user[0],
        "PassWord": user[1],
        "UserName": user[2],
        "NickName": user[3],
        "Phone": user[4],
        "AccountNumber": user[5],
        "Bank": user[6],
      });
      print("회원가입 post 요청: $response.body");
    } catch (er) {}
  }
  //USER 로그인 post 요청
  Future<bool> post_logIn_data(List<String> user) async {
    try {
      final response = await Http.post(Uri.parse(url + "/logIn"), body: {
        "Email": user[0],
        "Password": user[1],
      });

      print("로그인 post 요청: $response.body");
      if(response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("로그인 post 요청결과: ");
        print(responseData['success']);
        return responseData['success'];//responseData['success'];
      }
      else return false;
    } catch (er) {return false;}
  }
  //모집하기 요청 Dio로 해보기
  Future<bool> post_recruiting_data(String roomTitle, int partyCount, String destination, int startTime) async {
    try {
      var dio = await authDio();

      Map<String, dynamic> data = {
        "roomTitle": roomTitle,
        "partyCount": partyCount,
        "destination": destination,
        "startTime": startTime
      };

      final response = await dio.post(url + "/Recruiting", data: data);

      print("로그인 post 요청: $response.body");
      if(response.statusCode == 200) {
        final responseData = json.decode(response.data);
        print("모집하기 post 요청성공: ");
        return true;
      } else {
        return false;
      }
    } catch (error) {
      print("오류 발생: $error");
      return false;
    }
  }
  //모집하기 요청 //함수명 다시 확인
  Future<bool> post_recruiting_dataa(String roomTitle, int partyCount, String destination, int startTime) async {
    try {
      var dio = await authDio();
      final response = await Http.post(Uri.parse(url + "/Recruiting"), body: {
        "roomTitle": roomTitle,
        "partyCount": partyCount,
        "destination":destination,
        "startTime": startTime
      });

      print("로그인 post 요청: $response.body");
      if(response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("모집하기 post 요청성공: ");
        return true;//responseData['success'];
      }
      else return false;
    } catch (er) {return false;}
  }
  //모집방 리스트 요청
  List<RoomStruct> post_recruitmentRoomList_data() {
    List<RoomStruct> roomList = [];
    roomList.add(RoomStruct("1번방", 1, "학교", 1));
    roomList.add(RoomStruct("2번방", 2, "학교", 2));
    roomList.add(RoomStruct("3번방", 3, "학교", 3));
    roomList.add(RoomStruct("4번방", 4, "학교", 4));
    roomList.add(RoomStruct("5번방", 5, "학교", 5));
    roomList.add(RoomStruct("6번방", 6, "학교", 6));

    return roomList;
  }
  //닉네임 중복확인
  Future<bool> nickName_check(String nickName) async {
    try {
      final response = await Http.post(Uri.parse(url + "/NickCheck"), body: {
        "NickName": nickName,
      });
      if(response.statusCode == 201) {
        final responseData = json.decode(response.body);
        print(response.statusCode);
        print("닉네임 사용가능: ");
        print(responseData["Available"]);
        return responseData["Available"];
      }
      else return false;
    } catch (er) { return false;}
  }

  //학교 이메일 인증코드 확인
  Future<bool> univ_email_check(String email, int code) async {
    try {
      final response = await Http.post(Uri.parse(univ_url + "/api/v1/certifycode"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, dynamic>{
            'key': univ_key,
            'email': email,
            'univName': '남서울대학교',
            'code': code
            //Add any other data you want to send in the body
          })
      );
      print(response.body);
      final responseData = json.decode(response.body);
      bool success = responseData['success'];
      return success;
    } catch (er) {return false;}
  }
  //학교 이메일 인증코드 전송
  void univ_email(String email) async {
    try {
      final response = await Http.post(Uri.parse(univ_url + "/api/v1/certify"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'key': univ_key,
          'email': email,
          'univName': '남서울대학교',
          'univ_check': true
          //Add any other data you want to send in the body
        }),
      );
      print(response.body);
    } catch(e) {}
  }
//학교인증 초기화
  void univ_init() async {
    try {
      final response = await Http.post(Uri.parse(univ_url + "/api/v1/clear"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'key': univ_key,
          //Add any other data you want to send in the body
        }),
      );
      print(response.body);
    } catch(e) {}
  }

}
