import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_final/model/client.dart';

class ClientInformation extends StatefulWidget {
  final Client client;
  ClientInformation(this.client);
  @override
  _ClientInformationState createState() => _ClientInformationState();
}

final clientReference = FirebaseDatabase.instance.reference().child('client');

class _ClientInformationState extends State<ClientInformation> {
  List<Client> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Información del Cliente'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        height: 400.0,
        padding: const EdgeInsets.all(20.0),
        child: Card(
          child: Center(
            child: Column(
              children: <Widget>[
                new Text("Nombre : ${widget.client.name}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),

                new Text("Trabajo : ${widget.client.job}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),

                new Text("Dirección : ${widget.client.address}", style: TextStyle(fontSize: 18.0),),
                Padding(padding: EdgeInsets.only(top: 8.0),),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
