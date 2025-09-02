import 'dart:async';
import 'dart:io';
import 'dart:convert';

void main() async {
  var server = await ServerSocket.bind('localhost', 4040);
  print('服务器已启动，等待玩家连接...');

  List<Player> players = [];

  await for (var socket in server) {
    print('新玩家连接');
    var player = Player(socket);
    players.add(player);

    if (players.length == 2) {
      startGame(players);
      players = [];
    }
  }
}

void startGame(List<Player> players) {
  print('游戏开始！');

  players[0].socket.writeln('游戏开始，请出拳：1.石头 2.剪刀 3.布');
  players[1].socket.writeln('游戏开始，请出拳：1.石头 2.剪刀 3.布');

  int? choice1;
  int? choice2;

  void handleExit(Player quitter) {
    print('玩家退出或断开，游戏结束');
    try { quitter.socket.writeln('你已退出游戏'); } catch (_) {}
    for (var p in players) {
      if (p != quitter) {
        try { p.socket.writeln('对方已退出，游戏结束'); } catch (_) {}
      }
    }
    // 关闭所有连接（优雅）
    for (var p in players) {
      try { p.socket.close(); } catch (_) { p.socket.destroy(); }
    }
  }

  // 注意这里使用 cast<List<int>>() 把 Stream<Uint8List> 视作 Stream<List<int>>
  players[0].socket
      .cast<List<int>>()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    var input = line.trim();
    var value = int.tryParse(input);
    if (value == null || value < 1 || value > 3) {
      handleExit(players[0]);
      return;
    }
    choice1 = value;
    if (choice1 != null && choice2 != null) {
      sendResult(players, choice1!, choice2!);
    }
  }, onDone: () => handleExit(players[0]), onError: (_) => handleExit(players[0]));

  players[1].socket
      .cast<List<int>>()
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((line) {
    var input = line.trim();
    var value = int.tryParse(input);
    if (value == null || value < 1 || value > 3) {
      handleExit(players[1]);
      return;
    }
    choice2 = value;
    if (choice1 != null && choice2 != null) {
      sendResult(players, choice1!, choice2!);
    }
  }, onDone: () => handleExit(players[1]), onError: (_) => handleExit(players[1]));
}

void sendResult(List<Player> players, int choice1, int choice2) {
  var results = judge(choice1, choice2);
  players[0].socket.writeln(results[0]);
  players[1].socket.writeln(results[1]);

  for (var p in players) {
    try { p.socket.writeln('游戏结束，连接将在2秒后关闭'); } catch (_) {}
  }

  // 给客户端一点时间接收数据再关闭
  Future.delayed(const Duration(seconds: 2), () {
    for (var p in players) {
      try {
        p.socket.close();
      } catch (_) {
        try { p.socket.destroy(); } catch (_) {}
      }
    }
  });
}

List<String> judge(int choice1, int choice2) {
  if (choice1 == choice2) {
    return ['平局', '平局'];
  } else if ((choice1 == 1 && choice2 == 2) ||
      (choice1 == 2 && choice2 == 3) ||
      (choice1 == 3 && choice2 == 1)) {
    return ['你赢了', '你输了'];
  } else {
    return ['你输了', '你赢了'];
  }
}

class Player {
  final Socket socket;
  Player(this.socket);
}
