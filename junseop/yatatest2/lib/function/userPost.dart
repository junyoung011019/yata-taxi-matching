import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as Http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'auth_dio.dart';

class UserPost {
  String userPost = '.9';
  String output = "";
  final univ_key = dotenv.get("UNIV_KEY");
  final univ_url = dotenv.get("UNIV_URL");
  final url = dotenv.get("URL");
  final storage = new FlutterSecureStorage();


  Future<List<String>> get_account_data(BuildContext context) async {
    try {
      var dio = await authDio(context);
      final response = await dio.get(url + "/Calculate");

      if(response.statusCode == 200){
        final responseData = response.data;
        List<String> account = [responseData["AccountName"],responseData["AccountNumber"]];
        return account;
      }
      else {
        return [];
      }
    } catch (e) {
      // 에러 처리를 위해 필요한 코드 작성
      return []; // 예외 발생 시 빈 리스트 반환
    }
  }
  Future<Map<String, dynamic>?> post_matching_data(BuildContext context, String destination, String matchingMethod ) async {
    try {
      var dio = await authDio(context);

      Map<String, dynamic> data = {
        "destination" : destination,
        "matchingMethod" : matchingMethod
      };
      final response = await dio.post(url + "/Matching", data: data);

      if(response.statusCode == 200) {
        final responseData = response.data;
        Map<String, dynamic> roomData = {
          "roomId": responseData['_id'],
          "roomTitle": responseData['roomTitle'],
          "destination": responseData['destination'],
          "startTime": responseData['startTime'],
          "CreationTime": responseData['CreationTime'],
          "RoomManager": responseData['RoomManager'],
          "MaxCount": responseData['MaxCount'],
        };
        return roomData;
      }
      if(response.statusCode == 404) {
        return null;
      }
    }
    catch(e) {
      return null;
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
        "AccountName": user[6],
      });

      if(response.statusCode == 200) {
        final responseData = json.decode(response.body);
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

      if(response.statusCode == 200) {
        final responseData = response.data;
        // responseData['roomNum'];
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
//모집방 리스트 요청
  Future <List<Map<String, dynamic>>> post_recruitmentRoomList_data(BuildContext context) async{
    try {
      var dio = await authDio(context);
      final response = await dio.get(url + "/ShowRecruiting");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Map<String, dynamic>> roomList = data.map((item) {
          return {
            "roomId": item['id'],
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("요청 중 오류가 발생했습니다: ${e.message}"),
            duration: Duration(seconds: 3),
          ));
        }
      } else {
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
    } catch(e) {}
  }

}
