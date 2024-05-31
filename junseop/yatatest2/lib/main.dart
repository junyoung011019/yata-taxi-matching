import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yatatest2/yataMain/yataMain.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'recruitmentRoom_page.dart'; // RecruitmentRoom 페이지를 import

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

Future main() async {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: '.env');
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp ({super.key});

  @override
  Widget build(BuildContext context) {
    // FlutterNativeSplash.remove();
    return MaterialApp(
      home: YataMain(),
      title: "YATA",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      navigatorObservers: [routeObserver], // RouteObserver 추가
    );
  }
}
