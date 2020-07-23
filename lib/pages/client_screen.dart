import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_app_final/model/client.dart';

class ClientScreen extends StatefulWidget {
  final Client client;
  ClientScreen(this.client);
  @override
  _ClientScreenState createState() => _ClientScreenState();
}
final clientReference = FirebaseDatabase.instance.reference().child('client');

class _ClientScreenState extends State<ClientScreen> {
  List<Client> items;

  // Obteniendo informacion con los controller
  TextEditingController _nameController;
  TextEditingController _jobController;
  TextEditingController _addressController;

  //Vamos a juntar los Controller

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = new TextEditingController(text: widget.client.name);
    _jobController = new TextEditingController(text: widget.client.job);
    _addressController = new TextEditingController(text: widget.client.address);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Cliente'),
        backgroundColor: Colors.orangeAccent,
      ),
        body: Container(
          height: 570.0,
          padding: const EdgeInsets.all(20.0),
          child: Card(
            child: Center(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                    decoration: InputDecoration(icon: Icon(Icons.person),
                        labelText: 'Nombre'),
                  ),
                  Padding(padding: EdgeInsets.only(top : 8.0),),
                  Divider(),
                  //JOBS
                  TextField(
                    controller: _jobController,
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                    decoration: InputDecoration(icon: Icon(Icons.work),
                        labelText: 'Trabajo'),
                  ),
                  Padding(padding: EdgeInsets.only(top : 8.0),),
                  Divider(),

                  //ADDRESS
                  TextField(
                    controller: _addressController,
                    style: TextStyle(fontSize: 20.0, color: Colors.grey),
                    decoration: InputDecoration(icon: Icon(Icons.place),
                        labelText: 'Dirección'),
                  ),
                  Padding(padding: EdgeInsets.only(top : 8.0),),
                  Divider(),

                  FlatButton(onPressed: (){
                    if(widget.client.id != null){
                      clientReference.child(widget.client.id).set({
                        'name': _nameController.text,
                        'job':_jobController.text,
                        'address':_addressController.text,
                      }).then((_){
                        Navigator.pop(context);
                      });
                    }else{
                      clientReference.push().set({
                        'name': _nameController.text,
                        'job':_jobController.text,
                        'address':_addressController.text,
                      }).then((_){
                        Navigator.pop(context);
                      });
                    }
                  },
                      child: (widget.client.id != null) ? Text('Actualizar'):Text('Agregar')),
                ],
              ),
            ),

          ),
        ),
    );
  }
}