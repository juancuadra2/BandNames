import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {
  
  //Atributos
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket _socket;

  //Getters
  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;

  SocketService(){
    this._initConfig();
  }

  void _initConfig(){

    this._socket= IO.io('http://192.168.1.6:3000', 
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .build());

    this._socket.onConnect((_) {
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_){
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // this._socket.on('active-bands', (data) {
    //   print(data);
    // });

  }

}