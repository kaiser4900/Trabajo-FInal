import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:flutter_app_final/model/sale.dart';
import 'package:flutter_app_final/pages/sale_screen.dart';
import 'package:flutter_app_final/pages/sale_information.dart';


class ListViewSale extends StatefulWidget {
  @override
  _ListViewSaleState createState() => _ListViewSaleState();
}

final saleReference = FirebaseDatabase.instance.reference().child('sale');

class _ListViewSaleState extends State<ListViewSale> {

  List<Sale> items;
  StreamSubscription<Event> _onSaleAddedSubscription;
  StreamSubscription<Event> _onSaleChangedSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    items = new List();
    _onSaleAddedSubscription =
        saleReference.onChildAdded.listen(_onSaleAdded);
    _onSaleChangedSubscription =
        saleReference.onChildChanged.listen(_onSaleUpdate);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _onSaleAddedSubscription.cancel();
    _onSaleChangedSubscription.cancel();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: new Text("Ventas"),
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
                    Expanded(child: ListTile(title: Text('${items[position].product}'+' - '+'${items[position].client}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 21.0,
                      ),
                    ),

                      subtitle:
                      Text('${items[position].branch}',
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
                      onTap: () => _navigateToSaleInformation(context, items[position]),
                    ),
                    ),
                    IconButton(
                        icon: Icon(Icons.delete, color: Colors.red,),
                        onPressed: () => _deleteSale(context,items[position],position)),
                    IconButton(
                        icon: Icon(Icons.edit, color: Colors.lightBlueAccent,),
                        onPressed: () => _navigateToSale(context,items[position])),
                  ],
                ),
                Divider(height: 8.0,color: Colors.orangeAccent,thickness: 1.0,),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_shopping_cart, color: Colors.orangeAccent,),
        backgroundColor: Colors.white,
        onPressed: () => _createNewSale(context),
      ),
    );
  }
  void _createNewSale(BuildContext context) async {
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) =>SaleScreen(Sale(null, '', '', '',''))),
    );
  }
  void _onSaleAdded (Event event){
    setState(() {
      items.add(new Sale.fromSnapShot(event.snapshot));
    });
  }
  void _onSaleUpdate (Event event){
    var oldSaleValue = items.singleWhere((sale) => sale.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldSaleValue)] = new Sale.fromSnapShot(event.snapshot);
    });
  }

  void _deleteSale(BuildContext context, Sale sale, int position)async{
    await saleReference.child(sale.id).remove().then((_){
      setState(() {
        items.removeAt(position);
      });
    });

  }

  void _navigateToSale(BuildContext context, Sale sale)async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => SaleScreen(sale)),
    );
  }

  void _navigateToSaleInformation(BuildContext context, Sale sale)async{
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) => SaleInformation(sale)),
    );
  }

}