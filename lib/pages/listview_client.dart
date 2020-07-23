import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter_app_final/model/client.dart';
import 'package:flutter_app_final/pages/client_screen.dart';
import 'package:flutter_app_final/pages/client_information.dart';

class ListViewClient extends StatefulWidget {
  @override
  _ListViewClientState createState() => _ListViewClientState();
}

final clientReference = FirebaseDatabase.instance.reference().child('client');

class _ListViewClientState extends State<ListViewClient> {

  List<Client> items;
  StreamSubscription<Event> _onClientAddedSubscription;
  StreamSubscription<Event> _onClientChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = new List();
    _onClientAddedSubscription =
        clientReference.onChildAdded.listen(_onClientAdded);
    _onClientChangedSubscription =
        clientReference.onChildChanged.listen(_onClientUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onClientAddedSubscription.cancel();
    _onClientChangedSubscription.cancel();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Clientes"),
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),

      body: new Center(
        child: ListView.builder(
          itemCount: items.length,
          padding: EdgeInsets.only(top: 12.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 7.0,),
                Row(
                  children: <Widget>[
                    Expanded(child: ListTile(title: Text('${items[position].name}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 21.0,
                      ),
                    ),

                    subtitle:
                    Text('${items[position].job}',
                      style: TextStyle(
                      color: Colors.grey,
                      fontSize: 21.0,
                      ),
                    ),
                    leading:
                        Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.orangeAccent,
                              radius: 17.0,
                              child:
                              Text('${position+1}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 21.0,
                                ),
                              ),
                            )
                          ],
                        ),
                    onTap: () => _navigateToClientInformation(context, items[position]),
                    ),
                    ),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,),
                        onPressed: () => _deleteClient(context,items[position],position)),
                    IconButton(
                        icon: Icon(Icons.edit, color: Colors.lightBlueAccent,),
                        onPressed: () => _navigateToClient(context,items[position])),
                  ],
                ),
                Divider(height: 8.0,color: Colors.orangeAccent,thickness: 1.0,),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.orangeAccent,),
        backgroundColor: Colors.white,
        onPressed: () => _createNewClient(context),
      ),
    );
  }
  void _createNewClient(BuildContext context) async {
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) =>ClientScreen(Client(null, '', '', ''))),
    );
  }
  void _onClientAdded (Event event){
    setState(() {
      items.add(new Client.fromSnapShot(event.snapshot));
    });
  }
  void _onClientUpdate (Event event){
    var oldClientValue = items.singleWhere((client) => client.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldClientValue)] = new Client.fromSnapShot(event.snapshot);
    });
  }

  void _deleteClient(BuildContext context, Client client, int position)async{
    await clientReference.child(client.id).remove().then((_){
      setState(() {
        items.removeAt(position);
      });
    });

  }

  void _navigateToClient(BuildContext context, Client client)async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ClientScreen(client)),
    );
  }

  void _navigateToClientInformation(BuildContext context, Client client)async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ClientInformation(client)),
    );
  }

}