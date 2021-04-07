import 'dart:io';

import 'package:band_names/app/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Prueba 1', votes: 5),
    Band(id: '3', name: 'Prueba 2', votes: 5),
    Band(id: '4', name: 'Prueba 3', votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bandas', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i])
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
   );
  }

  Widget _bandTile(Band band) {
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
      onDismissed: (_){
        //TODO: borrar en el backend
      },
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text(band.name),
          trailing: Text('${ band.votes }', style: TextStyle( fontSize:  20 )),
          onTap: (){
            print(band.name);
          },
        ),
    );
  }

  addNewBand(){

    final textController = new TextEditingController();

    if (!Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
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
          );
        },
      );
    }

    showCupertinoDialog(
      context: context, 
      builder: ( _ ) {
        return CupertinoAlertDialog(
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
        );
      }
    );

    

  }

  addBandToList(String name){

    if (name.length >= 1) {
      setState(() {
          this.bands.add(
          new Band(
            id: DateTime.now().toString(),
            name: name,
            votes: 8
          )
        );
      });
    }

    Navigator.pop(context);
  }


}