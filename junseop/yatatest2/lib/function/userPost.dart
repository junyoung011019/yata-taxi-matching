import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yatatest2/function/routing.dart';
import 'dart:convert';
import 'auth_dio.dart';
import 'package:yatatest2/struct/recruitRoomStruct.dart';

class UserPost {
  String userPost = '.9';
  String output = "";
  final univ_key = dotenv.get("UNIV_KEY");
  final univ_url = dotenv.get("UNIV_URL");
  final url = dotenv.get("URL");
  final storage = new FlutterSecureStorage();


  void postAccess() async {
    try {
      String? accessToken = await storage.read(key: 'ACCESS_TOKEN');
      print("accessToken 불러옴 $accessToken");
      if (accessToken != null) {
        final response = await Http.get(
          Uri.parse(url + "/Protected"),
          headers: <String, String>{
            'Authorization': 'Bearer $accessToken',
            // 'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == 401) {
          final responseDataa = json.decode(response.body);
          print("회원가입 post 요청 실패: ${response.body}");
        }
        final responseData = json.decode(response.body);
        print("accessToken: ${responseData["accessToken"]}");


      } else {
        print('Access token is null.');
        // 이 경우에 대한 처리를 추가하세요.
      }
    } catch (er) {
      print('Error: $er');
    }
  }

  //USER 회원가입 post 요청
  void post_signUp_data(List<String> user) async {
    try {
      final response = await Http.post(Uri.parse(url + "/SignUp"), body: {
        "Email": user[0],
        "Password": user[1],
        "UserName": user[2],
        "NickName": user[3],
        "Phone": user[4],
        "AccountNumber": user[5],
        "Bank": user[6],
      });
      print("회원가입 post 요청 ");

      if(response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("회원가입 post 요청결과: ");
        print(responseData['success']);
        print("accessToken: ${responseData["accessToken"]}");
        print("accessToken: ${responseData["refreshToken"]}");
        await storage.write(key: 'ACCESS_TOKEN', value: responseData['accessToken']);
        await storage.write(key: 'REFRESH_TOKEN', value: responseData['refreshToken']);
      }
    } catch (er) {}
  }
  //USER 로그인 post 요청
  Future<bool> post_logIn_data(List<String> user) async {

    try {
      final response = await Http.post(Uri.parse(url + "/Login"), body: {
        "Email": user[0],
        "Password": user[1],
      });


      if(response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print("로그인 post 요청결과: ");
        print(responseData['success']);

        await storage.write(key: 'ACCESS_TOKEN', value: responseData['accessToken']);
        await storage.write(key: 'REFRESH_TOKEN', value: responseData['refreshToken']);

        return responseData['success'];//responseData['success'];
      }
      else return false;
    } catch (er) {return false;}
  }
  //모집하기 요청 Dio로 해보기
  Future<String> post_recruiting_data(BuildContext context, roomTitle, int MaxCount, String destination, int startTime) async {
    try {
      var dio = await authDio(context);

      Map<String, dynamic> data = {
        "roomTitle": roomTitle,
        "MaxCount": MaxCount,
        "destination": destination,
        "startTime": startTime
      };

      final response = await dio.post(url + "/Recruiting", data: data);

      print("모집하기 post 요청: $response");
      if(response.statusCode == 200) {
        final responseData = response.data;
        // responseData['roomNum'];
        print(responseData['roomId']);
        print("모집하기 post 요청성공");
        return responseData['roomId'];
      } else {
        return "";
      }
    } catch (error) {
      print("오류 발생: $error");
      // Navigator.popUntil(context, ModalRoute.withName("memberMain"));
      // Navigator.pop(context);
      // handleAction(context, "로그인");
      return "";
    }
  }

  Future <List<Map<String, dynamic>>> post_recruitmentRoomList_data(BuildContext context) async{
    try {
      var dio = await authDio(context);
      final response = await dio.get(url + "/ShowRecruiting");
      print("방 리스트 상태코드 : ${response.statusCode}");
      if (response.statusCode == 200) {
        print("상태코드 200");
        List<dynamic> data = response.data;
        List<Map<String, dynamic>> roomList = data.map((item) {
          return {
            "roomId": item['_id'],
            "roomTitle": item['roomTitle'],
            "destination": item['destination'],
            "startTime": item['startTime'],
            "CreationTime": item['CreationTime'],
            "RoomManager": item['RoomManager'],
            "MaxCount": item['MaxCount'],
            "HeadCount": item['HeadCount'],
          };
        }).toList();
        return roomList;
      } else {
        print("모집방 리스트 가져오기 실패: ${response.statusCode} ${response.data}");
        return [];
      }
    }catch(e) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          print("404 오류: 요청한 리소스를 찾을 수 없습니다. ${e.response?.data}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("요청한 리소스를 찾을 수 없습니다. URL을 확인하세요."),
            duration: Duration(seconds: 3),
          ));
        } else {
          print("Dio 오류: ${e.message}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("요청 중 오류가 발생했습니다: ${e.message}"),
            duration: Duration(seconds: 3),
          ));
        }
      } else {
        print("기타 오류: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("알 수 없는 오류가 발생했습니다."),
          duration: Duration(seconds: 3),
        ));
      }
      return [];
    }
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
