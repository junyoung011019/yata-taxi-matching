import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:device_apps/device_apps.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  // 목적지 좌표
  final String latitude = "36.9101074813647";
  final String longitude = "127.14283290030318";

  void _launchKakaoTApp() async {
    bool isKakaoTInstalled = await DeviceApps.isAppInstalled('com.kakao.taxi');

    if (isKakaoTInstalled) {
      final Uri kakaoTUri = Uri.parse('kakaot://taxi?dest_lat=$latitude&dest_lng=$longitude');
      if (await canLaunch(kakaoTUri.toString())) {
        await launch(kakaoTUri.toString());
      } else {
        throw 'Could not launch $kakaoTUri';
      }
    } else {
      final Uri fallbackUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.kakao.taxi');
      if (await canLaunch(fallbackUrl.toString())) {
        await launch(fallbackUrl.toString());
      } else {
        throw 'Could not launch $fallbackUrl';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Launch KakaoT App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _launchKakaoTApp,
          child: Text('Open KakaoT App'),
        ),
      ),
    );
  }
}
