import 'dart:io';
import 'dart:convert';

void main() async {
  var socket = await Socket.connect('localhost', 4040);
  print('已连接到服务器');

  // 监听服务器消息（UTF-8 解码）
  socket.listen((data) {
    print(utf8.decode(data));
  });

  // 从命令行读取并转成 UTF-8 发送
  stdin.transform(utf8.decoder).listen((line) {
    socket.write(line + "\n");
  });
}
