import 'dart:io';

import 'package:band_names/app/models/band.dart';
import 'package:band_names/app/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleAncteBands);
    super.initState();
  }

  void _handleAncteBands(dynamic data){
    this.bands = (data as List).map((e) => Band.fromMap(e)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);
    final status = socketService.serverStatus;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only( right: 10.0 ),
            child: status == ServerStatus.Online ? Icon(Icons.check_circle, color: Colors.green) : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: [
          _mostrarGraficas(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i])
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band band) {

    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red[400],
        child: Align(
          alignment: Alignment.centerLeft, 
          child: Row(
            children: [
              Icon(Icons.delete, color: Colors.white),
              Text('Eliminar', style: TextStyle(color: Colors.white),)
            ],
          ) 
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit('delete-band',{ "id": band.id }),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${ band.votes }', style: TextStyle( fontSize:  20 )),
        onTap: () => socketService.socket.emit('vote-band', { "id": band.id }),
      ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if (!Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Agregar nueva Banda'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            MaterialButton(
              child: Text('Add'),
              color: Colors.blue,
              elevation: 1,
              onPressed: () => addBandToList(textController.text)
            )
          ],
        ),
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: ( _ ) => CupertinoAlertDialog(
        title: Text('Agregar nueva banda'),
        content: CupertinoTextField(
          controller: textController,
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Agregar'),
            onPressed: () => addBandToList(textController.text),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Dismiss'),
            onPressed: () => Navigator.pop(context),
          )
        ],
      )
    );
  }

  addBandToList(String name){
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length >= 1) {
      socketService.socket.emit('add-band', {
        "name": name
      });
    }
    Navigator.pop(context);
  }

  Widget _mostrarGraficas() {
    Map<String, double> dataMap = {};
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return Container(
      padding: EdgeInsets.only( top: 15.0 ),
      width: double.infinity,
      height: 200.0,
      child: PieChart(
        dataMap: dataMap.isNotEmpty ? dataMap : {"": 0},
        chartType: ChartType.ring,
      )
    );
  }
}