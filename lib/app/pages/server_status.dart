import 'package:band_names/app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Estado', style: TextStyle(color: Colors.black87)),
          elevation: 1,
          backgroundColor: Colors.white,
          
        ),
        body: Center(
          child: Text('Estado del servidor: ${ socketService.serverStatus }'),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 1,
          child: Icon(Icons.send),
          onPressed: (){

            socketService.socket.emit('emitir-mensaje', {
              "nombre" : "Juan David",
              "apellido" : "Cuadrado Tordecilla"
            });

          },
        ),
      ),
    );
  }
}