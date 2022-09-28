import 'package:chat_online/global/enviroment.dart';
import 'package:chat_online/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  Function get emitir => this._socket.emit;

  void connect() async {
    final token = await AuthService.getToken();
    // Dart client
    this._socket = IO.io(Enviroments.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      //Notifica a la aplicacion que existe algun cambio en el servido
      notifyListeners();
    });
    this._socket.onDisconnect((_) {
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disConnect() {
    this._socket.disconnect();
  }
}
