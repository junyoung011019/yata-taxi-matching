import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  final url = dotenv.get("URL");
  SocketService(String accessToken, String roomId, bool creation, int MaxCount) {


    socket = IO.io(url,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            // .setExtraHeaders({'Authorization': 'Bearer $accessToken'})
            .setAuth({'token': accessToken})
            // .setQuery({'channel': roomId})
            .build());

    // 소켓 연결 시도
    socket.connect();

    // 연결 이벤트 핸들러
    socket.on('connect', (_) {
      if(creation) {
        socket.emit('creation', {'channel': roomId, 'MaxCount': MaxCount});
      } //모집하기로 들어온 사람
      else {
        socket.emit('joinChannel', {'channel': roomId});
      } //참여하기로 들어온 사람
      // 연결이 성공하면 추가 작업을 여기에 추가
    });

    // 메세지 이벤트 핸들러
    socket.on('message', (data) {
      print('Received message: $data');
    });

    socket.on('channel-info', (data) {
      print('channel-info message: $data');
    });

    // 연결 에러 이벤트 핸들러
    socket.on('connect_error', (error) {
      print('Connect error: $error');
    });

    // 연결 해제 이벤트 핸들러
    socket.on('disconnect', (_) {
      print('서버랑 연결 끊김스');
    });
  }

  // 메세지 전송 함수
  void sendMessage(String roomId, String message) {
    socket.emit('message', {'channel': roomId, 'message': message});
  }

  void onMessage(Function(dynamic) callback) {
    socket.on('message', callback);
  }
  void onHeadCount(Function(dynamic) callback) {
    socket.on('channel-info', callback);
  }
  void onError(Function(dynamic) callback) {
    socket.on('error', callback);
  }
  // 소켓 연결 해제
  void disconnect() {
    // if (_isDisconnected) return;
    // _isDisconnected = true;

    socket.off('connect');
    socket.off('message');
    socket.off('connect_error');
    socket.off('disconnect');
    socket.disconnect();
  }
}

